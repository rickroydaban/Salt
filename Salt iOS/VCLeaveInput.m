//
//  VCLeaveInput.m
//  Salt
//
//  Created by Rick Royd Aban on 6/26/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#define HEADERSPINNERTYPE @"Select Leave Type"
#define HEADERSPINNERNUMDDAYS @"Select Days"
#define LONGONEDAY 86400
#define SUN 1
#define MON 2
#define TUE 3
#define WED 4
#define THU 5
#define FRI 6
#define SAT 7

#import "VCLeaveInput.h"
#import "VelosiDatePicker.h"
#import "MBProgressHUD.h"
#import "VelosiCustomPicker.h"
#import "LocalHoliday.h"

@interface VCLeaveInput(){
    
    IBOutlet UITextField *_propFieldLeaveType;
    IBOutlet UITextField *_propFieldStaff;
    IBOutlet UITextField *_propFieldDateStart;
    IBOutlet UITextField *_propFieldDateEnd;
    IBOutlet UITextField *_propFieldNumDays;
    IBOutlet UITextField *_propFieldDays;
    IBOutlet UITextField *_propFieldNumHolidays;
    IBOutlet UITextField *_propFieldWorkDays;
    IBOutlet UITextField *_propFieldRemCredits;
    IBOutlet UITextView *_propFieldNotes;
    IBOutlet UIBarButtonItem *_propButttonSave;
    
    UIPickerView *_pickerType, *_pickerDays;
    UIDatePicker *_datePickerDateFrom, *_datePickerDateTo;
    
    NSMutableDictionary *_daysMap;
    NSMutableArray *_days, *_typeItems;
    BOOL _isDateToSelectable;
    
    NSString *_oldLeaveJSON;
    Leave *_toBeCreatedLeave;
}
@end

@implementation VCLeaveInput

- (void)viewDidLoad{
    [super viewDidLoad];
    _days = [NSMutableArray array];
    _daysMap = [NSMutableDictionary dictionary];
    [_days addObject:HEADERSPINNERNUMDDAYS];
    [_days addObject:LEAVE_HALFDAY_AM];
    [_daysMap setObject:@(0.1) forKey:LEAVE_HALFDAY_AM];
    [_days addObject:LEAVE_HALFDAY_PM];
    [_daysMap setObject:@(0.1) forKey:LEAVE_HALFDAY_PM];
    [_days addObject:LEAVE_ONEDAY];
    [_daysMap setObject:@(1.0) forKey:@"1.0"];
    
    for(float i=2; i<=30; i++){
        NSString *daysString = [NSString stringWithFormat:@"%.1f Days",i];
        [_days addObject:daysString];
        [_daysMap setObject:@(i) forKey:daysString];
    }
    
    _typeItems = [NSMutableArray array];
    [_typeItems addObject:HEADERSPINNERTYPE];
    [_typeItems addObjectsFromArray:[Leave propTypeDescriptionListhasAll:NO]];

    if(_propLeave != nil){
        self.navigationItem.title = @"Edit Leave";
        _pickerType = [[VelosiCustomPicker alloc] initWithArray:_typeItems rowSelectionDelegate:self selectedItem:[_propLeave propTypeDescription]];
        _pickerDays = [[VelosiCustomPicker alloc] initWithArray:_days rowSelectionDelegate:self selectedItem:[NSString stringWithFormat:@"%.1f",[_propLeave propDays]]];
        _datePickerDateFrom = [[VelosiDatePicker alloc] initWithDate:[self.propAppDelegate.propFormatVelosiDate dateFromString:[_propLeave propStartDate]] minimumDate:nil viewController:self action:@selector(onDateFromSet)];
        _datePickerDateTo = [[VelosiDatePicker alloc] initWithDate:[self.propAppDelegate.propFormatVelosiDate dateFromString:[_propLeave propEndDate]] minimumDate:nil viewController:self action:@selector(onDateToSet)];
        
        _propFieldLeaveType.text = [_propLeave propTypeDescription];
        _propFieldStaff.text = [_propLeave propStaffName];
        _propFieldDateStart.text = [_propLeave propStartDate];
        _propFieldDateEnd.text = [_propLeave propEndDate];
        NSString *selectedDay = [_daysMap allKeysForObject:[NSString stringWithFormat:@"%.1f",[_propLeave propDays]]][0];;
        _propFieldNumDays.text = selectedDay;
        _propFieldDays.text = [selectedDay componentsSeparatedByString:@" "][0];
        float holidays = [_propFieldDays.text floatValue] - [_propLeave propWorkingDays];
        _propFieldNumHolidays.text = [NSString stringWithFormat:@"%.1f",(holidays>0 && holidays<1)?1:holidays];
        _propFieldWorkDays.text = [NSString stringWithFormat:@"%.1f",[_propLeave propWorkingDays]];
        [self updateRemCredits:[_propLeave propTypeDescription]];
        _propFieldNotes.text = [_propLeave propNotes];
        _isDateToSelectable = YES;
    }else{
        self.navigationItem.title = @"New Leave Request";
        _pickerType = [[VelosiCustomPicker alloc] initWithArray:_typeItems rowSelectionDelegate:self selectedItem:nil];
        _pickerDays = [[VelosiCustomPicker alloc] initWithArray:_days rowSelectionDelegate:self selectedItem:nil];
        _datePickerDateFrom = [[VelosiDatePicker alloc] initWithDate:[NSDate date] minimumDate:nil viewController:self action:@selector(onDateFromSet)];
        _datePickerDateTo = [[VelosiDatePicker alloc] initWithDate:[NSDate date] minimumDate:nil viewController:self action:@selector(onDateToSet)];
        _isDateToSelectable = NO;
        _propFieldDateEnd.userInteractionEnabled = NO;
        _propFieldLeaveType.text = HEADERSPINNERTYPE;
        _propFieldNumDays.text = HEADERSPINNERNUMDDAYS;
        _propFieldStaff.text = [NSString stringWithFormat:@"%@ %@",[self.propAppDelegate.staff fname], [self.propAppDelegate.staff lname]];
    }
    
    _propFieldLeaveType.delegate = self;
    _propFieldDateStart.delegate = self;
    _propFieldDateEnd.delegate = self;
    _propFieldNumDays.delegate = self;
    _propFieldNotes.delegate = self;
}

