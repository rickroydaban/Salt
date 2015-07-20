//
//  CellLFACancelled.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/15/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "CellLFACancelled.h"

@interface CellLFACancelled(){
    VCLeavesForApprovalCancelled *_vcLeavesForApprovalCancelled;
}
@end

@implementation CellLFACancelled

- (void)assignLeavesForApprovalCancelled:(VCLeavesForApprovalCancelled *)vcLeavesForApprovalCancelled{
    _vcLeavesForApprovalCancelled = vcLeavesForApprovalCancelled;
}

@end
