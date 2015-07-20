//
//  Holiday.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/16/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Holiday : NSObject

- (Holiday *)initWithName:(NSString *)name country:(NSString *)country velosiDateStr:(NSString *)velosiDateStr monthYearDateStr:(NSString *)monthYearDateStr date:(NSDate *)date;
- (void)addOfficeName:(NSString *)officeName;
- (NSString *)country;
- (NSString *)name;
- (NSString *)officeStr;

- (NSDate *)date;
- (NSString *)dateStr;
- (NSString *)monthName;
- (NSString *)year;
@end
