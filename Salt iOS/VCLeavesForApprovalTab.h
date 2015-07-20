//
//  VCLeavesForApprovalTab.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/11/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCLeavesForApprovalPending.h"

@interface VCLeavesForApprovalTab : UITabBarController

@property (strong, nonatomic) NSMutableArray *propLeavesForApproval;

- (void)setCurrentLoaderDelegate:(id<LoaderDelegate>)loaderDelegate;
- (void)reloadLeavesForApprovalList;

@end
