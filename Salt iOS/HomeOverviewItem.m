//
//  HomeOverviewItem.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/20/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "HomeOverviewItem.h"

@interface HomeOverviewItem(){
    NSString *_name, *_requestCnt, *_daysCnt;
    HomeOverviewItemCellType _cellType;
}
@end

@implementation HomeOverviewItem

- (HomeOverviewItem *)initWithName:(NSString *)name requestCountStr:(NSString *)requestCnt daysCount:(NSString *)daysCount cellType:(HomeOverviewItemCellType)cellType{
    self = [super init];
    
    if(self) {
        _name = name;
        _requestCnt = requestCnt;
        _daysCnt = daysCount;
        _cellType = cellType;
        
    }
    
    return self;
}

- (NSString *)propName{
    return _name;
}

- (NSString *)propRequestCnt{
    return _requestCnt;
}

- (NSString *)propDaysCnt{
    return _daysCnt;
}

- (HomeOverviewItemCellType)propCellType{
    return _cellType;
}


@end
