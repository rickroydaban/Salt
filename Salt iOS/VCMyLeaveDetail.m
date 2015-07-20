//
//  VCMyLeaveDetail.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/28/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#define HEADERSPINNERTYPE @"Select Leave Type"
#define HEADERSPINNERNUMDDAYS @"Select Days"
#define HALFDAY_AM @"0.5 AM"
#define HALFDAY_PM @"0.5 PM"
#define ONEDAYLEAVE @"1.0 Day"

#import "VCMyLeaveDetail.h"
#import "VelosiDatePicker.h"
#import "MBProgressHUD.h"
#import "VelosiCustomPicker.h"
#import "VCLeaveInput.h"

@interface VCMyLeaveDetail (){
    IBOutlet UITextField *_propFieldLeaveType;
    IBOutlet UITextField *_propFieldLeaveStatus;
    IBOutlet UITextField *_propFieldStaff;
    IBOutlet UITextField *_propFieldDateFrom;
    IBOutlet UITextField *_propFieldDateTo;
    IBOutlet UITextField *_propFieldDays;
    IBOutlet UITextField *_propFieldWorkingDays;
    IBOutlet UITextView *_propTextViewNotes;
    IBOutlet UIButton *_propButtonFollowup;

    NSMutableDictionary *_daysMap;
    NSMutableArray *_days;
}

@end

@implementation VCMyLeaveDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _days = [NSMutableArray array];
    _daysMap = [NSMutableDictionary dictionary];
    [_days addObject:HALFDAY_AM];
    [_daysMap setObject:@"0.1" forKey:HALFDAY_AM];
    [_days addObject:HALFDAY_PM];
    [_daysMap setObject:@"0.2" forKey:HALFDAY_PM];
    [_days addObject:ONEDAYLEAVE];
    
    for(float i=2; i<30; i++){
        NSString *dayValue = [NSString stringWithFormat:@"%.1f",i];
        NSString *dayString = [NSString stringWithFormat:@"%@ Days",dayValue];
        [_days addObject:dayString];
        [_daysMap setObject:dayValue forKey:dayString];
    }
    
    if(_propLeave != nil){
        self.navigationItem.title = @"Leave Details";

        _propFieldLeaveType.text = [_propLeave propTypeDescription];
        _propFieldLeaveStatus.text = [_propLeave propStatusDescription];
        _propFieldStaff.text = [_propLeave propStaffName];
        _propFieldDateFrom.text = [_propLeave propStartDate];
        _propFieldDateTo.text = [_propLeave propEndDate];
        _propFieldDays.text = [_daysMap allKeysForObject:[NSString stringWithFormat:@"%.1f",[_propLeave propDays]]][0];
        _propFieldWorkingDays.text = [NSString stringWithFormat:@"%.1f",[_propLeave propWorkingDays]];
        _propTextViewNotes.text = [_propLeave propNotes];
        _propButtonFollowup.hidden = ([_propLeave propStatusID] == LEAVESTATUSID_PENDING)?NO:YES;
        
        if([_propLeave propStatusID] == LEAVESTATUSID_PENDING) //can cancel leave for pending leaves
            self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editLeave)], [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelLeave)]];

    }else{
        _propButtonFollowup.hidden = YES;
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editLeave)]];
    }
    
    _propFieldLeaveType.delegate = self;
    _propFieldDateFrom.delegate = self;
    _propFieldDateTo.delegate = self;
    _propFieldDays.delegate = self;
    _propTextViewNotes.delegate = self;
}

- (IBAction)followUp:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *result = [self.propAppDelegate.propGatewayOnline followupLeave:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[_propLeave savableDictionary] options:0 error:nil] encoding:NSUTF8StringEncoding]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"" message:(result==nil)?@"Follow Up Email Sent Successfully":result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ((VCLeaveInput *)segue.destinationViewController).propLeave = _propLeave;
}

- (void)cancelLeave{
    [[[UIAlertView alloc] initWithTitle:@"" message:@"this module is still under development" delegate:nil cancelButtonTitle:@"Dimiss" otherButtonTitles:nil, nil] show];
}

- (void)editLeave{
    [self performSegueWithIdentifier:@"leavedetailtoeditleave" sender:nil];
}


@end
