//
//  OfflineGateway.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/22/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Staff;
#import "Office.h"
#import "Leave.h"
#import "LocalHoliday.h"
#import "Holiday.h"
#import "AppDelegate.h"

@interface OfflineGateway : NSObject

- (OfflineGateway *) initWithAppDelegate:(AppDelegate *)appDelegate;
- (void)updatePreviouslyUsedUsername:(NSString *)username;
- (BOOL)isLoggedIn;
- (void)logout;
- (NSString *)getPrevUsername;

//data serialization
- (void)serializeStaff:(Staff *)staff office:(Office *)office;
- (void)serializeMyLeaves:(NSMutableArray *)myLeaves;
- (void)serializeLeavesForApproval:(NSMutableArray *)leavesForApproval;
- (void)serializeLocalHolidays:(NSMutableArray *)localHolidays;
- (void)serializeMonthlyHolidays:(NSMutableArray *)monthlyHolidays;
- (Staff *)deserializeStaff;
- (Office *)deserializeStaffOffice;
- (NSMutableArray *)deserializeMyLeaves;
- (NSMutableArray *)deserializeLeavesForApproval;
- (NSMutableArray *)deserializeLocalHolidays;
- (NSMutableArray *)deserializeMonthlyHolidays;

@end
