//
//  VCHome.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/19/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "MBProgressHUD.h"
#import "VCHome.h"
#import "VCHomeLeaves.h"
#import "VCHomeClaims.h"
#import "VCHomeAdvances.h"
#import "VelosiColors.h"

@interface VCHome (){
    UIBarButtonItem *_buttonRefresh, *_buttonWeeklyHolidays, *_buttonNewLeaveRequest;
    
    IBOutlet UIImageView *propImageUser;
    IBOutlet UILabel *propLabelName;
    IBOutlet UILabel *propLabelToday;
    IBOutlet UILabel *propLabelCurrentHeader;
    IBOutlet UIPageControl *propPageController;
    IBOutlet UIScrollView *propScrollview;
    
    UITableView *_lvLeaves;
    
    NSArray *_propHeaderTitles;
    int currHeaderIndex;
    NSDateFormatter *_homeDateFormat;
    
    VCHomeLeaves *_leavesPage;
//    VCHomeClaims *_claimsPage;
//    VCHomeAdvances *_advancesPage;
    
}

@end

@implementation VCHome

- (void)viewDidLoad {
    [super viewDidLoad];

    propLabelName.text = @"";
    _homeDateFormat = [[NSDateFormatter alloc] init];
    _homeDateFormat.dateFormat = @"dd-MMM-yyyy HH:mm:ss";
    _buttonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    _buttonWeeklyHolidays = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"actionbar_weeklycalendar"] style:UIBarButtonItemStylePlain target:self action:@selector(showWeeklyHoliday)];
    _buttonNewLeaveRequest = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"actionbar_newleaverequest"] style:UIBarButtonItemStylePlain target:self action:@selector(newLeaveRequest)];
    self.navigationItem.rightBarButtonItems = @[_buttonRefresh, _buttonWeeklyHolidays, _buttonNewLeaveRequest];
    
    _leavesPage = [self.propAppDelegate.propPageNavigator vcHomeLeaveOverview];
//    _claimsPage = [[VCHomeClaims alloc] init];
//    _advancesPage = [[VCHomeAdvances alloc] init];

//    UIView *testSubview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, propScrollview.frame.size.width, propScrollview.frame.size.height)];
//    testSubview.backgroundColor = [VelosiColors orangeVelosi];
//    [propScrollview addSubview:testSubview];
    _leavesPage.view.frame = CGRectMake(0, 0, propScrollview.frame.size.width, propScrollview.frame.size.height);
    [propScrollview addSubview:_leavesPage.view];
//    [propScrollview addSubview:_claimsPage.view];
//    [propScrollview addSubview:_advancesPage.view];
    [propScrollview setDelegate:self];
    
    
    NSInteger widthCount = [_propHeaderTitles count];
    propScrollview.contentSize = CGSizeMake(propScrollview.frame.size.width * widthCount, propScrollview.frame.size.height);
    propScrollview.contentOffset = CGPointMake(0, 0);
    
    propPageController.numberOfPages = [_propHeaderTitles count];
    propPageController.currentPage = 0;
    propLabelCurrentHeader = _propHeaderTitles[0];
    propLabelCurrentHeader.textColor = [VelosiColors orangeVelosi];
    
//    [self applynewIndex:0 pageController:_leavesPage];
//    [self applynewIndex:1 pageController:_claimsPage];
//    [self applynewIndex:2 pageController:_advancesPage];

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDateTime) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.propAppDelegate.staffLeaveCounter syncToServer:self];
}

- (void)showWeeklyHoliday{
    [self performSegueWithIdentifier:@"hometoweeklyholidays" sender:_buttonNewLeaveRequest];
}

- (void)newLeaveRequest{
    [self.navigationController pushViewController:[self.propAppDelegate.propPageNavigator vcLeaveInput] animated:YES];
}

- (void)updateDateTime{
    propLabelToday.text = [_homeDateFormat stringFromDate:[NSDate date]];
}

- (IBAction)toggleSidebar:(id)sender {
    [self.propAppDelegate.propSlider toggleSidebar];
}


- (void)addToSwipeView:(UITableView *)tableView{
    
}

#pragma mark scrolling
- (void)applynewIndex:(NSInteger)newIndex pageController:(UITableViewController *)pageController{
    BOOL outOfBounds =  newIndex >= [_propHeaderTitles count] || newIndex < 0;
    
    if(!outOfBounds){
        CGRect pageFrame = pageController.view.frame;
        pageFrame.origin.x = propScrollview.frame.size.width * newIndex;
        pageFrame.origin.y = 0;
        pageController.view.frame = pageFrame;
    }else{
        CGRect pageFrame = pageController.view.frame;
        pageFrame.origin.y = propScrollview.frame.size.height;
        pageController.view.frame = pageFrame;
    }
}

-  (void)scrollViewDidScroll:(UIScrollView *)sender{
    CGFloat pageWidth = propScrollview.frame.size.width;
    currHeaderIndex = (int)floor(propScrollview.contentOffset.x / pageWidth);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView{
    [self scrollViewDidEndScrollingAnimation:newScrollView];
    propPageController.currentPage = currHeaderIndex;
    propLabelCurrentHeader.text = _propHeaderTitles[(int)currHeaderIndex];
}

- (IBAction)changePage:(id)sender {
    NSInteger pageIndex = propPageController.currentPage;
    
    //update the scroll view to the appropriate page
    CGRect frame = propScrollview.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    
    [propScrollview scrollRectToVisible:frame animated:YES];
}

- (void)onSyncSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_leavesPage refresh];
    propLabelName.text = [NSString stringWithFormat:@"%@, %@",[[self.propAppDelegate staff] lname], [[self.propAppDelegate staff] fname]];
}

- (void)onSyncFailed:(NSString *)errorMessage{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
    propLabelName.text = [NSString stringWithFormat:@"%@, %@",[[self.propAppDelegate staff] lname], [[self.propAppDelegate staff] fname]];
}

@end
