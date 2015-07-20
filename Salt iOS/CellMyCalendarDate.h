//
//  CellMyCalendarDate.h
//  Salt
//
//  Created by Rick Royd Aban on 6/22/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCMyCalendar.h"

@interface CellMyCalendarDate : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *propLabel1;
@property (strong, nonatomic) IBOutlet UILabel *propLabel2;
@property (strong, nonatomic) IBOutlet UILabel *propLabel3;
@property (strong, nonatomic) IBOutlet UILabel *propLabel4;
@property (strong, nonatomic) IBOutlet UILabel *propLabel5;
@property (strong, nonatomic) IBOutlet UILabel *propLabel6;
@property (strong, nonatomic) IBOutlet UILabel *propLabel7;

@property (strong, nonatomic) IBOutlet UIView *propContainer1;
@property (strong, nonatomic) IBOutlet UIView *propContainer2;
@property (strong, nonatomic) IBOutlet UIView *propContainer3;
@property (strong, nonatomic) IBOutlet UIView *propContainer4;
@property (strong, nonatomic) IBOutlet UIView *propContainer5;
@property (strong, nonatomic) IBOutlet UIView *propContainer6;
@property (strong, nonatomic) IBOutlet UIView *propContainer7;


- (void)assignVCMyCalendar:(VCMyCalendar *)myCalendar;

@end