- (IBAction)save:(id)sender {
    if(![_propFieldLeaveType.text isEqualToString:HEADERSPINNERTYPE]){
        if(_propFieldDateStart.text.length > 0){
            if(_propLeave == nil){ //new leave request
                _oldLeaveJSON = [Leave jsonFromNewEmptyLeave];
                _toBeCreatedLeave = [[Leave alloc] initWithStaff:self.propAppDelegate.staff staffRemVL:[self.propAppDelegate.staffLeaveCounter remainingVLDays] staffRemSL:[self.propAppDelegate.staffLeaveCounter remainingSLDays] typeID:[Leave propTypeKeyForDescription:_propFieldLeaveType.text] statusID:LEAVESTATUSID_PENDING dateFrom:_propFieldDateStart.text dateTo:_propFieldDateEnd.text days:[[_daysMap objectForKey:_propFieldNumDays.text] floatValue] workingDays:[_propFieldWorkDays.text floatValue] notes:_propFieldNotes.text dateSubmitted:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[NSDate date]]];
            }else{ //edit leave
                _oldLeaveJSON = [_propLeave jsonString];
                [_propLeave editLeaveWithTypeID:[Leave propTypeKeyForDescription:_propFieldLeaveType.text] statusID:LEAVESTATUSID_PENDING remVL:[self.propAppDelegate.staffLeaveCounter remainingVLDays] remSL:[self.propAppDelegate.staffLeaveCounter remainingSLDays] dateFrom:_propFieldDateStart.text dateTo:_propFieldDateEnd.text days:[[_daysMap objectForKey:_propFieldDays.text] floatValue] workingDays:[_propFieldWorkDays.text floatValue] notes:_propFieldNotes.text dateSubmitted:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[NSDate date]]];
            }
            
            _propButttonSave.enabled = NO;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                id result = [self.propAppDelegate.propGatewayOnline saveLeaveWithNewLeaveJSON:(_toBeCreatedLeave!=nil)?[[_toBeCreatedLeave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:[[_propLeave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] oldLeaveJSON:[_oldLeaveJSON stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _propButttonSave.enabled = YES;
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self.view endEditing:YES];
                    if(result != nil)
                        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Failed to save leave %@",result] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                    else{
                        [[[UIAlertView alloc] initWithTitle:@"" message:(_toBeCreatedLeave!=nil)?@"Leave Submitted!":@"Leave Saved Successfully" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            id followupResult = [self.propAppDelegate.propGatewayOnline followupLeave:(_toBeCreatedLeave!=nil)?[_toBeCreatedLeave jsonString]:[_propLeave jsonString]];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if(followupResult != nil)
                                    [[[UIAlertView alloc] initWithTitle:@"" message:followupResult delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                            });
                        });
                    }
                });
            });

        }else{
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please select a starting date" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            [_propFieldDateStart becomeFirstResponder];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please select a leave type" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        [_propFieldLeaveType becomeFirstResponder];
    }
}

