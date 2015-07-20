//
//  VCLeavesForApprovalProcessed.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/15/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPage.h"
#import "VelosiPickerRowSelectionDelegate.h"
#import "LoaderDelegate.h"

@interface VCLeavesForApprovalProcessed : VCPage<UITableViewDelegate, UITableViewDataSource, VelosiPickerRowSelectionDelegate, UITextFieldDelegate, LoaderDelegate>

- (void)cancelLeaveAtIndex:(int)index;

@end
