//
//  CellHoliday.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/16/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellHoliday : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *propLabelName;
@property (strong, nonatomic) IBOutlet UILabel *propLabelCountry;
@property (strong, nonatomic) IBOutlet UILabel *propLabelDate;
@property (strong, nonatomic) IBOutlet UITextView *propTextViewOffices;

@end