- (void)onDateFromSet{
    _propFieldDateStart.text = [self.propAppDelegate.propFormatVelosiDate stringFromDate:_datePickerDateFrom.date];
    [self onDateChanged:_propFieldDateStart dayPicker:nil];

    _isDateToSelectable = YES;
    _propFieldDateEnd.userInteractionEnabled = YES;
}

- (void)onDateToSet{
    _propFieldDateEnd.text = [self.propAppDelegate.propFormatVelosiDate stringFromDate:_datePickerDateTo.date];
    [self onDateChanged:_propFieldDateEnd dayPicker:nil];
}


- (void)pickerSelection:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickerType){
        [self updateRemCredits:[_typeItems objectAtIndex:row]];
    }else if(pickerView == _pickerDays){
        NSString *selDay = [_days objectAtIndex:row];
        _propFieldNumDays.text = selDay;
        float day = [[selDay componentsSeparatedByString:@" "][0] floatValue];
        long addableDays = (long)LONGONEDAY*((day<2)?0:day-1);
        NSDate *startDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:_propFieldDateStart.text];
        _propFieldDateEnd.text = [self.propAppDelegate.propFormatVelosiDate stringFromDate:[startDate dateByAddingTimeInterval:addableDays]];
        [self onDateChanged:_propFieldDateEnd dayPicker:pickerView];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [super textFieldDidBeginEditing:textField];
    
    if(textField == _propFieldLeaveType)
        textField.inputView = _pickerType;
    else if(textField == _propFieldDateStart){
        if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_VACATION]){
            _datePickerDateFrom.minimumDate = [NSDate date];
            _datePickerDateFrom.maximumDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[NSString stringWithFormat:@"30-Dec-%d",self.propAppDelegate.currYear+2]];
        }else if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_SICK]){
            _datePickerDateFrom.minimumDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[NSString stringWithFormat:@"01-Jan-%d",self.propAppDelegate.currYear-2]];
            _datePickerDateFrom.maximumDate = [NSDate date];
        }
       
        textField.inputView = _datePickerDateFrom;
    }else if(textField == _propFieldDateEnd && _isDateToSelectable){
        _datePickerDateTo.minimumDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:_propFieldDateStart.text];
        
        if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_VACATION]){
            _datePickerDateTo.maximumDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[NSString stringWithFormat:@"30-Dec-%d",self.propAppDelegate.currYear+2]];
        }else if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_SICK]){
            _datePickerDateTo.maximumDate = [NSDate date];
        }
        
        textField.inputView = _datePickerDateTo;
    }else if(textField == _propFieldNumDays)
        textField.inputView = _pickerDays;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"should change chracters in range");
    if(textField == _propFieldDateStart)
        NSLog(@"date start text value changed");
    else if(textField == _propFieldDateEnd)
        NSLog(@"date end text value changed");
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [super textViewDidBeginEditing:textView];
    if(textView == _propFieldNotes){
        
    }
}

