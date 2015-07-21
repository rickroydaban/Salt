//
//  LocalHoliday.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/8/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "LocalHoliday.h"

#define LOCALHOLIDAY_KEY_NAME @"localholidayobjectkeyname"
#define LOCALHOLIDAY_KEY_DATE @"localholidayobjectkeydate"
#define LOCALHOLIDAY_KEY_DAY @"localholidayobjectday"
#define LOCALHOLIDAY_KEY_MONTH @"localholidayobjectmonth"

@interface LocalHoliday(){
    
    NSDictionary *_dictionary;
}
@end

@implementation LocalHoliday

- (LocalHoliday *)initWithName:(NSString *)name date:(NSString *)date day:(NSString *)day month:(NSString *)month{
    
    if([super init]){
        _dictionary = @{LOCALHOLIDAY_KEY_NAME:name, LOCALHOLIDAY_KEY_DATE:date, LOCALHOLIDAY_KEY_DAY:day, LOCALHOLIDAY_KEY_MONTH:month};
    }
    
    return self;
}

- (LocalHoliday *)initWithDictionary:(NSDictionary *)dictionary{
    if([super init])
        _dictionary = dictionary;

    return self;
}

- (NSString *)propName{
    return [_dictionary objectForKey:LOCALHOLIDAY_KEY_NAME];
}

- (NSString *)propDate{
    return [_dictionary objectForKey:LOCALHOLIDAY_KEY_DATE];
}

- (NSString *)propDay{
    return [_dictionary objectForKey:LOCALHOLIDAY_KEY_DAY];
}

- (NSString *)propMonth{
    return [_dictionary objectForKey:LOCALHOLIDAY_KEY_MONTH];
}

- (NSDictionary *)savableDictionary{
    return _dictionary;
}

@end
