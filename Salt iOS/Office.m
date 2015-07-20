//
//  Office.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/26/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "Office.h"

@interface Office(){
    NSMutableDictionary *_officeMap;
}
@end

@implementation Office

- (Office *)initWithDictionary:(NSDictionary *)jsonOffice isFullDetail:(BOOL)isFullDetails{
    if([super init]){
        _officeMap = [NSMutableDictionary dictionary];
        [_officeMap setObject:@([[jsonOffice objectForKey:@"OfficeID"] intValue]) forKey:@"OfficeID"];
        [_officeMap setObject:[jsonOffice objectForKey:@"OfficeName"] forKey:@"OfficeName"];
        
        if(isFullDetails){
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"Sunday"] boolValue]] forKey:@"Sunday"];
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"Monday"] boolValue]] forKey:@"Monday"];
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"Tuesday"] boolValue]] forKey:@"Tuesday"];
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"Wednesday"] boolValue]] forKey:@"Wednesday"];
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"Thursday"] boolValue]] forKey:@"Thursday"];
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"Friday"] boolValue]] forKey:@"Friday"];
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"Saturday"] boolValue]] forKey:@"Saturday"];
            [_officeMap setObject:[NSNumber numberWithBool:[[jsonOffice objectForKey:@"IsUseBdayLeave"] boolValue]] forKey:@"IsUseBdayLeave"];
            [_officeMap setObject:@([[jsonOffice objectForKey:@"MaternityLimit"] floatValue]) forKey:@"MaternityLimit"];
            [_officeMap setObject:@([[jsonOffice objectForKey:@"PaternityLimit"] floatValue]) forKey:@"PaternityLimit"];
            [_officeMap setObject:@([[jsonOffice objectForKey:@"HospitalizationLimit"] floatValue]) forKey:@"HospitalizationLimit"];
            [_officeMap setObject:@([[jsonOffice objectForKey:@"BereavementLimit"] floatValue]) forKey:@"BereavementLimit"];
            [_officeMap setObject:@([[jsonOffice objectForKey:@"SickLeaveAllowance"] floatValue]) forKey:@"SickLeaveAllowance"];
            [_officeMap setObject:@([[jsonOffice objectForKey:@"VacationLeaveAllowance"] floatValue]) forKey:@"VacationLeaveAllowance"];
            [_officeMap setObject:@[[jsonOffice objectForKey:@"BaseCurrency"]] forKey:@"BaseCurrency"];
            [_officeMap setObject:[jsonOffice objectForKey:@"BaseCurrencyName"] forKey:@"BaseCurrencyName"];
            [_officeMap setObject:@([[jsonOffice objectForKey:@"MileageCurrency"] intValue]) forKey:@"MileageCurrency"];
            [_officeMap setObject:[jsonOffice objectForKey:@"MileageCurrencyName"] forKey:@"MileageCurrencyName"];
        }
    }
    
    return self;
}

- (NSDictionary *)savableDictionary{
    return _officeMap;
}

- (int)officeID{
    return [[_officeMap objectForKey:@"OfficeID"] intValue];
}

- (NSString *)officeName{
    return [_officeMap objectForKey:@"OfficeName"];
}

- (BOOL)hasSunday{
    return [[_officeMap objectForKey:@"Sunday"] boolValue];
}

- (BOOL)hasMonday{
    return [[_officeMap objectForKey:@"Monday"] boolValue];
}

- (BOOL)hasTueday{
    return [[_officeMap objectForKey:@"Tuesday"] boolValue];
}

- (BOOL)hasWednesday{
    return [[_officeMap objectForKey:@"Wednesday"] boolValue];
}

- (BOOL)hasThursday{
    return [[_officeMap objectForKey:@"Thursday"] boolValue];
}

- (BOOL)hasFriday{
    return [[_officeMap objectForKey:@"Friday"] boolValue];
}

- (BOOL)hasSaturday{
    return [[_officeMap objectForKey:@"Saturday"] boolValue];
}

- (BOOL)hasBirthdayLeave{
    return [[_officeMap objectForKey:@"IsUseBdayLeave"] boolValue];
}

- (float)maternityLimit{
    return [[_officeMap objectForKey:@"MaternityLimit"] floatValue];
}

- (float)paternityLimit{
    return [[_officeMap objectForKey:@"PaternityLimit"] floatValue];
}

- (float)hospitalizationLimit{
    return [[_officeMap objectForKey:@"HospitalizaitonLimit"] floatValue];
}

- (float)bereavementLimit{
    return [[_officeMap objectForKey:@"BereavementLimit"] floatValue];
}

- (float)sickLimit{
    return [[_officeMap objectForKey:@"SickLeaveAllowance"] floatValue];
}

- (float)vacationLimit{
    return [[_officeMap objectForKey:@"VacationLeaveAllowance"] floatValue];
}

- (int)baseCurrencyID{
    return [[_officeMap objectForKey:@"BaseCurrency"] intValue];
}

- (NSString *)baseCurrencyName{
    NSString *baseName = [[[_officeMap objectForKey:@"BaseCurrencyName"] componentsSeparatedByString:@"\\("] objectAtIndex:0];
    NSLog(@"basecurrencyname %@",baseName);
    return baseName;
}

- (NSString *)baseCurrencyThree{
    NSString *baseName = [[[_officeMap objectForKey:@"BaseCurrencyName"] componentsSeparatedByString:@"\\("] objectAtIndex:1];
    NSLog(@"basecurrencythree %@",baseName);
    return baseName;
}

- (int)mileageCurrencyID{
    return [[_officeMap objectForKey:@"MileageCurrency"] intValue];
}

- (NSString *)mileageCurrencyName{
    NSString *baseName = [[[_officeMap objectForKey:@"MileageCurrencyName"] componentsSeparatedByString:@"\\("] objectAtIndex:0];
    NSLog(@"mileagecurencyname %@",baseName);
    return baseName;
}

- (NSString *)mileageCurrencyThree{
    NSString *baseName = [[[_officeMap objectForKey:@"MileageCurrencyName"] componentsSeparatedByString:@"\\("] objectAtIndex:1];
    NSLog(@"mileagecurencythree %@",baseName);
    return baseName;
}

@end
