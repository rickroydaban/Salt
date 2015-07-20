//
//  UserPageNavigators.m
//  Jobs
//
//  Created by Rick Royd Aban on 10/2/14.
//  Copyright (c) 2014 applusvelosi. All rights reserved.
//

#import "PageNavigatorFactory.h"

@interface PageNavigatorFactory(){
    UIStoryboard *_sbMain, *_sbLogin, *_sbHome, *_sbMyLeaves, *_sbLeavesForApproval, *_sbMonthlyHolidays, *_sbLocalHolidays, *_sbMyCalendar;
    UINavigationController
        *_navigatorLogin,

        *_navigatorHome, *_navigatorMyLeaves, *_navigatorLeaveInput, *_navigatorLeavesForApproval, *_navigatorMonthlyHolidays, *_navigatorLocalHolidays, *_navigatorMyCalendar;
    
    VCHomeLeaves *_homeLeaveOverview;
}
@end

@implementation PageNavigatorFactory

static PageNavigatorFactory *sharedNavigators = nil;

+ (PageNavigatorFactory *)sharedNavigators{
    if(sharedNavigators == nil)
        sharedNavigators = [[super alloc] init];
    
    return sharedNavigators;
}

- (instancetype)init{
    self = [super init];
    
    if(self){
        //initialize storyboards
        _sbMain = [UIStoryboard storyboardWithName:@"SBMain" bundle:nil];
        _sbLogin = [UIStoryboard storyboardWithName:@"SBLogin" bundle:nil];
        _sbHome = [UIStoryboard storyboardWithName:@"SBHome" bundle:nil];
        _sbMyLeaves = [UIStoryboard storyboardWithName:@"SBMyLeaves" bundle:nil];
        _sbLeavesForApproval = [UIStoryboard storyboardWithName:@"SBLeavesForApproval" bundle:nil];
        _sbMonthlyHolidays = [UIStoryboard storyboardWithName:@"SBMonthlyHolidays" bundle:nil];
        _sbLocalHolidays = [UIStoryboard storyboardWithName:@"SBLocalHolidays" bundle:nil];
        _sbMyCalendar = [UIStoryboard storyboardWithName:@"SBMyCalendar" bundle:nil];
    }
    
    return self;
}

- (void)logout{
    _navigatorHome = nil;
    _navigatorMyLeaves = nil;
    _navigatorLeavesForApproval = nil;
    _navigatorMonthlyHolidays = nil;
    _navigatorLocalHolidays = nil;
    _navigatorMyCalendar = nil;
}

- (UINavigationController *)vcLogin{
    if(_navigatorLogin == nil)
        _navigatorLogin = [_sbLogin instantiateViewControllerWithIdentifier:@"loginPage"];
        
    return _navigatorLogin;
}

- (UINavigationController *)vcHome{
    if(_navigatorHome == nil)
        _navigatorHome = [_sbHome instantiateViewControllerWithIdentifier:@"homePage"];
    
    return _navigatorHome;
}

- (VCHomeLeaves *)vcHomeLeaveOverview{
    if(_homeLeaveOverview == nil)
        _homeLeaveOverview = [_sbHome instantiateViewControllerWithIdentifier:@"homeleave"];
    
    return _homeLeaveOverview;
}

- (UINavigationController *)vcMyLeaves{
    if(_navigatorMyLeaves == nil)
        _navigatorMyLeaves = [_sbMyLeaves instantiateViewControllerWithIdentifier:@"myleavePage"];
    
    return _navigatorMyLeaves;
}

- (UINavigationController *)vcLeaveInput{
    if(_navigatorLeaveInput == nil)
        _navigatorLeaveInput = [_sbMyLeaves instantiateViewControllerWithIdentifier:@"leaveinputPage"];
    
    return _navigatorLeaveInput;
}

- (UINavigationController *)vcLeavesForApproval{
    if(_navigatorLeavesForApproval == nil)
        _navigatorLeavesForApproval = [_sbLeavesForApproval instantiateViewControllerWithIdentifier:@"leavesforapprovalPage"];
    
    return _navigatorLeavesForApproval;
}

- (UINavigationController *)vcMonthlyHolidays{
    if(_navigatorMonthlyHolidays == nil)
        _navigatorMonthlyHolidays = [_sbMonthlyHolidays instantiateViewControllerWithIdentifier:@"monthlyHolidaysPage"];
    
    return _navigatorMonthlyHolidays;
}

- (UINavigationController *)vcLocalHolidays{
    if(_navigatorLocalHolidays == nil)
        _navigatorLocalHolidays = [_sbLocalHolidays instantiateViewControllerWithIdentifier:@"localHolidaysPage"];
    
    return _navigatorLocalHolidays;
}

- (UINavigationController *)vcMyCalendar{
    if(_navigatorMyCalendar == nil)
        _navigatorMyCalendar = [_sbMyCalendar instantiateViewControllerWithIdentifier:@"myCalendarPage"];
    
    return _navigatorMyCalendar;
}

@end
