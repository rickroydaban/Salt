//
//  Holiday.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/16/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "Holiday.h"

@interface Holiday(){
    NSString *_name, *_country, *_monthName, *_year, *_velosiDateStr;
    NSMutableArray *_officeNames;
    NSDate *_date;
}
@end

@implementation Holiday

- (Holiday *)initWithName:(NSString *)name country:(NSString *)country velosiDateStr:(NSString *)velosiDateStr monthYearDateStr:(NSString *)monthYearDateStr date:(NSDate *)date{
    if([super init]){
        _name = name;
        _country = country;
        _date = date;
        _officeNames = [NSMutableArray array];
        
        NSArray *monthYear = [monthYearDateStr componentsSeparatedByString:@"-"];
        _monthName = monthYear[0];
        _year = monthYear[1];
        _velosiDateStr = velosiDateStr;
    }
    
    return self;
}

- (void)addOfficeName:(NSString *)officeName{
    [_officeNames addObject:officeName];
}

- (NSString *)country{
    return _country;
}

- (NSString *)name{
    return _name;
}

- (NSString *)monthName{
    return _monthName;
}

- (NSString *)year{
    return _year;
}

- (NSDate *)date{
    return _date;
}

- (NSString *)dateStr{
    return _velosiDateStr;
}

- (NSString *)officeStr{
    NSMutableString *officeStr = [NSMutableString stringWithCapacity:_officeNames.count*30];
    for(int i=0; i<_officeNames.count; i++){
        [officeStr appendFormat:@"\u2022 %@", [_officeNames objectAtIndex:i]];
        if(i!=_officeNames.count-1)
            [officeStr appendFormat:@"\n"];
    }
    return officeStr;
}

@end
