//
//  Leave.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/21/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "Leave.h"

@interface Leave(){
    NSMutableDictionary *_leave;
}
@end

@implementation Leave

- (Leave *)initWithDictionary:(NSMutableDictionary *)leaveDictionary{
    if([super init]){
        _leave = leaveDictionary;
    }
    
    return self;
}

- (Leave *)initWithJSONDictionary:(NSDictionary *)jsonLeave onlineGateway:(OnlineGateway *)onlineGateway{
    
    self = [super init];
    
    if(self){
        _leave = [NSMutableDictionary dictionaryWithDictionary:jsonLeave];
        [_leave setObject:@([[_leave objectForKey:@"LeaveID"] intValue]) forKey:@"LeaveID"];
        [_leave setObject:@([[_leave objectForKey:@"StaffID"] intValue]) forKey:@"StaffID"];
        [_leave setObject:@([[_leave objectForKey:@"SickAllowance"] floatValue]) forKey:@"SickAllowance"];
        [_leave setObject:@([[_leave objectForKey:@"WorkingDays"] floatValue]) forKey:@"WorkingDays"];
        [_leave setObject:@([[_leave objectForKey:@"ApproverID"] intValue]) forKey:@"ApproverID"];
        [_leave setObject:@([[_leave objectForKey:@"HROfficerID"] intValue]) forKey:@"HROfficerID"];
        [_leave setObject:@([[_leave objectForKey:@"Days"] floatValue]) forKey:@"Days"];
        [_leave setObject:@([[_leave objectForKey:@"LeaveApprover1ID"] intValue]) forKey:@"LeaveApprover1ID"];
        [_leave setObject:@([[_leave objectForKey:@"LeaveStatus"] intValue]) forKey:@"LeaveStatus"];
        [_leave setObject:@([[_leave objectForKey:@"LeaveTypeID"] intValue]) forKey:@"LeaveTypeID"];
        [_leave setObject:@([[_leave objectForKey:@"VacationAllowance"] floatValue]) forKey:@"VacationAllowance"];
        [_leave setObject:@([[_leave objectForKey:@"LeaveApprover3ID"] intValue]) forKey:@"LeaveApprover3ID"];
        [_leave setObject:@([[_leave objectForKey:@"OfficeID"] intValue]) forKey:@"OfficeID"];
        [_leave setObject:@([[_leave objectForKey:@"LeaveApprover2ID"] intValue]) forKey:@"LeaveApprover2ID"];
//        [_leave setObject:[NSArray array] forKey:@"Documents"];
//        [_leave setObject:[NSJSONSerialization JSONObjectWithData:[[_leave objectForKey:@"Documents"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] forKey:@"Documents"];
        [_leave setObject:[onlineGateway deserializeJsonDateString:[_leave objectForKey:@"DateFrom"]] forKey:@"DateFrom"];
        [_leave setObject:[onlineGateway deserializeJsonDateString:[_leave objectForKey:@"DateTo"]] forKey:@"DateTo"];
        [_leave setObject:[onlineGateway deserializeJsonDateString:[_leave objectForKey:@"DateSubmitted"]] forKey:@"DateSubmitted"];
        [_leave setObject:[onlineGateway deserializeJsonDateString:[_leave objectForKey:@"DateCancelled"]] forKey:@"DateCancelled"];
        [_leave setObject:[onlineGateway deserializeJsonDateString:[_leave objectForKey:@"DateRejected"]] forKey:@"DateRejected"];
        [_leave setObject:[onlineGateway deserializeJsonDateString:[_leave objectForKey:@"DateApproved"]] forKey:@"DateApproved"];
    }
    
    return self;
}

