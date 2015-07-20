//
//  CellLFAProcessed.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/15/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "CellLFAProcessed.h"

@interface CellLFAProcessed(){
    VCLeavesForApprovalProcessed *_vcLeavesForApprovalProcessed;
}
@end

@implementation CellLFAProcessed

- (void)assignLeavesForApprovalProcessed:(VCLeavesForApprovalProcessed *)vcLeavesForApprovalProcessed{
    _vcLeavesForApprovalProcessed = vcLeavesForApprovalProcessed;
}

- (IBAction)cancel:(id)sender {
    [_vcLeavesForApprovalProcessed cancelLeaveAtIndex:((UIButton *)sender).tag];
}

@end
