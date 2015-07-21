//
//  VCMyCalendar.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/8/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCMyCalendar.h"
#import "VelosiCustomPicker.h"
#import "VelosiColors.h"
#import "MBProgressHUD.h"
#import "CellMyCalendarDate.h"
#import "CellMyCalendarEvent.h"
#import "CalendarItem.h"
#import "CalendarEvent.h"
#import "LocalHoliday.h"

@interface VCMyCalendar (){
    
    IBOutlet UITableView *_propLV;
    IBOutlet UITextField *_propFieldMonth;
    IBOutlet UITextField *_propFieldYear;
    UIPickerView *_pickerMonth, *_pickerYear;
    UIButton *_prevClickedCalendarCellButton;
    
    NSDateComponents *_dateToday;
    NSMutableArray *_monthItems, *_selEvents;
    NSMutableDictionary *_allEvents;
    NSDictionary *_weekDayNumRepresentation;
    NSArray *_months;
    NSCalendar *_calendar;
    NSDateFormatter *_dayOnlyFormatter;
    int _maxCells;
}

@end

@implementation VCMyCalendar

- (void)viewDidLoad {
    [super viewDidLoad];
    _weekDayNumRepresentation = @{@"Sun":@(1), @"Mon":@(0), @"Tue":@(-1), @"Wed":@(-2), @"Thu":@(-3), @"Fri":@(-4), @"Sat":@(-5)};
    _months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    _maxCells = 42;
    _monthItems = [NSMutableArray array];
    _allEvents = [NSMutableDictionary dictionary];
    _selEvents = [NSMutableArray array];
    NSArray *monthYear = [[self.propAppDelegate.propDateFormatMonthyear stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
    _pickerMonth = [[VelosiCustomPicker alloc] initWithArray:_months rowSelectionDelegate:self selectedItem:monthYear[0]];
    _pickerYear = [[VelosiCustomPicker alloc] initWithArray:self.propAppDelegate.filterYears rowSelectionDelegate:self selectedItem:monthYear[1]];
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.delegate = self;
    _propLV.dataSource = self;
    
    _propFieldMonth.delegate = self;
    _propFieldYear.delegate = self;

    _propFieldMonth.text = monthYear[0];
    _propFieldYear.text = monthYear[1];
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _dateToday = [_calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    _dayOnlyFormatter = [[NSDateFormatter alloc] init];
    _dayOnlyFormatter.dateFormat = @"d";
    [self reloadFromCache]; //need to reload to avoid npe
    [self reloadFromOnline];
}

- (void)reloadFromOnline{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id myleaveResult = [self.propAppDelegate.propGatewayOnline myLeaves];
        id holidayResult = [self.propAppDelegate.propGatewayOnline localHolidays];

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_allEvents removeAllObjects];
            if([holidayResult isKindOfClass:[NSString class]])
                [[[UIAlertView alloc] initWithTitle:@"" message:holidayResult delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else if([myleaveResult isKindOfClass:[NSString class]])
                [[[UIAlertView alloc] initWithTitle:@"" message:myleaveResult delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else{
                [self.propAppDelegate updateMyLeaves:myleaveResult];
                [self.propAppDelegate updateLocalHolidays:holidayResult];
            }
            for(LocalHoliday *holiday in [self.propAppDelegate localHolidays]){
                NSMutableArray *currEvents = ([_allEvents objectForKey:[holiday propDate]] != nil)?[_allEvents objectForKey:[holiday propDate]]:[NSMutableArray array];
                [currEvents addObject:[[CalendarEvent alloc] initWithName:[holiday propName] color:[VelosiColors colorHoliday] duration:AllDay shouldFill:YES]];
                [_allEvents setObject:currEvents forKey:[holiday propDate]];
            }
            
            for(Leave *leave in [self.propAppDelegate myLeaves]){
                NSDate *startDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[leave propStartDate]];
                NSDate *endDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[leave propEndDate]];
                NSDateComponents *componentDateStart = [_calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:startDate];
                NSDateComponents *componentDateEnd = [_calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:endDate];
                [componentDateStart setCalendar:_calendar];
                [componentDateEnd setCalendar:_calendar];
                
                while([[componentDateEnd date] compare:[componentDateStart date]] == NSOrderedSame || [[componentDateEnd date] compare:[componentDateStart date]] == NSOrderedDescending){
                    
                    NSString *currDate = [self.propAppDelegate.propFormatVelosiDate stringFromDate:[componentDateStart date]];
                    NSMutableArray *currEvents = ([_allEvents objectForKey:currDate] != nil)?[_allEvents objectForKey:currDate]:[NSMutableArray array];
                    NSString *desc = [leave propTypeDescription];
                    CalendarEventDuration duration;
                    if([leave propDays] == 0.1f) duration   = AM;
                    else if([leave propDays] == 0.2f) duration = PM;
                    else duration = AllDay;
                    
                    BOOL shouldFill = ([leave propStatusID] == LEAVESTATUSID_PENDING)?false:true;
                    
                    if([desc isEqualToString:LEAVETYPEDESC_VACATION])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeVacation] duration:duration shouldFill:shouldFill]];
                    else if([desc isEqualToString:LEAVETYPEDESC_SICK])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeSick] duration:duration shouldFill:shouldFill]];
                    else if([desc isEqualToString:LEAVETYPEDESC_BIRTHDAY])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeBirthday] duration:duration shouldFill:shouldFill]];
                    else if([desc isEqualToString:LEAVETYPEDESC_UNPAID])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeUnpaid] duration:duration shouldFill:shouldFill]];
                    else if([desc isEqualToString:LEAVETYPEDESC_BEREAVEMENT])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeBereavement] duration:duration shouldFill:shouldFill]];
                    else if([desc isEqualToString:LEAVETYPEDESC_MATPAT])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeMatPat] duration:duration shouldFill:shouldFill]];
                    else if([desc isEqualToString:LEAVETYPEDESC_DOCDENTIST])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeDoctor] duration:duration shouldFill:shouldFill]];
                    else if([desc isEqualToString:LEAVETYPEDESC_HOSPITALIZATION])
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeHospitalization] duration:duration shouldFill:shouldFill]];
                    else
                        [currEvents addObject:[[CalendarEvent alloc] initWithName:desc color:[VelosiColors colorLeaveTypeBusinessTrip] duration:duration shouldFill:shouldFill]];
                    
                    [_allEvents setObject:currEvents forKey:currDate];
                    componentDateStart.day = componentDateStart.day + 1;
                }
                
                [self reloadFromCache];
            }
        });
    });
}

