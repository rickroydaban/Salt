//
//  VCLeavesForApprovalPending.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/11/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPage.h"
#import "VelosiPickerRowSelectionDelegate.h"
#import "LoaderDelegate.h"

@interface VCLeavesForApprovalPending : VCPage<UITableViewDelegate, UITableViewDataSource, VelosiPickerRowSelectionDelegate, UITextFieldDelegate, LoaderDelegate, UIAlertViewDelegate>

- (void)approveLeaveAtIndex:(int)index;
- (void)rejectLeaveAtIndex:(int)index;

@end
