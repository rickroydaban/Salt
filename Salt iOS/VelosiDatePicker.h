//
//  VelosiDatePicker.h
//  Salt
//
//  Created by Rick Royd Aban on 6/26/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VelosiDatePicker : UIDatePicker

- (instancetype)initWithDate:(NSDate *)defaultDate minimumDate:(NSDate *)minDate viewController:(UIViewController *)vc action:(SEL)selector;

@end
