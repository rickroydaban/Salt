//
//  Staff.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineGateway.h"
@class OfflineGateway;

@interface Staff : NSObject

- (Staff *)initWithOnlineGateway:(OnlineGateway *)onlineGateway staffDictionary:(NSDictionary *)staffDictionary;
- (Staff *)initWithOfflineGateway:(OfflineGateway *)key staffDictionary:(NSDictionary *)staffDictionary;

- (NSMutableDictionary *)staffDictionary;
- (int)staffID;
- (NSString *)staffIDForPrinting;
- (int)costCenterID;
- (int)expenseApproverID;
- (int)accountID;
- (int)officeID;
//security
- (BOOL)isApprover;
- (BOOL)isUser;
- (BOOL)isManager;
- (BOOL)isAccount;
- (BOOL)isAdmin;
- (BOOL)isCM;
- (BOOL)isAM;
- (int)maxConsecutiveLeave;
- (NSString *)fname;
- (NSString *)lname;
- (NSString *)email;
- (NSString *)gender;
- (int)securityLevel;
- (float)maxVL;
- (float)maxSL;
//approvals
- (int)approver1ID;
- (NSString *)approver1Name;
- (NSString *)approver1Email;
- (int)approver2ID;
- (NSString *)approver2Name;
- (NSString *)approver2Email;
- (int)approver3ID;
- (NSString *)approver3Name;
- (NSString *)approver3Email;
- (BOOL) isMyLeaveApprover:(int)leaveApproverStaffID;
//calendar
- (BOOL)hasMonday;
- (BOOL)hasTuesday;
- (BOOL)hasWednesday;
- (BOOL)hasThursday;
- (BOOL)hasFriday;
- (BOOL)hasSaturday;
- (BOOL)hasSunday;

@end
