//
//  CalendarItem.m
//  Salt
//
//  Created by Rick Royd Aban on 6/22/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "CalendarItem.h"

@interface CalendarItem(){
    int _day;
    CalendarItemTypes _type;
    NSArray *_events;
}
@end

@implementation CalendarItem

- (CalendarItem *)initWithDay:(int)day type:(CalendarItemTypes)type events:(NSArray *)events{
    if([super init]){
        _day = day;
        _type = type;
        _events = events;
    }
    
    return self;
}

- (int)day{
    return _day;
}

- (CalendarItemTypes)type{
    return _type;
}

- (NSArray *)events{
    return _events;
}

@end
