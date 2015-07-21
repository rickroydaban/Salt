//
//  VCMonthlyHolidays.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/8/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCMonthlyHolidays.h"
#import "VelosiCustomPicker.h"
#import "MBProgressHUD.h"
#import "CellHoliday.h"
#import "Holiday.h"

@interface VCMonthlyHolidays (){
    
    IBOutlet UITextField *_fieldMonth;
    IBOutlet UITextField *_fieldYear;
    IBOutlet UIButton *_buttonPrev;
    IBOutlet UIButton *_buttonNext;
    
    IBOutlet UITableView *_propLV;
    
    NSArray *_months;
    NSMutableArray *_selectedMonthHolidays;
    NSCalendar *_calendar;
    
    UIPickerView *_pickerMonth, *_pickerYear;
    
}

@end

@implementation VCMonthlyHolidays

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    _selectedMonthHolidays = [NSMutableArray array];
    
    NSArray *monthYear = [[self.propAppDelegate.propDateFormatMonthyear stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
    _pickerMonth = [[VelosiCustomPicker alloc] initWithArray:_months rowSelectionDelegate:self selectedItem:monthYear[0]];
    _pickerYear = [[VelosiCustomPicker alloc] initWithArray:self.propAppDelegate.filterYears rowSelectionDelegate:self selectedItem:monthYear[1]];
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.delegate = self;
    _propLV.dataSource = self;
    _propLV.rowHeight = UITableViewAutomaticDimension;
    _propLV.estimatedRowHeight = 90;
    
    _fieldMonth.delegate = self;
    _fieldYear.delegate = self;
    
    _fieldMonth.text = monthYear[0];
    _fieldYear.text = monthYear[1];
    [self reloadAllHolidays];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellHoliday *cell = (CellHoliday *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    Holiday *holiday = [_selectedMonthHolidays objectAtIndex:indexPath.row];
    
    cell.propLabelName.text = [holiday name];
    cell.propLabelCountry.text = [holiday country];
    cell.propLabelDate.text = [holiday dateStr];
    cell.propTextViewOffices.text = [holiday officeStr];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectedMonthHolidays.count;
}

- (void)pickerSelection:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickerMonth){
        _fieldMonth.text = [_months objectAtIndex:row];
    }else if(pickerView == _pickerYear){
        _fieldYear.text = [self.propAppDelegate.filterYears objectAtIndex:row];
    }
    
    [self reloadSelectedMonthHolidays];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _fieldMonth)
        textField.inputView = _pickerMonth;
    else if(textField == _fieldYear)
        textField.inputView = _pickerYear;
}

- (IBAction)toggleList:(id)sender {
    [self.propAppDelegate.propSlider toggleSidebar];
}

- (IBAction)refresh:(id)sender {
    [self reloadAllHolidays];
}

- (void)reloadAllHolidays{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id result = [self.propAppDelegate.propGatewayOnline monthlyholidays];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([result isKindOfClass:[NSString class]])
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else
                [self.propAppDelegate updateMonthlyHolidays:result];
            
            [self reloadSelectedMonthHolidays];
        });
    });
}

- (void)reloadSelectedMonthHolidays{
    [_selectedMonthHolidays removeAllObjects];
    for(Holiday *holiday in [self.propAppDelegate monthlyHolidays]){
        if([[holiday monthName] isEqualToString:_fieldMonth.text] && [[holiday year] isEqualToString:_fieldYear.text]){
            [_selectedMonthHolidays addObject:holiday];
        }
    }
    
    [_propLV reloadData];
}

- (IBAction)prevMonth:(id)sender {
    NSDate *selectedDate = [self.propAppDelegate.propDateFormatMonthyear dateFromString:[NSString stringWithFormat:@"%@-%@",_fieldMonth.text,_fieldYear.text]];
    NSDateComponents *componentCurrMonth = [_calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:selectedDate];
    [componentCurrMonth setCalendar:_calendar];
    
    NSDate *minDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[NSString stringWithFormat:@"2-Jan-%@",self.propAppDelegate.filterYears[self.propAppDelegate.filterYears.count-1]]];
    NSLog(@"minDate %@ currDate %@",minDate, [componentCurrMonth date]);
    if([minDate compare:[componentCurrMonth date]] == NSOrderedAscending){
        
        componentCurrMonth.month = componentCurrMonth.month-1;
        NSArray *monthYear = [[self.propAppDelegate.propDateFormatMonthyear stringFromDate:[componentCurrMonth date]] componentsSeparatedByString:@"-"];
        _fieldMonth.text = [monthYear objectAtIndex:0];
        _fieldYear.text = [monthYear objectAtIndex:1];
    }
    
    [self reloadSelectedMonthHolidays];
}

- (IBAction)nextMonth:(id)sender {
    NSLog(@"next month");
    NSDate *selectedDate = [self.propAppDelegate.propDateFormatMonthyear dateFromString:[NSString stringWithFormat:@"%@-%@",_fieldMonth.text, _fieldYear.text]];
    NSDateComponents *componentCurrMonth = [_calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:selectedDate];
    componentCurrMonth.day = 32;
    [componentCurrMonth setCalendar:_calendar];
    
    NSDate *maxDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[NSString stringWithFormat:@"1-Jan-%d",[self.propAppDelegate.filterYears[0] intValue]+1]];
    NSLog(@"minDate %@ currDate %@",maxDate, [componentCurrMonth date]);
    if([maxDate compare:[componentCurrMonth date]] == NSOrderedDescending){
        
        componentCurrMonth.month = componentCurrMonth.month+1;
        componentCurrMonth.month = componentCurrMonth.month-1; //must have these iOS has weird bug that when you add one month it adds to instead
        NSArray *monthYear = [[self.propAppDelegate.propDateFormatMonthyear stringFromDate:[componentCurrMonth date]] componentsSeparatedByString:@"-"];
        _fieldMonth.text = [monthYear objectAtIndex:0];
        _fieldYear.text = [monthYear objectAtIndex:1];
    }
    
    [self reloadSelectedMonthHolidays];
}


@end
