//
//  VCLFACancelledDetail.m
//  Salt
//
//  Created by Rick Royd Aban on 7/15/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "VCLFACancelledDetail.h"

@interface VCLFACancelledDetail(){
    
    IBOutlet UITextField *_propFieldType;
    IBOutlet UITextField *_propFieldStatus;
    IBOutlet UITextField *_propFieldStaff;
    IBOutlet UITextField *_propFieldDateFrom;
    IBOutlet UITextField *_propFieldDateTo;
    IBOutlet UITextField *_propFieldDays;
    IBOutlet UITextField *_propFieldWorkDays;
    IBOutlet UITextField *_propFieldCancelledBy;
    IBOutlet UITextView *_propFieldNotes;
}
@end

@implementation VCLFACancelledDetail

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
    _propFieldWorkDays.text = [NSString stringWithFormat:@"%.1f",[_propLeave propWorkingDays]];
    _propFieldCancelledBy.text = [_propLeave propApproverName];
    _propFieldNotes.text = [_propLeave propNotes];
}

@end
