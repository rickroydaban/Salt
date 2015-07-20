//
//  UserPageNavigators.h
//  Jobs
//
//  Created by Rick Royd Aban on 10/2/14.
//  Copyright (c) 2014 applusvelosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class VCHomeLeaves;

@interface PageNavigatorFactory : NSObject

+ (PageNavigatorFactory *)sharedNavigators;

- (void)logout;
- (UINavigationController *)vcLogin;
- (UINavigationController *)vcHome;
- (VCHomeLeaves *)vcHomeLeaveOverview;
- (UINavigationController *)vcMyLeaves;
- (UINavigationController *)vcLeaveInput;
- (UINavigationController *)vcLeavesForApproval;
- (UINavigationController *)vcMonthlyHolidays;
- (UINavigationController *)vcLocalHolidays;
- (UINavigationController *)vcMyCalendar;

@end
