//
//  VCLogin.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/25/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#define KEYBOARDTEXTFIELDMINOFFSET 10

#import "VCLogin.h"
#import "VelosiColors.h"
#import "MBProgressHUD.h"

@interface VCLogin(){
    UITapGestureRecognizer *_viewTappedRecognizer;
    IBOutlet UIView *containerview;
    UITextField *_currFocusedField;
}
@end

@implementation VCLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [VelosiColors orange];
    _viewTappedRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped)];
    [self.view addGestureRecognizer:_viewTappedRecognizer];
    
    self.propFieldUsername.delegate = self;
    self.propFieldPassword.delegate = self;
    
    self.propFieldUsername.borderStyle = UITextBorderStyleRoundedRect;
    self.propFieldPassword.borderStyle = UITextBorderStyleRoundedRect;
    self.propFieldUsername.text = [self.propAppDelegate.propGatewayOffline getPrevUsername];
    //    self.fieldUsername.text = @"admin@blandyuk.co.uk";
    //    self.fieldPassword.text = @"redROSE1982";
    
    self.propButtonLogin.layer.borderWidth = 2;
    self.propButtonLogin.layer.borderColor = [VelosiColors orangeDark].CGColor;
    self.propButtonLogin.layer.cornerRadius = 5;
    self.propButtonLogin.backgroundColor = [VelosiColors orangeVelosi];
    
    [self registerForKeyboardNotifications];
}

- (void)onViewTapped{
    [self.view endEditing:YES];
}

- (IBAction)login:(id)sender {
    if(self.propFieldUsername.text.length > 0){
        if(self.propFieldPassword.text.length > 0){
            [self.propAppDelegate.propGatewayOffline updatePreviouslyUsedUsername:self.propFieldUsername.text];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                id result = [self.propAppDelegate.propGatewayOnline authenticateUsername:self.propFieldUsername.text password:self.propFieldPassword.text];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *parts = [result componentsSeparatedByString:@"-"];
                    if(parts.count == 3){
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            NSString *loggedinResult = [self.propAppDelegate.propGatewayOnline initializeDataWithStaffID:[[parts objectAtIndex:0] intValue] securityLevel:[[parts objectAtIndex:1] intValue] officeID:[[parts objectAtIndex:2] intValue]];

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                if(loggedinResult)
                                    [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                                else
                                    [self.propAppDelegate.propSlider login:self];
                            });
                        });
                    }else{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                    }
                });
            });
            
        }else
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Password cannot be empty" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
    }else
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Username cannot be empty" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

// Call this method somewhere in your view controller setup code.

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)isTextField:(UITextField *)textField hiddenByKeyboardFrame:(CGSize)keyboardSize{
    float rootViewH = self.view.frame.size.height;
    float textFieldBottom = textField.frame.origin.y + textField.frame.size.height+textField.superview.frame.origin.y;
    float keyboardTop = rootViewH - keyboardSize.height;
    return (keyboardTop <= textFieldBottom+KEYBOARDTEXTFIELDMINOFFSET)?YES:NO;
}

- (void)adjustViewIfTextField:(UITextField *)textField hiddenByKeyboardSize:(CGSize)keyboardSize{
    if([self isTextField:textField hiddenByKeyboardFrame:keyboardSize]){
        CGRect oldFrame = containerview.frame;
        float textFieldBottom = textField.frame.origin.y + textField.frame.size.height+textField.superview.frame.origin.y;
        float rootViewH = self.view.frame.size.height;
        float keyboardTop = rootViewH - keyboardSize.height;
        float adjustableY = textFieldBottom - keyboardTop + KEYBOARDTEXTFIELDMINOFFSET;
        containerview.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y-adjustableY, oldFrame.size.width, oldFrame.size.height);
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if(_currFocusedField != nil)
        [self adjustViewIfTextField:_currFocusedField hiddenByKeyboardSize:keyboardSize];
}
//
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    scrollView.contentInset = contentInsets;
//    
//    scrollView.scrollIndicatorInsets = contentInsets;
//    
//    
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    
//    // Your app might not need or want this behavior.
//    
//    CGRect aRect = self.view.frame;
//    
//    aRect.size.height -= kbSize.height;
//    
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        
//        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
//        
//    }
//
//}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    
//    scrollView.contentInset = contentInsets;
//    
//    scrollView.scrollIndicatorInsets = contentInsets;
//    
    NSLog(@"keyboard will be hidden");
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _currFocusedField = textField;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _currFocusedField = nil;
    return YES;
}

@end
