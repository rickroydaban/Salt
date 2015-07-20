//
//  CalendarItem.h
//  Salt
//
//  Created by Rick Royd Aban on 6/22/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    TYPE_OUTMONTH,
    TYPE_DAYOFMONTH,
    TYPE_NOW,
    TYPE_NONWORKINGDAY
}CalendarItemTypes;

@interface CalendarItem : NSObject


- (CalendarItem *)initWithDay:(int)day type: (CalendarItemTypes)type events:(NSArray *)events;
- (int)day;
- (CalendarItemTypes)type;
- (NSArray *)events;

@end