//constructor for new leave request
- (Leave *)initWithStaff:(Staff *)staff staffRemVL:(float)staffRemVL staffRemSL:(float)staffRemSL typeID:(int)typeID statusID:(int)statusID dateFrom:(NSString *)dateFrom dateTo:(NSString *)dateTo days:(float)days workingDays:(float)workingDays notes:(NSString *)notes dateSubmitted:(NSString *)dateSubmitted{
    
    self = [super init];
    
    if(self) {
        _leave = [NSMutableDictionary dictionary];
        [_leave setObject:@(0) forKey:@"LeaveID"];
        [_leave setObject:@([staff staffID]) forKey:@"StaffID"];
        [_leave setObject:[NSString stringWithFormat:@"%@ %@",[staff fname],[staff lname]] forKey:@"StaffName"];
        [_leave setObject:[staff email] forKey:@"Email"];
        [_leave setObject:@([staff approver1ID]) forKey:@"LeaveApprover1ID"];
        [_leave setObject:[staff approver1Email] forKey:@"LeaveApprover1Email"];
        [_leave setObject:[staff approver1Name] forKey:@"LeaveApprover1Name"];
        [_leave setObject:@([staff approver2ID]) forKey:@"LeaveApprover2ID"];
        [_leave setObject:[staff approver2Email] forKey:@"LeaveApprover2Email"];
        [_leave setObject:[staff approver2Name] forKey:@"LeaveApprover2Name"];
        [_leave setObject:@([staff approver3ID]) forKey:@"LeaveApprover3ID"];
        [_leave setObject:[staff approver3Email] forKey:@"LeaveApprover3Email"];
        [_leave setObject:[staff approver3Name] forKey:@"LeaveApprover3Name"];
        [_leave setObject:@(staffRemVL) forKey:@"VacationAllowance"];
        [_leave setObject:@(staffRemSL) forKey:@"SickAllowance"];
        [_leave setObject:@(typeID) forKey:@"LeaveTypeID"];
        [_leave setObject:[Leave propTypeDescriptionForKey:typeID] forKey:@"Description"];
        [_leave setObject:dateFrom forKey:@"DateFrom"];
        [_leave setObject:dateTo forKey:@"DateTo"];
        [_leave setObject:@(days) forKey:@"Days"];
        [_leave setObject:@(workingDays) forKey:@"WorkingDays"];
        [_leave setObject:notes forKey:@"Notes"];
        [_leave setObject:dateSubmitted forKey:@"DateSubmitted"];
        [_leave setObject:@(statusID) forKey:@"LeaveStatus"];
    }
    
    return self;
}

- (void)editLeaveWithTypeID:(int)typeID statusID:(int)statusID remVL:(float)remVL remSL:(float)remSL dateFrom:(NSString *)dateFrom dateTo:(NSString *)dateTo days:(float)days workingDays:(float)workingDays notes:(NSString *)notes dateSubmitted:(NSString *)dateSubmitted{
    
    [_leave setObject:@(typeID) forKey:@"LeaveTypeID"];
    [_leave setObject:@(statusID) forKey:@"LeaveStatus"];
    [_leave setObject:@(remVL) forKey:@"VacationAllowance"];
    [_leave setObject:@(remSL) forKey:@"SickAllowance"];
    [_leave setObject:dateFrom forKey:@"DateFrom"];
    [_leave setObject:dateTo forKey:@"DateTo"];
    [_leave setObject:@(days) forKey:@"Days"];
    [_leave setObject:@(workingDays) forKey:@"WorkingDays"];
    [_leave setObject:notes forKey:@"Notes"];
    [_leave setObject:dateSubmitted forKey:@"DateSubmitted"];
}

