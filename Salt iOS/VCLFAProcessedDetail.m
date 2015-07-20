//
//  VCLFAProcessedDetail.m
//  Salt
//
//  Created by Rick Royd Aban on 7/15/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "VCLFAProcessedDetail.h"
#import "MBProgressHUD.h"

@interface VCLFAProcessedDetail(){
    
    IBOutlet UITextField *_propFieldType;
    IBOutlet UITextField *_propFieldStatus;
    IBOutlet UITextField *_propFieldStaff;
    IBOutlet UITextField *_propFieldDateFrom;
    IBOutlet UITextField *_propFieldDateTo;
    IBOutlet UITextField *_propFieldDays;
    IBOutlet UITextField *_propFieldWorkDays;
    IBOutlet UITextField *_propFieldProcessedBy;
    IBOutlet UILabel *_propLabelProcessedBy;
    IBOutlet UITextView *_propFieldNotes;
    IBOutlet UIBarButtonItem *_propButtonCancel;
}
@end

@implementation VCLFAProcessedDetail

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _propFieldType.text = [_propLeave propTypeDescription];
    _propFieldStatus.text = [_propLeave propStatusDescription];
    _propFieldStaff.text = [_propLeave propStaffName];
    _propFieldDateFrom.text = [_propLeave propStartDate];
    _propFieldDateTo.text = [_propLeave propEndDate];
    if([_propLeave propDays] >= 1) _propFieldDays.text = [NSString stringWithFormat:@"%0.1f",[_propLeave propDays]];
    else if([_propLeave propDays] > 0.1f) _propFieldDays.text = LEAVE_HALFDAY_PM;
    else _propFieldDays.text = LEAVE_HALFDAY_AM;
    _propFieldWorkDays.text = [NSString stringWithFormat:@"%.1f", [_propLeave propWorkingDays]];

    _propLabelProcessedBy.text = ([_propLeave propStatusID] == LEAVESTATUSID_APPROVED)?@"Approved By":@"Rejected By";
    _propFieldProcessedBy.text = [_propLeave propApproverName];
    _propFieldNotes.text = [_propLeave propNotes];
    
    if([_propLeave propStatusID] == LEAVESTATUSID_REJECTED){
        _propButtonCancel.title = @"";
        _propButtonCancel.enabled = false;
    }
}

- (IBAction)cancel:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_propLeave cancelLeaveFromStaff:self.propAppDelegate.staff now:[self.propAppDelegate.propDateFormatDateTime stringFromDate:[NSDate date]]];
        NSString *result = [self.propAppDelegate.propGatewayOnline processLeaveJSON:[[_propLeave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forStatusID:LEAVESTATUSID_CANCELLED];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(result != nil)
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Leave Cancelled" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"dismiss");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
