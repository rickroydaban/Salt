//
//  CalendarEvent.h
//  Salt
//
//  Created by Rick Royd Aban on 6/22/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    AM,
    PM,
    AllDay
}CalendarEventDuration;

@interface CalendarEvent : NSObject

- (CalendarEvent *)initWithName:(NSString *)name color:(UIColor *)color duration:(CalendarEventDuration)duration shouldFill:(BOOL)shouldFill;
- (NSString *)name;
- (UIColor *)color;
- (CalendarEventDuration)duration;
- (BOOL)shouldFill;

@end
