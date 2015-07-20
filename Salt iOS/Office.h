//
//  Office.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/26/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineGatewaySavable.h"

@interface Office : NSObject<OfflineGatewaySavable>

- (Office *)initWithDictionary:(NSDictionary *)jsonOFfice isFullDetail:(BOOL)isFullDetails;

- (int)officeID;
- (NSString *)officeName;
- (BOOL)hasSunday;
- (BOOL)hasMonday;
- (BOOL)hasTueday;
- (BOOL)hasWednesday;
- (BOOL)hasThursday;
- (BOOL)hasFriday;
- (BOOL)hasSaturday;
- (float)maternityLimit;
- (float)paternityLimit;
- (float)hospitalizationLimit;
- (float)bereavementLimit;
- (float)sickLimit;
- (float)vacationLimit;
- (int)baseCurrencyID;
- (NSString *)baseCurrencyName;
- (NSString *)baseCurrencyThree;
- (int)mileageCurrencyID;
- (NSString *)mileageCurrencyName;
- (NSString *)mileageCurrencyThree;

    
@end