- (NSString *)jsonStringForEditingLeave{
    NSMutableDictionary *leaveDictCopy = [NSMutableDictionary dictionary];
    
    [leaveDictCopy setObject:@([[_leave objectForKey:@"LeaveID"] intValue]) forKey:@"LeaveID"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"StaffID"] intValue]) forKey:@"StaffID"];
    [leaveDictCopy setObject:[_leave objectForKey:@"StaffName"] forKey:@"StaffName"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"LeaveTypeID"] intValue]) forKey:@"LeaveTypeID"];
    [leaveDictCopy setObject:[_leave objectForKey:@"Description"] forKey:@"Description"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"SickAllowance"] floatValue]) forKey:@"SickAllowance"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"VacationAllowance"] floatValue]) forKey:@"VacationAllowance"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"LeaveStatus"] intValue]) forKey:@"LeaveStatus"];
    [leaveDictCopy setObject:[_leave objectForKey:@"DateFrom"] forKey:@"DateFrom"];
    [leaveDictCopy setObject:[_leave objectForKey:@"DateTo"] forKey:@"DateTo"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"Days"] floatValue]) forKey:@"Days"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"WorkingDays"] floatValue]) forKey:@"WorkingDays"];
    [leaveDictCopy setObject:[_leave objectForKey:@"Notes"] forKey:@"Notes"];
    [leaveDictCopy setObject:[_leave objectForKey:@"DateSubmitted"] forKey:@"DateSubmitted"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"LeaveApprover1ID"] intValue]) forKey:@"LeaveApprover1ID"];
    [leaveDictCopy setObject:[_leave objectForKey:@"LeaveApprover1Email"] forKey:@"LeaveApprover1Email"];
    [leaveDictCopy setObject:[_leave objectForKey:@"LeaveApprover1Name"] forKey:@"LeaveApprover1Name"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"LeaveApprover2ID"] intValue]) forKey:@"LeaveApprover2ID"];
    [leaveDictCopy setObject:[_leave objectForKey:@"LeaveApprover2Email"] forKey:@"LeaveApprover2Email"];
    [leaveDictCopy setObject:[_leave objectForKey:@"LeaveApprover2Name"] forKey:@"LeaveApprover2Name"];
    [leaveDictCopy setObject:@([[_leave objectForKey:@"LeaveApprover3ID"] intValue]) forKey:@"LeaveApprover3ID"];
    [leaveDictCopy setObject:[_leave objectForKey:@"LeaveApprover3Email"] forKey:@"LeaveApprover3Email"];
    [leaveDictCopy setObject:[_leave objectForKey:@"LeaveApprover3Name"] forKey:@"LeaveApprover3Name"];
    
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:leaveDictCopy options:0 error:nil] encoding:NSUTF8StringEncoding];
}

- (NSString *)jsonStringForProcessingLeave{
    NSMutableDictionary *leaveDictCopy = [NSMutableDictionary dictionaryWithDictionary:_leave];
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:leaveDictCopy options:0 error:nil] encoding:NSUTF8StringEncoding];
}

+ (NSString *)jsonFromNewEmptyLeave{
    NSMutableDictionary *emptyLeave = [NSMutableDictionary dictionary];
    
    [emptyLeave setObject:@(0) forKey:@"LeaveID"];
    [emptyLeave setObject:@(0) forKey:@"StaffID"];
    [emptyLeave setObject:@(0) forKey:@"LeaveTypeID"];
    [emptyLeave setObject:@"" forKey:@"Description"];
    [emptyLeave setObject:@(0) forKey:@"SickAllowance"];
    [emptyLeave setObject:@(0) forKey:@"VacationAllowance"];
    [emptyLeave setObject:@(LEAVESTATUSID_PENDING) forKey:@"LeaveStatus"];
    [emptyLeave setObject:@"01-Jan-1900" forKey:@"DateFrom"];
    [emptyLeave setObject:@"01-Jan-1900" forKey:@"DateTo"];
    [emptyLeave setObject:@(0) forKey:@"Days"];
    [emptyLeave setObject:@(0) forKey:@"WorkingDays"];
    [emptyLeave setObject:@"" forKey:@"Notes"];
    [emptyLeave setObject:@"01-Jan-1900" forKey:@"DateSubmitted"];
    [emptyLeave setObject:@(0) forKey:@"LeaveApprover1ID"];
    [emptyLeave setObject:@"" forKey:@"LeaveApprover1Email"];
    [emptyLeave setObject:@"" forKey:@"LeaveApprover1Name"];
    [emptyLeave setObject:@(0) forKey:@"LeaveApprover2ID"];
    [emptyLeave setObject:@"" forKey:@"LeaveApprover2Email"];
    [emptyLeave setObject:@"" forKey:@"LeaveApprover2Name"];
    [emptyLeave setObject:@(0) forKey:@"LeaveApprover3ID"];
    [emptyLeave setObject:@"" forKey:@"LeaveApprover3Email"];
    [emptyLeave setObject:@"" forKey:@"LeaveApprover3Name"];
    
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:emptyLeave options:0 error:nil] encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)savableDictionary{
    return _leave;
}

