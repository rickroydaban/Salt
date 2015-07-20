//
//  VCLogin.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/25/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPage.h"

@interface VCLogin : VCPage<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *propFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *propFieldPassword;
@property (strong, nonatomic) IBOutlet UIButton *propButtonLogin;


@end
