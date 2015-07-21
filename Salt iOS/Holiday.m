//
//  Holiday.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/16/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#define KEY_NAME @"keyname"
#define KEY_COUNTRY @"keycountry"
#define KEY_MONTHNAME @"keymonthname"
#define KEY_YEAR @"keyyear"
#define KEY_VELOSIDATESTR @"keyvelosidatestr"
#define KEY_OFFICES @"keyoffices"
#import "Holiday.h"

@interface Holiday(){
    NSMutableDictionary *_dict;
}
@end

@implementation Holiday

- (Holiday *)initWithName:(NSString *)name country:(NSString *)country velosiDateStr:(NSString *)velosiDateStr monthYearDateStr:(NSString *)monthYearDateStr date:(NSDate *)date{
    if([super init]){
        _dict = [NSMutableDictionary dictionary];
        [_dict setObject:name forKey:KEY_NAME];
        [_dict setObject:country forKey:KEY_COUNTRY];
        NSArray *monthYear = [monthYearDateStr componentsSeparatedByString:@"-"];
        [_dict setObject:monthYear[0] forKey:KEY_MONTHNAME];
        [_dict setObject:monthYear[1] forKey:KEY_YEAR];
        [_dict setObject:velosiDateStr forKey:KEY_VELOSIDATESTR];
        [_dict setObject:[NSMutableArray array] forKey:KEY_OFFICES];
    }
    
    return self;
}

- (Holiday *)initWithDictionary:(NSDictionary *)dictionary{
    if([super init])
        _dict = [[NSDictionary dictionaryWithDictionary:dictionary] mutableCopy];
    
    return self;
}

- (NSDictionary *)savableDictionary{
    return _dict;
}

- (void)addOfficeName:(NSString *)officeName{
    NSMutableArray *officeNames = [_dict objectForKey:KEY_OFFICES];
    [officeNames addObject:officeName];
    [_dict setObject:officeNames forKey:KEY_OFFICES];
}

- (NSString *)country{
    return [_dict objectForKey:KEY_COUNTRY];
}

- (NSString *)name{
    return [_dict objectForKey:KEY_NAME];
}

- (NSString *)monthName{
    return [_dict objectForKey:KEY_MONTHNAME];
}

- (NSString *)year{
    return [_dict objectForKey:KEY_YEAR];
}

- (NSDate *)dateWithFormatter:(NSDateFormatter *)dateFormatterVelosiDate{
    return [dateFormatterVelosiDate dateFromString:[_dict objectForKey:KEY_VELOSIDATESTR]];
}

- (NSString *)dateStr{
    return [_dict objectForKey:KEY_VELOSIDATESTR];
}

- (NSString *)officeStr{
    NSMutableArray *officeNames = [_dict objectForKey:KEY_OFFICES];
    NSMutableString *officeStr = [NSMutableString stringWithCapacity:officeNames.count*30];
    for(int i=0; i<officeNames.count; i++){
        [officeStr appendFormat:@"\u2022 %@", [officeNames objectAtIndex:i]];
        if(i!=officeNames.count-1)
            [officeStr appendFormat:@"\n"];
    }
    
    return officeStr;
}

@end
