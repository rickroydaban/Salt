//
//  CellLFAProcessed.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/15/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCLeavesForApprovalProcessed.h"

@interface CellLFAProcessed : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *propLabelType;
@property (strong, nonatomic) IBOutlet UILabel *propLabelDuration;
@property (strong, nonatomic) IBOutlet UILabel *propLabelStaff;
@property (strong, nonatomic) IBOutlet UIButton *propButtonCancel;

- (void)assignLeavesForApprovalProcessed:(VCLeavesForApprovalProcessed *)vcLeavesForApprovalProcessed;

@end
