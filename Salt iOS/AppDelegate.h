//
//  AppDelegate.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#define ALL @"All"

#import <UIKit/UIKit.h>
#import "Staff.h"
#import "Office.h"
#import "PageNavigatorFactory.h"
#import "VCSlider.h"
#import "OnlineGateway.h"
#import "OfflineGateway.h"
#import "StaffLeaveCounter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic, readonly) VCSlider *propSlider;
@property (strong, nonatomic) PageNavigatorFactory *propPageNavigator;
@property (strong, nonatomic) OfflineGateway *propGatewayOffline;
@property (strong, nonatomic) OnlineGateway *propGatewayOnline;
@property (strong, nonatomic) NSDateFormatter *propFormatVelosiDate, *propDateFormatMonthyear, *propDateFormatDateTime;
@property (strong, nonatomic, readonly) StaffLeaveCounter *staffLeaveCounter;
@property (strong, nonatomic, readonly) NSArray *filterYears;
@property (assign, nonatomic, readonly) int currYear;


//required by IOS
@property (strong, nonatomic) UIWindow *window;

- (Staff *)staff;
- (Office *)office;
- (void)updateStaffDataWithStaff:(Staff *)staff office:(Office *)office key:(OnlineGateway *)onlineGateway;
- (void)initMyLeaves:(NSArray *)myLeaves leavesForApproval:(NSArray *)leavesForApproval;
- (void)updateMyLeaves:(NSMutableArray *)myLeaves;
- (void)updateLeavesForApproval:(NSMutableArray *)leavesForApproval;
- (NSArray *)myLeaves;
- (NSArray *)leavesForApproval;

- (void)setSlider:(VCSlider *)slider;
+ (NSString *)all;
@end