- (void)reloadFromCache{
    [_monthItems removeAllObjects];
    [_selEvents removeAllObjects];
    NSDate *selectedDate = [self.propAppDelegate.propDateFormatMonthyear dateFromString:[NSString stringWithFormat:@"%@-%@",_propFieldMonth.text,_propFieldYear.text]];
    NSDateComponents *componentCurrMonth = [_calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:selectedDate];
    [componentCurrMonth setCalendar:_calendar];
    //get how many days before this months starts with one
//    NSDateFormatter *weekdayDateFormatter = [[NSDateFormatter alloc] init];
//    weekdayDateFormatter.dateFormat = @"c"; //1 - sunday, 2-monday, 3-tuesday ...
    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc] init];
    tempDateFormatter.dateFormat = @"E";
//    int initInterval = 0-[[weekdayDateFormatter stringFromDate:selectedDate] intValue]+2;
    int initInterval = [[_weekDayNumRepresentation objectForKey:[tempDateFormatter stringFromDate:selectedDate]] intValue];
    int counter = 0;
    BOOL isOutMonth = YES;
    
    do{
        componentCurrMonth.day = initInterval;
        int day = [[_dayOnlyFormatter stringFromDate:[_calendar dateFromComponents:componentCurrMonth]] intValue];
        NSString *dateStr = [self.propAppDelegate.propFormatVelosiDate stringFromDate:[componentCurrMonth date]];
        if(day == 1) isOutMonth = !isOutMonth;
        CalendarItemTypes itemType;
        NSMutableArray *events;
        
        if(!isOutMonth){
            if(_dateToday.day==componentCurrMonth.day && _dateToday.month==componentCurrMonth.month && _dateToday.year==componentCurrMonth.year){
                itemType = TYPE_NOW;
                events = [_allEvents objectForKey:dateStr];
            }else{
                itemType = TYPE_DAYOFMONTH;
                events = [_allEvents objectForKey:dateStr];
                
//                if(![self.propAppDelegate.staff hasSunday] && [[weekdayDateFormatter stringFromDate:componentCurrMonth.date] intValue]==1) itemType = TYPE_NONWORKINGDAY;
//                else if(![self.propAppDelegate.staff hasMonday] && [[weekdayDateFormatter stringFromDate:componentCurrMonth.date] intValue] == 2) itemType = TYPE_NONWORKINGDAY;
//                else if(![self.propAppDelegate.staff hasTuesday] && [[weekdayDateFormatter stringFromDate:componentCurrMonth.date] intValue] == 3) itemType = TYPE_NONWORKINGDAY;
//                else if(![self.propAppDelegate.staff hasWednesday] && [[weekdayDateFormatter stringFromDate:componentCurrMonth.date] intValue] == 4) itemType = TYPE_NONWORKINGDAY;
//                else if(![self.propAppDelegate.staff hasThursday] && [[weekdayDateFormatter stringFromDate:componentCurrMonth.date] intValue] == 5) itemType = TYPE_NONWORKINGDAY;
//                else if(![self.propAppDelegate.staff hasFriday] && [[weekdayDateFormatter stringFromDate:componentCurrMonth.date] intValue] == 6) itemType = TYPE_NONWORKINGDAY;
//                else if(![self.propAppDelegate.staff hasSaturday] && [[weekdayDateFormatter stringFromDate:componentCurrMonth.date] intValue] == 7) itemType = TYPE_NONWORKINGDAY;
                
                if(![self.propAppDelegate.staff hasSunday] && [[tempDateFormatter stringFromDate:componentCurrMonth.date] isEqualToString:@"Sun"]) itemType = TYPE_NONWORKINGDAY;
                else if(![self.propAppDelegate.staff hasMonday] && [[tempDateFormatter stringFromDate:componentCurrMonth.date] isEqualToString:@"Mon"]) itemType = TYPE_NONWORKINGDAY;
                else if(![self.propAppDelegate.staff hasTuesday] && [[tempDateFormatter stringFromDate:componentCurrMonth.date] isEqualToString:@"Tue"]) itemType = TYPE_NONWORKINGDAY;
                else if(![self.propAppDelegate.staff hasWednesday] && [[tempDateFormatter stringFromDate:componentCurrMonth.date] isEqualToString:@"Wed"]) itemType = TYPE_NONWORKINGDAY;
                else if(![self.propAppDelegate.staff hasThursday] && [[tempDateFormatter stringFromDate:componentCurrMonth.date] isEqualToString:@"Thu"]) itemType = TYPE_NONWORKINGDAY;
                else if(![self.propAppDelegate.staff hasFriday] && [[tempDateFormatter stringFromDate:componentCurrMonth.date] isEqualToString:@"Fri"]) itemType = TYPE_NONWORKINGDAY;
                else if(![self.propAppDelegate.staff hasSaturday] && [[tempDateFormatter stringFromDate:componentCurrMonth.date] isEqualToString:@"Sat"]) itemType = TYPE_NONWORKINGDAY;
            }
        }else{
            itemType = TYPE_OUTMONTH;
            events = [NSMutableArray array];
        }
        
        [_monthItems addObject:[[CalendarItem alloc ] initWithDay:day type:itemType events:events]];
        counter++;
        initInterval++;
    }while(counter < _maxCells);
    
    [_propLV reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return [tableView dequeueReusableCellWithIdentifier:@"headercell"];
    }else if(indexPath.row>0 && indexPath.row<7){
        CellMyCalendarDate *cell = (CellMyCalendarDate *)[tableView dequeueReusableCellWithIdentifier:@"datecell"];
        [cell assignVCMyCalendar:self]; //handles calendarbutton clickes
        
        long row = (indexPath.row-1)*7;
        [self manageCalendarItem:[_monthItems objectAtIndex:row] label:cell.propLabel1 containerView:cell.propContainer1];
        cell.propLabel1.superview.tag = row;
        [self manageCalendarItem:[_monthItems objectAtIndex:row+1] label:cell.propLabel2 containerView:cell.propContainer2];
        cell.propLabel2.superview.tag = row+1;
        [self manageCalendarItem:[_monthItems objectAtIndex:row+2] label:cell.propLabel3 containerView:cell.propContainer3];
        cell.propLabel3.superview.tag = row+2;
        [self manageCalendarItem:[_monthItems objectAtIndex:row+3] label:cell.propLabel4 containerView:cell.propContainer4];
        cell.propLabel4.superview.tag = row+3;
        [self manageCalendarItem:[_monthItems objectAtIndex:row+4] label:cell.propLabel5 containerView:cell.propContainer5];
        cell.propLabel5.superview.tag = row+4;
        [self manageCalendarItem:[_monthItems objectAtIndex:row+5] label:cell.propLabel6 containerView:cell.propContainer6];
        cell.propLabel6.superview.tag = row+5;
        [self manageCalendarItem:[_monthItems objectAtIndex:row+6] label:cell.propLabel7 containerView:cell.propContainer7];
        cell.propLabel7.superview.tag = row+6;
        
        return cell;
    }else{
        CellMyCalendarEvent *cell = (CellMyCalendarEvent *)[tableView dequeueReusableCellWithIdentifier:@"eventcell"];
        cell.propLabel.text = [(CalendarEvent *)[_selEvents objectAtIndex:indexPath.row-7] name];
        
        return cell;
    }
}

