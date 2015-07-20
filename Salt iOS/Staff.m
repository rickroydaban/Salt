//
//  Staff.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "Staff.h"

#define STAFF_SECURITYLEVEL_USER 1
#define STAFF_SECURITYLEVEL_MANAGER 2
#define STAFF_SECURITYLEVEL_ACCOUNT 3
#define STAFF_SECURITYLEVEL_ADMIN 4
#define STAFF_SECURITYLEVEL_COUNTRYMANAGER  5
#define STAFF_SECURITYLEVEL_ACCOUNTMANAGER 6

#define STAFF_GENDER_MALE @"Male"
#define STAFF_GENDER_FEMALE @"Female"

@interface Staff(){
    
    NSMutableDictionary *_staff;
}
@end

@implementation Staff

- (Staff *)initWithOnlineGateway:(OnlineGateway *)onlineGateway staffDictionary:(NSDictionary *)staffDictionary{
    
    self = [super init];
    if(self){
        _staff = [staffDictionary mutableCopy];
    }
    
    return self;
}

- (Staff *)initWithOfflineGateway:(OfflineGateway *)key staffDictionary:(NSDictionary *)staffDictionary{
    if([super init]){
        _staff = [staffDictionary mutableCopy];
    }
    
    return self;
}

- (NSMutableDictionary *)staffDictionary{
    return _staff;
}

- (int)staffID{
    return [[_staff objectForKey:@"StaffID"] intValue];
}

- (NSString *)staffIDForPrinting{
    return [_staff objectForKey:@"StaffID"];
}

- (int)costCenterID{
    return [[_staff objectForKey:@"CostCenterID"] intValue];
}

- (int)expenseApproverID{
    return [[_staff objectForKey:@"ExpApprover"] intValue];
}

- (int)accountID{
    return [[_staff objectForKey:@"AccountsPerson"] intValue];
}

- (int)officeID{
    return [[_staff objectForKey:@"OfficeID"] intValue];
}

- (int)securityLevel{
    return [[_staff objectForKey:@"SecurityLevel"] intValue];
}

- (BOOL)isApprover{
    return [[_staff objectForKey:@"IsApprover"] boolValue];
}

- (BOOL)isUser{
    return (self.securityLevel == STAFF_SECURITYLEVEL_USER);
}

- (BOOL)isManager{
    return (self.securityLevel == STAFF_SECURITYLEVEL_MANAGER);
}

- (BOOL)isAccount{
    return (self.securityLevel == STAFF_SECURITYLEVEL_ACCOUNT);
}

- (BOOL)isAdmin{
    return (self.securityLevel == STAFF_SECURITYLEVEL_ADMIN);
}

- (BOOL)isCM{
    return (self.securityLevel == STAFF_SECURITYLEVEL_COUNTRYMANAGER);
}

- (BOOL)isAM{
    return (self.securityLevel == STAFF_SECURITYLEVEL_ACCOUNTMANAGER);
}

- (int)maxConsecutiveLeave{
    return [[_staff objectForKey:@"MaxConsecutiveDays"] intValue];
}

- (NSString *)fname{
    return [_staff objectForKey:@"FirstName"];
}

- (NSString *)lname{
    return [_staff objectForKey:@"LastName"];
}

- (NSString *)email{
    return [_staff objectForKey:@"Email"];
}

- (NSString *)gender{
    return [_staff objectForKey:@"GenderSex"];
}

- (float)maxVL{
    return [[_staff objectForKey:@"TotalVacationLeave"] floatValue];
}

- (float)maxSL{
    return [[_staff objectForKey:@"SickLeaveAllowance"] floatValue];
}

- (int)approver1ID{
    return [[_staff objectForKey:@"LeaveApprover1"] intValue];
}

- (NSString *)approver1Name{
    return [_staff objectForKey:@"LeaveApprover1Name"];
}

- (NSString *)approver1Email{
    return [_staff objectForKey:@"LeaveApprover1Email"];
}

- (int)approver2ID{
    return [[_staff objectForKey:@"LeaveApprover2"] intValue];
}

- (NSString *)approver2Name{
    return [_staff objectForKey:@"LeaveApprover2Name"];
}

- (NSString *)approver2Email{
    return [_staff objectForKey:@"LeaveApprover2Email"];
}

- (int)approver3ID{
    return [[_staff objectForKey:@"LeaveApprover3"] intValue];
}

- (NSString *)approver3Name{
    return [_staff objectForKey:@"LeaveApprover3Name"];
}

- (NSString *)approver3Email{
    return [_staff objectForKey:@"LeaveApprover3Email"];
}

- (BOOL)isMyLeaveApprover:(int)leaveApproverStaffID{
    return (self.approver1ID==leaveApproverStaffID || self.approver2ID==leaveApproverStaffID || self.approver3ID==leaveApproverStaffID);
}

- (BOOL)hasMonday{
    return [[_staff objectForKey:@"Monday"] boolValue];
}

- (BOOL)hasTuesday{
    return [[_staff objectForKey:@"Tuesday"] boolValue];
}

- (BOOL)hasWednesday{
    return [[_staff objectForKey:@"Wednesday"] boolValue];
}

- (BOOL)hasThursday{
    return [[_staff objectForKey:@"Thursday"] boolValue];
}

- (BOOL)hasFriday{
    return [[_staff objectForKey:@"Friday"] boolValue];
}

- (BOOL)hasSaturday{
    return [[_staff objectForKey:@"Saturday"] boolValue];
}

- (BOOL)hasSunday{
    return [[_staff objectForKey:@"Sunday"] boolValue];
}

@end
