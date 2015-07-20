//
//  Leave.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/21/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

//statuses
#define LEAVESTATUSID_PENDING 18
#define LEAVESTATUSID_CANCELLED 19
#define LEAVESTATUSID_APPROVED 20
#define LEAVESTATUSID_REJECTED 21
#define LEAVESTATUSDESC_PENDING @"Submitted"
#define LEAVESTATUSDESC_CANCELLED @"Cancelled"
#define LEAVESTATUSDESC_APPROVED @"Approved"
#define LEAVESTATUSDESC_REJECTED @"Rejected"
//types
#define LEAVETYPEID_BIRTHDAY 1
#define LEAVETYPEID_VACATION 2
#define LEAVETYPEID_SICK 3
#define LEAVETYPEID_UNPAID 4
#define LEAVETYPEID_BEREAVEMENT 5
#define LEAVETYPEID_MATERNITY 6
#define LEAVETYPEID_DOCTOR 7
#define LEAVETYPEID_HOSPITALIZATION 8
#define LEAVETYPEID_BUSINESSTRIP 9
#define LEAVETYPEDESC_BIRTHDAY @"Birthday Leave"
#define LEAVETYPEDESC_VACATION @"Vacation/Holiday"
#define LEAVETYPEDESC_SICK @"Sick Leave"
#define LEAVETYPEDESC_UNPAID @"Unpaid Leave"
#define LEAVETYPEDESC_BEREAVEMENT @"Bereavement"
#define LEAVETYPEDESC_MATPAT @"Maternity/Pat"
#define LEAVETYPEDESC_DOCDENTIST @"Doctor/Dentist"
#define LEAVETYPEDESC_HOSPITALIZATION @"Hospitalization"
#define LEAVETYPEDESC_BUSINESSTRIP @"Business Trip"

#define LEAVE_HALFDAY_AM @"0.5 Days AM"
#define LEAVE_HALFDAY_PM @"0.5 Days PM"
#define LEAVE_ONEDAY @"1.0 Day"

#import <Foundation/Foundation.h>
#import "OnlineGateway.h"
#import "OfflineGatewaySavable.h"
#import "AppDelegate.h"
@interface Leave : NSObject<OfflineGatewaySavable>

//constructors
- (Leave *)initWithDictionary:(NSMutableDictionary *)leaveDictionary;
- (Leave *)initWithJSONDictionary:(NSDictionary *)jsonLeave onlineGateway:(OnlineGateway *)onlineGateway;
- (Leave *)initWithStaff:(Staff *)staff staffRemVL:(float)staffRemVL staffRemSL:(float)staffRemSL typeID:(int)typeID statusID:(int)statusID dateFrom:(NSString *)dateFrom dateTo:(NSString *)dateTo days:(float)days workingDays:(float)workingDays notes:(NSString *)notes dateSubmitted:(NSString *)dateSubmitted;

- (void)editLeaveWithTypeID:(int)typeID statusID:(int)statusID remVL:(float)remVL remSL:(float)remSL dateFrom:(NSString *)dateFrom dateTo:(NSString *)dateTo days:(float)days workingDays:(float)workingDays notes:(NSString *)notes dateSubmitted:(NSString *)dateSubmitted;
- (NSString *)jsonStringForEditingLeave;
- (NSString *)jsonStringForProcessingLeave;
+ (NSString *)jsonFromNewEmptyLeave;
+ (int)propTypeKeyForDescription:(NSString *)desc;
+ (int)propStatusKeyForDesc:(NSString *)desc;

//Getters
- (int)propLeaveID;
- (int)propStaffID;
- (NSString *)propStaffName;
- (NSString *)propStaffEmail;
- (NSString *)propStartDate;
- (NSString *)propEndDate;
- (int)propYearSubmitted;
- (int)propTypeID;
- (NSString *)propTypeDescription;
+ (NSArray *)propTypeDescriptionListhasAll:(BOOL)hasAll;
- (int)propStatusID;
- (NSString *)propStatusDescription;
+ (NSArray *)propStatusDescriptionListhasAll:(BOOL)hasAll;
- (float)propDays;
- (float)propWorkingDays;
- (NSString *)propNotes;
- (int)propYear; //for filters
- (float)propRemainingVL;
- (float)propRemainingSL;
- (int)propHRID;
- (NSString *)propHREmail;
- (NSString *)propHRName;
- (NSString *)propAMEmail;
- (NSString *)propAMName;
- (int)propOfficeID;
- (int)propLeaveApprover1ID;
- (NSString *)propLeaveApprover1Name;
- (NSString *)propApproverName;

- (BOOL)isApprover:(int)staffID;

- (NSString *)jsonString;

- (void)rejectLeaveFromStaff:(Staff *)staff withNotes:(NSString *)notes now:(NSString *)now;
- (void)approveLeaveFromStaff:(Staff *)staff now:(NSString *)now;
- (void)cancelLeaveFromStaff:(Staff *)staff now:(NSString *)now;

@end
