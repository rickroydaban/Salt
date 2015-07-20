//
//  CellLFACancelled.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/15/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCLeavesForApprovalCancelled.h"

@interface CellLFACancelled : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *propLabelType;
@property (strong, nonatomic) IBOutlet UILabel *propLabelDuration;
@property (strong, nonatomic) IBOutlet UILabel *propLabelStaff;

- (void)assignLeavesForApprovalCancelled:(VCLeavesForApprovalCancelled *)vcLeavesForApprovalCancelled;

@end
