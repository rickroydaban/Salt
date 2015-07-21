//
//  LocalHoliday.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/8/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineGatewaySavable.h"

@interface LocalHoliday : NSObject<OfflineGatewaySavable>

- (LocalHoliday *)initWithName:(NSString *)name date:(NSString *)date day:(NSString *)day month:(NSString *)month;
- (LocalHoliday *)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)propName;
- (NSString *)propDate;
- (NSString *)propDay;
- (NSString *)propMonth;

@end