- (void)updateRemCredits:(NSString *)selTypeDesc{
    _propFieldLeaveType.text = selTypeDesc;
    if(_propFieldNumDays.text.length > 0){
        float workDays = [[_propFieldWorkDays.text componentsSeparatedByString:@" "][0] floatValue];
        if([selTypeDesc isEqualToString:LEAVETYPEDESC_VACATION]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingVLDays] - workDays];
        else if([selTypeDesc isEqualToString:LEAVETYPEDESC_SICK]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingSLDays] - workDays];
        else if([selTypeDesc isEqualToString:LEAVETYPEDESC_BEREAVEMENT]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingBLDays] - workDays];
        else if([selTypeDesc isEqualToString:LEAVETYPEDESC_MATPAT]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingMatPatDays] - workDays];
        else if ([selTypeDesc isEqualToString:LEAVETYPEDESC_HOSPITALIZATION]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingHLDays] - workDays];
        else _propFieldRemCredits.text = @"0";
    }else{
        if([selTypeDesc isEqualToString:LEAVETYPEDESC_VACATION]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingVLDays]];
        else if([selTypeDesc isEqualToString:LEAVETYPEDESC_SICK]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingSLDays]];
        else if([selTypeDesc isEqualToString:LEAVETYPEDESC_BEREAVEMENT]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingBLDays]];
        else if([selTypeDesc isEqualToString:LEAVETYPEDESC_MATPAT]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingMatPatDays]];
        else if ([selTypeDesc isEqualToString:LEAVETYPEDESC_HOSPITALIZATION]) _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingHLDays]];
        else _propFieldRemCredits.text = @"0";
    }
}

