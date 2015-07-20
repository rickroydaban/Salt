//
//  CellLFAPending.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/11/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCLeavesForApprovalPending.h"

@interface CellLFAPending :UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *propLabelType;
@property (strong, nonatomic) IBOutlet UILabel *propLabelDuration;
@property (strong, nonatomic) IBOutlet UILabel *propLabelStaff;

@property (strong, nonatomic) IBOutlet UIButton *propButtonApprove;
@property (strong, nonatomic) IBOutlet UIButton *propButtonReject;

- (void)assignVCLeavesForApprovalPending:(VCLeavesForApprovalPending *)vcLeavesForApprovalPending;

@end
