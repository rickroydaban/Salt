//
//  VCMyCalendar.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/8/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCPage.h"
#import "VelosiPickerRowSelectionDelegate.h"

@interface VCMyCalendar : VCPage<UITableViewDataSource, UITableViewDelegate, VelosiPickerRowSelectionDelegate, UITextFieldDelegate>

- (void)calendarItemClicked:(UIButton *)clickedCalendarCellButton;

@end