- (void)onDateChanged:(UITextField *)textField dayPicker:(UIPickerView *)dayPicker{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id myLeaveResult = [self.propAppDelegate.propGatewayOnline myLeaves];
        id holidayResult = [self.propAppDelegate.propGatewayOnline localHolidays];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([myLeaveResult isKindOfClass:[NSString class]] || [holidayResult isKindOfClass:[NSString class]]){
                _propFieldDateStart.text = @"";
                _propFieldDateEnd.text = @"";
                _propFieldNumDays.text = [_days objectAtIndex:0];
                _propFieldNumHolidays.text = @"";
                _propFieldRemCredits.text = @"";
                _propFieldDays.text = @"";
                _propFieldWorkDays.text = @"";
            }else{
                if(_propFieldDateEnd.text.length<1){ //no updating of values yet. Just enable the disabled fields
                    BOOL hasHolidayOnStartDate = NO;
                    NSString *holidayName = @"Unspecified";
                    NSDate *startDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:_propFieldDateStart.text];
                    for(LocalHoliday *localHoliday in holidayResult){
                        if([[self.propAppDelegate.propFormatVelosiDate dateFromString:[localHoliday propDate]] compare:startDate] == NSOrderedSame){
                            hasHolidayOnStartDate = YES;
                            holidayName = [localHoliday propName];
                            break;
                        }
                    }
                    
                    if(hasHolidayOnStartDate)
                        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Date selected is a holiday. (%@)",holidayName] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                    
                    _propFieldDateEnd.userInteractionEnabled = YES;
                    _propFieldNumDays.userInteractionEnabled = YES;
                }else{ //update fields
                    BOOL hasAlreadyFiledALeaveOnStartDate = false;
                    NSDate *startDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:_propFieldDateStart.text];
                    NSDate *endDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:_propFieldDateEnd.text];
                    
                    if([endDate compare:startDate] == NSOrderedAscending)
                        [self handleAutoCompleteFieldErrors:textField errorMessage:@"Date From must be before Date To"];
                    else{
                        //                    int interval = [endDate timeIntervalSinceDate:startDate]/LONGONEDAY;
                        for(Leave *leave in myLeaveResult){
                            //make sure to disable checking when the data being edited is the data itself
                            if(!(_propLeave!=nil && [_propLeave propLeaveID]==[leave propLeaveID])){
                                NSDate *leaveStartDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[leave propStartDate]];
                                NSDate *leaveEndDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[leave propEndDate]];
                                if([startDate compare:endDate]==NSOrderedSame && [startDate compare:[NSDate date]]!=NSOrderedSame){
                                    if([leaveStartDate compare:startDate]==NSOrderedSame && ([_propFieldNumDays.text isEqualToString:LEAVE_ONEDAY] || ([leave propDays]==0.1f&&[_propFieldNumDays.text isEqualToString:LEAVE_HALFDAY_AM]) || ([leave propDays]==0.2f&&[_propFieldNumDays.text isEqualToString:LEAVE_HALFDAY_PM]))){
                                        
                                        if([leave propStatusID] == LEAVESTATUSID_PENDING){
                                            hasAlreadyFiledALeaveOnStartDate = true;
                                            break;
                                        }
                                    }
                                }else{
                                    //dates within an interval
                                    if(([startDate compare:leaveStartDate]==NSOrderedSame || [endDate compare:leaveEndDate]==NSOrderedSame || ([startDate compare:leaveStartDate]==NSOrderedAscending&&[endDate compare:leaveEndDate]==NSOrderedDescending)) && [leave propStatusID]!=LEAVESTATUSID_REJECTED &&[leave propStatusID]!=LEAVESTATUSID_CANCELLED){
                                        
                                        hasAlreadyFiledALeaveOnStartDate = true;
                                        break;
                                    }
                                }
                            }
                        }
                        
                        NSMutableArray *holidaysIncluded = [NSMutableArray array];
                        for(LocalHoliday *holiday in holidayResult){
                            NSDate *holidayDate = [self.propAppDelegate.propFormatVelosiDate dateFromString:[holiday propDate]];
                            if([holidayDate compare:startDate]==NSOrderedSame || [holidayDate compare:endDate]==NSOrderedSame || ([holidayDate compare:startDate]==NSOrderedDescending && [holidayDate compare:endDate]==NSOrderedAscending)){
                                [holidaysIncluded addObject:[self.propAppDelegate.propFormatVelosiDate stringForObjectValue:holidayDate]];
                            }
                        }
                        
                        if(hasAlreadyFiledALeaveOnStartDate)
                            [self handleAutoCompleteFieldErrors:textField errorMessage:@"Already requested leave during dates/time specified"];
                        else{
                            if(holidaysIncluded.count > 0)//can actually proceed filing leave even if holiday specially fr special case scenarios
                                [[[UIAlertView alloc] initWithTitle:@"" message:@"Date interval has holiday(s)" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                            
                            NSLog(@"%@",[_propFieldNumDays.text componentsSeparatedByString:@" "][0]);
                            float incrementalDays = ([[_propFieldNumDays.text componentsSeparatedByString:@" "][0] isEqualToString:@"0.5"])?0.5:1;
                            int interval =(int)([endDate timeIntervalSinceDate:startDate]/LONGONEDAY);
                            
                            if(dayPicker == nil) //if set from numday picker
                                _propFieldNumDays.text = [_days objectAtIndex:interval+3];
                            
                            float workingDays = 0;
                            int applicableHolidayCtr = 0;//since holidays that fall on nonworking days does not count
                            NSCalendar *currCalendar = [NSCalendar currentCalendar];
                            NSCalendarUnit calendarUnits = (NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear);
                            NSDateComponents *comparableWorkingCalendar = [currCalendar components:calendarUnits fromDate:startDate];
                            comparableWorkingCalendar.calendar = currCalendar;
                            while([[comparableWorkingCalendar date] compare:endDate]==NSOrderedAscending || [[comparableWorkingCalendar date] compare:endDate]==NSOrderedSame){
                                NSDateComponents *tempCalendarComponents = [currCalendar components:calendarUnits fromDate:[comparableWorkingCalendar date]]; //have to add this so that the weekday component will be updated on the loop
                                if([tempCalendarComponents weekday]==MON && [self.propAppDelegate.staff hasMonday]) {//must be a working day before comparing if the date will be an applicable holiday
                                    if([holidaysIncluded containsObject:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[comparableWorkingCalendar date]]]) applicableHolidayCtr++;
                                    else workingDays+=incrementalDays;
                                }
                                
                                if([tempCalendarComponents weekday]==TUE && [self.propAppDelegate.staff hasTuesday]) {
                                    if([holidaysIncluded containsObject:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[comparableWorkingCalendar date]]]) applicableHolidayCtr++;
                                    else workingDays+=incrementalDays;
                                }
                                
                                if([tempCalendarComponents weekday]==WED && [self.propAppDelegate.staff hasWednesday]) {
                                    if([holidaysIncluded containsObject:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[comparableWorkingCalendar date]]]) applicableHolidayCtr++;
                                    else workingDays+=incrementalDays;
                                }
                                
                                if([tempCalendarComponents weekday]==THU && [self.propAppDelegate.staff hasThursday]) {
                                    if([holidaysIncluded containsObject:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[comparableWorkingCalendar date]]]) applicableHolidayCtr++;
                                    else workingDays+=incrementalDays;
                                }
                                
                                if([tempCalendarComponents weekday]==FRI && [self.propAppDelegate.staff hasFriday]) {
                                    if([holidaysIncluded containsObject:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[comparableWorkingCalendar date]]]) applicableHolidayCtr++;
                                    else workingDays+=incrementalDays;
                                }
                                
                                if([tempCalendarComponents weekday]==SAT && [self.propAppDelegate.staff hasSaturday]) {
                                    if([holidaysIncluded containsObject:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[comparableWorkingCalendar date]]]) applicableHolidayCtr++;
                                    else workingDays+=incrementalDays;
                                }
                                
                                if([tempCalendarComponents weekday]==SUN && [self.propAppDelegate.staff hasSunday]) {
                                    if([holidaysIncluded containsObject:[self.propAppDelegate.propFormatVelosiDate stringFromDate:[comparableWorkingCalendar date]]]) applicableHolidayCtr++;
                                    else workingDays+=incrementalDays;
                                }
                                
                                comparableWorkingCalendar.day++;
                            }   
                            
                            if(applicableHolidayCtr > 0)
                                [[[UIAlertView alloc] initWithTitle:@"" message:@"Date interval has holiday(s)" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                            
                            float selectedDays = [[_propFieldNumDays.text componentsSeparatedByString:@" "][0] floatValue];
                            _propFieldDays.text = [NSString stringWithFormat:@"%.1f",selectedDays];
                            _propFieldNumHolidays.text = [NSString stringWithFormat:@"%d",applicableHolidayCtr];
                            
                            if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_VACATION] && workingDays > [self.propAppDelegate.staff maxConsecutiveLeave])
                                [self handleAutoCompleteFieldErrors:textField errorMessage:@"Your leave cannot be processed as it is beyond the limits set"];
                            else{
                                _propFieldWorkDays.text = [NSString stringWithFormat:@"%.1f",workingDays];
                                if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_VACATION])
                                    _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingVLDays]-[[_propFieldWorkDays.text componentsSeparatedByString:@" "][0] floatValue]];
                                else if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_SICK])
                                    _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingSLDays]-[[_propFieldWorkDays.text componentsSeparatedByString:@" "][0] floatValue]];
                                else if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_BEREAVEMENT])
                                    _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingBLDays]-[[_propFieldWorkDays.text componentsSeparatedByString:@" "][0] floatValue]];
                                else if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_MATPAT])
                                    _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingMatPatDays]-[[_propFieldWorkDays.text componentsSeparatedByString:@" "][0] floatValue]];
                                else if([_propFieldLeaveType.text isEqualToString:LEAVETYPEDESC_HOSPITALIZATION])
                                    _propFieldRemCredits.text = [NSString stringWithFormat:@"%.1f",[self.propAppDelegate.staffLeaveCounter remainingHLDays]-[[_propFieldWorkDays.text componentsSeparatedByString:@" "][0] floatValue]];
                                else
                                    _propFieldRemCredits.text = @"0";
                            }
                        }
                        
                    }
                }
                
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });
}

- (void)handleAutoCompleteFieldErrors:(UITextField *)textField errorMessage:(NSString *)errorMessage{
    if(textField == _propFieldDateEnd){
        _propFieldDateStart.text = @"";
        _propFieldNumDays.userInteractionEnabled = NO;
        _propFieldDateEnd.userInteractionEnabled = NO;
    }
    
    _propFieldDateEnd.text = @"";
    _propFieldNumDays.text = [_days objectAtIndex:0];
    _propFieldDays.text = @"";
    _propFieldNumHolidays.text = @"";
    _propFieldRemCredits.text = @"";
    _propFieldWorkDays.text = @"";
    
    [[[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //this delegate is only intended for listening button clicked after leave submission success message will be dismissed
    [self.navigationController popViewControllerAnimated:YES];
}

@end
