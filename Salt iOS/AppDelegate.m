//
//  AppDelegate.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (){
    Staff *_staff; //must not be visible as interface so we can serialize this object for every staff and office update
    Office *_office;
    
    NSMutableArray *_myLeaves, *_leavesForApproval, *_monthlyHolidays, *_localHolidays;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.propPageNavigator = [PageNavigatorFactory sharedNavigators];
    
    self.propFormatVelosiDate = [[NSDateFormatter alloc] init];
    self.propFormatVelosiDate.dateFormat = @"dd-MMM-yyyy";
    self.propDateFormatMonthyear = [[NSDateFormatter alloc] init];
    self.propDateFormatMonthyear.dateFormat = @"MMMM-yyyy";
    self.propDateFormatDateTime = [[NSDateFormatter alloc] init];
    self.propDateFormatDateTime.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    self.propGatewayOnline = [[OnlineGateway alloc] initWithAppDelegate:self];
    self.propGatewayOffline = [[OfflineGateway alloc] initWithAppDelegate:self];
    
    _staffLeaveCounter = [[StaffLeaveCounter alloc] initWithAppDelegate:self];
    NSDateFormatter *yearOnlyFormatter = [[NSDateFormatter alloc] init];
    yearOnlyFormatter.dateFormat = @"yyyy";
    _currYear = [[yearOnlyFormatter stringFromDate:[NSDate date]] intValue];
    _filterYears = @[[NSString stringWithFormat:@"%d",_currYear+1], [NSString stringWithFormat:@"%d",_currYear], [NSString stringWithFormat:@"%d",_currYear-1], [NSString stringWithFormat:@"%d",_currYear-2], [NSString stringWithFormat:@"%d",_currYear-3], [NSString stringWithFormat:@"%d",_currYear-4]];
    
    if([_propGatewayOffline isLoggedIn]){
        _staff = [_propGatewayOffline deserializeStaff];
        _myLeaves = [_propGatewayOffline deserializeMyLeaves];
        _leavesForApproval = [_propGatewayOffline deserializeLeavesForApproval];
        _monthlyHolidays = [_propGatewayOffline deserializeMonthlyHolidays];
        _localHolidays = [_propGatewayOffline deserializeLocalHolidays];
    }else{
        _myLeaves = [NSMutableArray array];
        _leavesForApproval = [NSMutableArray array];
        _monthlyHolidays = [NSMutableArray array];
        _localHolidays = [NSMutableArray array];
        
    }

    return YES;
}

- (Staff *)staff{
    return _staff;
}

- (Office *)office{
    return _office;
}

- (void)updateStaffDataWithStaff:(Staff *)staff office:(Office *)office key:(OnlineGateway *)onlineGateway{
    _staff = staff;
    _office = office;
    [_propGatewayOffline serializeStaff:staff office:office];
}

- (void) initMyLeaves:(NSArray *)myLeaves leavesForApproval:(NSArray *)leavesForApproval{
    [_myLeaves removeAllObjects];
    [_leavesForApproval removeAllObjects];
    [_myLeaves addObjectsFromArray:myLeaves];
    [_leavesForApproval addObjectsFromArray:leavesForApproval];
    [_propGatewayOffline serializeMyLeaves:_myLeaves];
    [_propGatewayOffline serializeLeavesForApproval:_leavesForApproval];
}

- (void)updateMyLeaves:(NSMutableArray *)myLeaves{
    [_myLeaves removeAllObjects];
    [_myLeaves addObjectsFromArray:myLeaves];
    [_propGatewayOffline serializeMyLeaves:myLeaves];
}

- (void)updateLeavesForApproval:(NSMutableArray *)leavesForApproval{
    [_leavesForApproval removeAllObjects];
    [_leavesForApproval addObjectsFromArray:leavesForApproval];
    [_propGatewayOffline serializeLeavesForApproval:leavesForApproval];
}

- (void)updateMonthlyHolidays:(NSMutableArray *)monthlyHolidays{
    [_monthlyHolidays removeAllObjects];
    [_monthlyHolidays addObjectsFromArray:monthlyHolidays];
    [_propGatewayOffline serializeMonthlyHolidays:monthlyHolidays];
}

- (void)updateLocalHolidays:(NSMutableArray *)localHolidays{
    [_localHolidays removeAllObjects];
    [_localHolidays addObjectsFromArray:localHolidays];
    [_propGatewayOffline serializeLocalHolidays:localHolidays];
}

- (NSArray *)myLeaves{
    return _myLeaves;
}

- (NSArray *)leavesForApproval{
    return _leavesForApproval;
}

- (NSArray *)monthlyHolidays{
    return _monthlyHolidays;
}

- (NSArray *)localHolidays{
    return _localHolidays;
}

- (void)setSlider:(VCSlider *)slider{
    _propSlider = slider;
}

+ (NSString *)all{
    return @"All";
}

@end