- (void)manageCalendarItem:(CalendarItem *)calendarItem label:(UILabel *)label containerView:(UIView *)containerView{
    [[containerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    label.text = [NSString stringWithFormat:@"%d",[calendarItem day]];
    
    if([calendarItem type]==TYPE_DAYOFMONTH || [calendarItem type]==TYPE_NONWORKINGDAY || [calendarItem type]==TYPE_NOW){
        float dimen = containerView.frame.size.height;
        float currRightEdge = containerView.frame.size.width;
        float marginRight = 2.0f;
        for(int i=0; i<[calendarItem events].count; i++){
            CalendarEvent *event = [[calendarItem events] objectAtIndex:i];
            CGRect frame;
            if([event duration] == AM) frame = CGRectMake(currRightEdge-dimen-marginRight, 0, dimen, dimen/2);
            else if([event duration] == PM) frame = CGRectMake(currRightEdge-dimen-marginRight, dimen/2, dimen, dimen/2);
            else frame = CGRectMake(currRightEdge-dimen-marginRight, 0, dimen, dimen);
                
            UIView *indicator = [[UIView alloc] initWithFrame:frame];
            [indicator setBackgroundColor:[event color]];
            [containerView addSubview:indicator];
            currRightEdge = currRightEdge-dimen-marginRight;
        }
        
        if([calendarItem type] == TYPE_DAYOFMONTH) label.textColor = [VelosiColors blackFont];
        else if([calendarItem type] == TYPE_NOW) label.textColor = [VelosiColors orangeVelosi];
        else if([calendarItem type] == TYPE_NONWORKINGDAY) label.textColor = [UIColor lightGrayColor];
    }else
        label.textColor = [UIColor lightGrayColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7+_selEvents.count; //6 rows for dates and additional 1 row for the header
}

- (IBAction)toggleList:(id)sender {
    [self.propAppDelegate.propSlider toggleSidebar];
}

- (IBAction)refresh:(id)sender {
    [self reloadFromOnline];
}

- (void)calendarItemClicked:(UIButton *)clickedCalendarCellButton{
    CalendarItem *calendarItem = [_monthItems objectAtIndex:clickedCalendarCellButton.superview.tag];

    if([calendarItem type]!=TYPE_OUTMONTH){
        if(_prevClickedCalendarCellButton != nil && _prevClickedCalendarCellButton!=clickedCalendarCellButton)
            _prevClickedCalendarCellButton.superview.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _prevClickedCalendarCellButton = clickedCalendarCellButton;
        
        //add events
        [_selEvents removeAllObjects];
        [_selEvents addObjectsFromArray:[calendarItem events]];
        [_propLV reloadData];
    }else
        clickedCalendarCellButton.superview.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _propFieldMonth){
        textField.inputView = _pickerMonth;
    }else if(textField == _propFieldYear)
        textField.inputView = _pickerYear;
}

- (void)pickerSelection:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickerMonth)
        _propFieldMonth.text = [_months objectAtIndex:row];
    else if(pickerView == _pickerYear)
        _propFieldYear.text = [self.propAppDelegate.filterYears objectAtIndex:row];
    
    [self reloadFromCache];
}

