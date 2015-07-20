//
//  OnlineGateway.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;

@interface OnlineGateway : NSObject

- (OnlineGateway *)initWithAppDelegate:(AppDelegate *)appDelegate;
- (NSString *)deserializeJsonDateString: (NSString *)jsonDateString;

- (NSString *)authenticateUsername:(NSString *)username password:(NSString *)password;
- (id)initializeDataWithStaffID:(int)staffID securityLevel:(int)securityLevel officeID:(int)officeID;
- (NSString *)updateAppStaffDataWithStaffID:(int)staffID securityLevel:(int)securityLevel officeID:(int)officeID;
- (id)myLeaves;
- (id)leavesForApproval;
- (NSString *)followupLeave:(NSString *)leaveJSON;
//holidays
- (id)localHolidays;
- (id)monthlyholidays;
- (id)weeklyholiday;

- (NSString *)saveLeaveWithNewLeaveJSON:(NSString *)newLeaveJSON oldLeaveJSON:(NSString *)oldLeaveJSON;
- (NSString *)processLeaveJSON:(NSString *)leaveJSON forStatusID:(int)statusID;

@end
