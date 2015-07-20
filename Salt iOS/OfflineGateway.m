//
//  OfflineGateway.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/22/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#define PREVUSERNAME @"prevusername"
#define KEY_MYLEAVES @"myleaveskey"
#define KEY_LEAVESFORAPPROVAL @"leavesforapprovalkey"
#define KEY_STAFF @"staffkey"
#define kEY_OFFICE @"officekey"
//holidays
#define KEY_LOCALHOLIDAYS @"localholidayskey"

#import "OfflineGateway.h"

@interface OfflineGateway(){
    AppDelegate *_appDelegate;
    NSUserDefaults *_prefs;
}
@end

@implementation OfflineGateway

- (OfflineGateway *) initWithAppDelegate:(AppDelegate *)appDelegate{
    if(self = [super init]){
        _prefs = [NSUserDefaults standardUserDefaults];
        _appDelegate = appDelegate;
    }
    return self;
}

- (void)updatePreviouslyUsedUsername:(NSString *)username{
    [_prefs setObject:username forKey:PREVUSERNAME];
}

- (BOOL)isLoggedIn{
    return ([_prefs objectForKey:KEY_STAFF] != nil)?YES:NO;
}

- (void)logout{
    //    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    [_prefs removeObjectForKey:KEY_STAFF];
    [_prefs removeObjectForKey:kEY_OFFICE];
    [_prefs removeObjectForKey:KEY_MYLEAVES];
    [_prefs removeObjectForKey:KEY_LEAVESFORAPPROVAL];
}

- (NSString *)getPrevUsername{
    return ([_prefs objectForKey:PREVUSERNAME] != nil)?[_prefs objectForKey:PREVUSERNAME]:@"";
}

- (void)serializeStaff:(Staff *)staff office:(Office *)office{
    [_prefs setObject:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[staff staffDictionary] options:0 error:nil] encoding:NSUTF8StringEncoding] forKey:KEY_STAFF];
    [_prefs setObject:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[office savableDictionary] options:0 error:nil] encoding:NSUTF8StringEncoding] forKey:kEY_OFFICE];
}

- (void)serializeMyLeaves:(NSMutableArray *)myLeaves{
    NSMutableArray *leaveMaps = [NSMutableArray array];
    for(id leave in myLeaves)
        [leaveMaps addObject:[leave savableDictionary]];
    
    [_prefs setObject:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:leaveMaps options:0 error:nil] encoding:NSUTF8StringEncoding] forKey:KEY_MYLEAVES];
}

- (void)serializeLeavesForApproval:(NSMutableArray *)leavesForApproval{
    NSMutableArray *leaveForApprovalMaps = [NSMutableArray array];
    
    for(Leave *leaveForApproval in leavesForApproval)
        [leaveForApprovalMaps addObject:[leaveForApproval savableDictionary]];
    
    [_prefs setObject:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:leaveForApprovalMaps options:0 error:nil] encoding:NSUTF8StringEncoding] forKey:KEY_LEAVESFORAPPROVAL];
}

- (void)serializeLocalHolidays:(NSMutableArray *)localHolidays{
    NSMutableArray *localHolidaysMap = [NSMutableArray array];
    
    for(LocalHoliday *localHoliday in localHolidays)
        [localHolidaysMap addObject:[localHoliday savableDictionary]];
    
    [_prefs setObject:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:localHolidaysMap options:0 error:nil] encoding:NSUTF8StringEncoding] forKey:KEY_LOCALHOLIDAYS];
}

- (Staff *)deserializeStaff{
    return [[Staff alloc] initWithOfflineGateway:_appDelegate.propGatewayOffline staffDictionary:[NSJSONSerialization JSONObjectWithData:[[_prefs objectForKey:KEY_STAFF] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
}

- (Office *)deserializeStaffOffice{
    return [NSJSONSerialization JSONObjectWithData:[[_prefs objectForKey:kEY_OFFICE] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (NSMutableArray *)deserializeMyLeaves{
    return [NSJSONSerialization JSONObjectWithData:[[_prefs objectForKey:KEY_MYLEAVES] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (NSMutableArray *)deserializeLeavesForApproval{
    return [NSJSONSerialization JSONObjectWithData:[[_prefs objectForKey:KEY_LEAVESFORAPPROVAL] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (NSMutableArray *)deserializeLocalHolidays{
    return [NSJSONSerialization JSONObjectWithData:[[_prefs objectForKey:KEY_LOCALHOLIDAYS] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}
@end
