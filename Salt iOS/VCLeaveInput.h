//
//  VCLeaveInput.h
//  Salt
//
//  Created by Rick Royd Aban on 6/26/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "VCDetail.h"
#import "Leave.h"
#import "VelosiPickerRowSelectionDelegate.h"

@interface VCLeaveInput : VCDetail<UITextFieldDelegate, VelosiPickerRowSelectionDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Leave *propLeave;

@end
