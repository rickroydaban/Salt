//
//  HomeOverviewItem.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/20/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeOverviewItem : NSObject

typedef enum{
    HomeOverviewItem_HEADER,
    HomeOverviewItem_ITEM1,
    HomeOverviewItem_ITEM2
}HomeOverviewItemCellType;

- (HomeOverviewItem *)initWithName:(NSString *)name requestCountStr:(NSString *)requestCnt daysCount:(NSString *)daysCount cellType:(HomeOverviewItemCellType)cellType;

- (NSString *)propName;
- (NSString *)propRequestCnt;
- (NSString *)propDaysCnt;
- (HomeOverviewItemCellType)propCellType;

@end
