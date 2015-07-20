//
//  CalendarEvent.m
//  Salt
//
//  Created by Rick Royd Aban on 6/22/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "CalendarEvent.h"

@interface CalendarEvent(){
    NSString *_name;
    UIColor *_color;
    CalendarEventDuration _duration;
    BOOL _shouldFill;
}
@end

@implementation CalendarEvent

- (CalendarEvent *)initWithName:(NSString *)name color:(UIColor *)color duration:(CalendarEventDuration)duration shouldFill:(BOOL)shouldFill{
    if([super init]){
        _name = name;
        _color = color;
        _duration = duration;
        _shouldFill = shouldFill;
    }
    
    return self;
}

- (NSString *)name{
    return _name;
}

- (UIColor *)color{
    return _color;
}

- (CalendarEventDuration)duration{
    return _duration;
}

- (BOOL)shouldFill{
    return _shouldFill;
}

@end