- (NSString *)jsonString{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_leave options:0 error:nil] encoding:NSUTF8StringEncoding];
}

- (int)propLeaveID{
    return [[_leave objectForKey:@"LeaveID"] intValue];
}

- (int)propStaffID{
    return [[_leave objectForKey:@"StaffID"] intValue];
}

- (NSString *)propStaffName{
    return [_leave objectForKey:@"StaffName"];
}

- (NSString *)propStaffEmail{
    return [_leave objectForKey:@"Email"];
}

- (NSString *)propStartDate{
    return [_leave objectForKey:@"DateFrom"];
}

- (NSString *)propEndDate{
    return [_leave objectForKey:@"DateTo"];
}

- (int)propYearSubmitted{
    return [[[[NSString stringWithString:[_leave objectForKey:@"DateSubmitted"]] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue];
}

- (int)propTypeID{
    return [[_leave objectForKey:@"LeaveTypeID"] intValue];
}

+ (NSString *)propTypeDescriptionForKey:(int)key{
    switch (key) {
        case LEAVETYPEID_BIRTHDAY: return LEAVETYPEDESC_BIRTHDAY;
        case LEAVETYPEID_VACATION: return LEAVETYPEDESC_VACATION;
        case LEAVETYPEID_SICK: return LEAVETYPEDESC_SICK;
        case LEAVETYPEID_UNPAID: return LEAVETYPEDESC_UNPAID;
        case LEAVETYPEID_BEREAVEMENT: return LEAVETYPEDESC_BEREAVEMENT;
        case LEAVETYPEID_MATERNITY: return LEAVETYPEDESC_MATPAT;
        case LEAVETYPEID_DOCTOR: return LEAVETYPEDESC_DOCDENTIST;
        case LEAVETYPEID_HOSPITALIZATION: return LEAVETYPEDESC_HOSPITALIZATION;
        default: return LEAVETYPEDESC_BUSINESSTRIP; //business trip
    }
}

+ (int)propTypeKeyForDescription:(NSString *)desc{
    if([desc isEqualToString:LEAVETYPEDESC_BIRTHDAY]) return LEAVETYPEID_BIRTHDAY;
    else if([desc isEqualToString:LEAVETYPEDESC_VACATION]) return LEAVETYPEID_VACATION;
    else if([desc isEqualToString:LEAVETYPEDESC_SICK]) return LEAVETYPEID_SICK;
    else if([desc isEqualToString:LEAVETYPEDESC_UNPAID]) return LEAVETYPEID_UNPAID;
    else if([desc isEqualToString:LEAVETYPEDESC_BEREAVEMENT]) return LEAVETYPEID_BEREAVEMENT;
    else if([desc isEqualToString:LEAVETYPEDESC_MATPAT]) return LEAVETYPEID_MATERNITY;
    else if([desc isEqualToString:LEAVETYPEDESC_DOCDENTIST]) return LEAVETYPEID_DOCTOR;
    else if([desc isEqualToString:LEAVETYPEDESC_HOSPITALIZATION]) return LEAVETYPEID_HOSPITALIZATION;
    else return LEAVETYPEID_BUSINESSTRIP;
}

- (NSString *)propTypeDescription{
    return [Leave propTypeDescriptionForKey:[self propTypeID]];
}

+ (NSArray *)propTypeDescriptionListhasAll:(BOOL)hasAll{
    if(hasAll)
        return @[[AppDelegate all], LEAVETYPEDESC_BIRTHDAY, LEAVETYPEDESC_VACATION, LEAVETYPEDESC_SICK, LEAVETYPEDESC_UNPAID, LEAVETYPEDESC_BEREAVEMENT, LEAVETYPEDESC_MATPAT, LEAVETYPEDESC_DOCDENTIST, LEAVETYPEDESC_HOSPITALIZATION, LEAVETYPEDESC_BUSINESSTRIP];
    else
        return @[LEAVETYPEDESC_BIRTHDAY, LEAVETYPEDESC_VACATION, LEAVETYPEDESC_SICK, LEAVETYPEDESC_UNPAID, LEAVETYPEDESC_BEREAVEMENT, LEAVETYPEDESC_MATPAT, LEAVETYPEDESC_DOCDENTIST, LEAVETYPEDESC_HOSPITALIZATION, LEAVETYPEDESC_BUSINESSTRIP];

}

- (int)propStatusID{
    return [[_leave objectForKey:@"LeaveStatus"] intValue];
}

+ (NSString *)propStatusDescriptionForKey:(int)key{
    switch(key){
        case LEAVESTATUSID_PENDING: return LEAVESTATUSDESC_PENDING;
        case LEAVESTATUSID_CANCELLED: return LEAVESTATUSDESC_CANCELLED;
        case LEAVESTATUSID_APPROVED: return LEAVESTATUSDESC_APPROVED;
        default: return LEAVESTATUSDESC_REJECTED;
    }
}

+ (int)propStatusKeyForDesc:(NSString *)desc{
    if([desc isEqualToString:LEAVESTATUSDESC_APPROVED]) return LEAVESTATUSID_APPROVED;
    else if([desc isEqualToString:LEAVESTATUSDESC_CANCELLED]) return LEAVESTATUSID_CANCELLED;
    else if([desc isEqualToString:LEAVESTATUSDESC_REJECTED]) return LEAVESTATUSID_REJECTED;
    else return LEAVESTATUSID_PENDING;
}

- (NSString *)propStatusDescription{
    return [Leave propStatusDescriptionForKey:[self propStatusID]];
}

+ (NSArray *)propStatusDescriptionListhasAll:(BOOL)hasAll{
    if(hasAll)
        return @[[AppDelegate all], LEAVESTATUSDESC_PENDING, LEAVESTATUSDESC_CANCELLED, LEAVESTATUSDESC_APPROVED, LEAVESTATUSDESC_REJECTED];
    else
        return @[LEAVESTATUSDESC_PENDING, LEAVESTATUSDESC_CANCELLED, LEAVESTATUSDESC_APPROVED, LEAVESTATUSDESC_REJECTED];
}

- (float)propDays{
    return [[_leave objectForKey:@"Days"] floatValue];
}

- (float)propWorkingDays{
    return [[_leave objectForKey:@"WorkingDays"] floatValue];
}

- (NSString *)propNotes{
    return [_leave objectForKey:@"Notes"];
}

- (int)propYear{
    return [[[[NSString stringWithString:[self propStartDate]] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue];
}

- (float)propRemainingVL{
    return [[_leave objectForKey:@"VacationAllowance"] floatValue];
}

- (float)propRemainingSL{
    return [[_leave objectForKey:@"SickAllowance"] floatValue];
}

- (int)propHRID{
    return [[_leave objectForKey:@"HROfficerID"] intValue];
}

- (NSString *)propHREmail{
    return [_leave objectForKey:@"HROfficerEmail"];
}

- (NSString *)propHRName{
    return [_leave objectForKey:@"HROfficerName"];
}

- (NSString *)propAMEmail{
    return [_leave objectForKey:@"AccountManagerEmail"];
}

- (NSString *)propAMName{
    return [_leave objectForKey:@"AccountManagerName"];
}

- (int)propOfficeID{
    return [[_leave objectForKey:@"OfficeID"] intValue];
}

- (int)propLeaveApprover1ID{
    return [[_leave objectForKey:@"LeaveApprover1ID"] intValue];
}

- (NSString *)leaveApprover1Email{
    return [_leave objectForKey:@"LeaveApprover1Email"];
}

- (NSString *)propLeaveApprover1Name{
    return [_leave objectForKey:@"LeaveApprover1Name"];
}

- (int)leaveApprover2ID{
    return [[_leave objectForKey:@"LeaveApprover2ID"] intValue];
}

- (NSString *)leaveApprover2Email{
    return [_leave objectForKey:@"LeaveApprover2Email"];
}

- (NSString *)leaveApprover2Name{
    return [_leave objectForKey:@"LeaveApprover2Name"];
}

- (int)leaveApprover3ID{
    return [[_leave objectForKey:@"LeaveApprover3ID"] intValue];
}

- (NSString *)leaveApprover3Email{
    return [_leave objectForKey:@"LeaveApprover3Email"];
}

- (NSString *)leaveApprover3Name{
    return [_leave objectForKey:@"LeaveApprover3Name"];
}

- (BOOL)isApprover:(int)staffID{
    return ([self propLeaveApprover1ID]==staffID || [self leaveApprover2ID]==staffID || [self leaveApprover3ID]==staffID);
}

- (NSString *)propApproverName{
    return [_leave objectForKey:@"ApproverName"];
}

- (void)rejectLeaveFromStaff:(Staff *)staff withNotes:(NSString *)notes now:(NSString *)now{
    [_leave setObject:@([staff staffID]) forKey:@"ApproverID"];
    [_leave setObject:[NSString stringWithFormat:@"%@ %@",[staff fname], [staff lname]] forKey:@"ApproverName"];
    [_leave setObject:[staff email] forKey:@"ApproverEmail"];
    [_leave setObject:notes forKey:@"ApproverNotes"];
    [_leave setObject:now forKey:@"DateRejected"];
    [_leave setObject:@(LEAVESTATUSID_REJECTED) forKey:@"LeaveStatus"];
    [_leave setObject:LEAVESTATUSDESC_REJECTED forKey:@"LeaveStatusDesc"];
}

- (void)approveLeaveFromStaff:(Staff *)staff now:(NSString *)now{
    [_leave setObject:@([staff staffID]) forKey:@"ApproverID"];
    [_leave setObject:[NSString stringWithFormat:@"%@ %@",[staff fname], [staff lname]] forKey:@"ApproverName"];
    [_leave setObject:[staff email] forKey:@"ApproverEmail"];
    [_leave setObject:@"Approved" forKey:@"ApproverNotes"];
    [_leave setObject:now forKey:@"DateApproved"];
    [_leave setObject:@(LEAVESTATUSID_APPROVED) forKey:@"LeaveStatus"];
    [_leave setObject:LEAVESTATUSDESC_APPROVED forKey:@"LeaveStatusDesc"];
}

- (void)cancelLeaveFromStaff:(Staff *)staff now:(NSString *)now{
    [_leave setObject:@([staff staffID]) forKey:@"ApproverID"];
    [_leave setObject:[NSString stringWithFormat:@"%@ %@",[staff fname], [staff lname]] forKey:@"ApproverName"];
    [_leave setObject:[staff email] forKey:@"ApproverEmail"];
    [_leave setObject:@"Cancelled" forKey:@"ApproverNotes"];
    [_leave setObject:now forKey:@"DateCancelled"];
    [_leave setObject:@(LEAVESTATUSID_CANCELLED) forKey:@"LeaveStatus"];
    [_leave setObject:LEAVESTATUSDESC_CANCELLED forKey:@"LeaveStatusDesc"];
}

@end
