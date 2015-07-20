//
//  VCLFAPendingDetail.m
//  Salt
//
//  Created by Rick Royd Aban on 7/15/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "VCLFAPendingDetail.h"
#import "MBProgressHUD.h"

@interface VCLFAPendingDetail(){
    
    IBOutlet UITextField *_propFieldType;
    IBOutlet UITextField *_propFieldStatus;
    IBOutlet UITextField *_propFieldStaff;
    IBOutlet UITextField *_propFieldDateFrom;
    IBOutlet UITextField *_propFieldDateTo;
    IBOutlet UITextField *_propFieldDays;
    IBOutlet UITextField *_propFieldWorkDays;
    IBOutlet UITextField *_propFieldPrimaryApprover;
    IBOutlet UITextView *_propFieldNotes;
    
    UIBarButtonItem *_propButtonReject, *_propButtonApprove;
    UIAlertView *rejectDialog;
}
@end

@implementation VCLFAPendingDetail

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _propButtonApprove = [[UIBarButtonItem alloc] initWithTitle:@"Approve" style:UIBarButtonItemStylePlain target:self action:@selector(approve)];
    _propButtonReject = [[UIBarButtonItem alloc] initWithTitle:@"Reject" style:UIBarButtonItemStylePlain target:self action:@selector(reject)];
    self.navigationItem.rightBarButtonItems = @[_propButtonApprove, _propButtonReject];
    
    _propFieldType.text = [_propLeave propTypeDescription];
    _propFieldStatus.text = [_propLeave propStatusDescription];
    _propFieldStaff.text = [_propLeave propStaffName];
    _propFieldDateFrom.text = [_propLeave propStartDate];
    _propFieldDateTo.text = [_propLeave propEndDate];
    if([_propLeave propDays] >= 1) _propFieldDays.text = [NSString stringWithFormat:@"%0.1f",[_propLeave propDays]];
    else if([_propLeave propDays] > 0.1f) _propFieldDays.text = LEAVE_HALFDAY_PM;
    else _propFieldDays.text = LEAVE_HALFDAY_AM;
    _propFieldWorkDays.text = [NSString stringWithFormat:@"%.1f", [_propLeave propWorkingDays]];
    _propFieldPrimaryApprover.text = [_propLeave propLeaveApprover1Name];
    _propFieldNotes.text = [_propLeave propNotes];
}

- (void)approve{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_propLeave approveLeaveFromStaff:self.propAppDelegate.staff now:[self.propAppDelegate.propDateFormatDateTime stringFromDate:[NSDate date]]];
        NSString *result = [self.propAppDelegate.propGatewayOnline processLeaveJSON:[[_propLeave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forStatusID:LEAVESTATUSID_APPROVED];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(result != nil)
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Leave Approved" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        });
    });    
}

- (void)reject{
    rejectDialog = [[UIAlertView alloc] initWithTitle:@"" message:@"Reason for rejection" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Reject", nil];
    rejectDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [rejectDialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == rejectDialog){
        if(buttonIndex == 1){ //reject
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [_propLeave rejectLeaveFromStaff:self.propAppDelegate.staff withNotes:[alertView textFieldAtIndex:0].text now:[self.propAppDelegate.propDateFormatDateTime stringFromDate:[NSDate date]]];
                NSString *result = [self.propAppDelegate.propGatewayOnline processLeaveJSON:[[_propLeave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forStatusID:LEAVESTATUSID_REJECTED];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if(result != nil)
                        [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                    else{
                        [[[UIAlertView alloc] initWithTitle:@"" message:@"Leave Rejected" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                    }
                });
            });
        }
    }else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
