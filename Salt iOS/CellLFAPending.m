//
//  CellLFAPending.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/11/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "CellLFAPending.h"
#import "Leave.h"

@interface CellLFAPending(){
    VCLeavesForApprovalPending *_vcLeavesForApprovalPending;
}
@end

@implementation CellLFAPending

- (void)assignVCLeavesForApprovalPending:(VCLeavesForApprovalPending *)vcLeavesForApprovalPending{
    _vcLeavesForApprovalPending = vcLeavesForApprovalPending;
}

- (IBAction)approve:(id)sender {
    [_vcLeavesForApprovalPending approveLeaveAtIndex:((UIButton *)sender).tag];
}

- (IBAction)reject:(id)sender {
    [_vcLeavesForApprovalPending rejectLeaveAtIndex:((UIButton *)sender).tag];
}

@end
