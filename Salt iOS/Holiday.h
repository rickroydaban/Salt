//
//  Holiday.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/16/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OfflineGatewaySavable.h"
@interface Holiday : NSObject<OfflineGatewaySavable>

- (Holiday *)initWithName:(NSString *)name country:(NSString *)country velosiDateStr:(NSString *)velosiDateStr monthYearDateStr:(NSString *)monthYearDateStr date:(NSDate *)date;
- (Holiday *)initWithDictionary:(NSDictionary *)dictionary;
- (void)addOfficeName:(NSString *)officeName;
- (NSString *)country;
- (NSString *)name;
- (NSString *)officeStr;

- (NSDate *)dateWithFormatter:(NSDateFormatter *)dateFormatterVelosiDate;
- (NSString *)dateStr;
- (NSString *)monthName;
- (NSString *)year;
@end