- (IBAction)prev:(id)sender {
    NSDate *selectedDate = [self.propAppDelegate.propDateFormatMonthyear dateFromString:[NSString stringWithFormat:@"%@-%@",_propFieldMonth.text,_propFieldYear.text]];
    NSDateComponents *componentCurrMonth = [_calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:selectedDate];
    [componentCurrMonth setCalendar:_calendar];
    
    NSDate *minDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[NSString stringWithFormat:@"2-Jan-%@",self.propAppDelegate.filterYears[self.propAppDelegate.filterYears.count-1]]];
    if([minDate compare:[componentCurrMonth date]] == NSOrderedAscending){

        componentCurrMonth.month = componentCurrMonth.month-1;
        NSArray *monthYear = [[self.propAppDelegate.propDateFormatMonthyear stringFromDate:[componentCurrMonth date]] componentsSeparatedByString:@"-"];
        _propFieldMonth.text = [monthYear objectAtIndex:0];
        _propFieldYear.text = [monthYear objectAtIndex:1];
    }
    
    [self reloadFromCache];
}

- (IBAction)next:(id)sender {
    NSDate *selectedDate = [self.propAppDelegate.propDateFormatMonthyear dateFromString:[NSString stringWithFormat:@"%@-%@",_propFieldMonth.text,_propFieldYear.text]];
    NSDateComponents *componentCurrMonth = [_calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:selectedDate];
    componentCurrMonth.day = 32;
    [componentCurrMonth setCalendar:_calendar];

    NSDate *maxDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[NSString stringWithFormat:@"1-Jan-%d",[self.propAppDelegate.filterYears[0] intValue]+1]];
    if([maxDate compare:[componentCurrMonth date]] == NSOrderedDescending){

        componentCurrMonth.month = componentCurrMonth.month+1;
        componentCurrMonth.month = componentCurrMonth.month-1; //must have these iOS has weird bug that when you add one month it adds to instead
        NSArray *monthYear = [[self.propAppDelegate.propDateFormatMonthyear stringFromDate:[componentCurrMonth date]] componentsSeparatedByString:@"-"];
        _propFieldMonth.text = [monthYear objectAtIndex:0];
        _propFieldYear.text = [monthYear objectAtIndex:1];
    }
    
    [self reloadFromCache];
}

@end
