//
//  VCSlider.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#define MAXPANNING 250
#define MINPANTOSHOWMAINPAGE 100
#define ANIMATIONDURATION 0.3f

#define SIDEBAR_HOME @"Home"
#define SIDEBAR_MYLEAVES @"My Leaves"
#define SIDEBAR_LEAVESFORAPPROVAL @"Leaves for Approval"
#define SIDEBAR_MONTHLYHOLIDAYS @"Holidays of the Month"
#define SIDEBAR_LOCALHOLIDAYS @"Local Holidays"
#define SIDEBAR_MYCALENDAR @"My Calendar"

#import "VCSlider.h"
#import "DAKeyboardControl.h"
#import "AppDelegate.h"
#import "VelosiColors.h"
#import "CellSidebar.h"
#import "PageNavigatorFactory.h"

@interface VCSlider (){
    IBOutlet UITableView *_propLvSidebar;
    IBOutlet UIView *_propMainPage;
    
    CGFloat _mainPageX;
    UIViewController *_currMainController;
    NSIndexPath *_currIndexPath;
    BOOL _isSidebarShowing;
    
    NSArray *_sidebarLeaveItemLabels, *_sidebarLeaveItemImages, *_sidebarLeaveItemHighlightedImages;
    AppDelegate *appDelegate;
}
@end

@implementation VCSlider

- (void)viewDidLoad {
    [super viewDidLoad];

    [_propMainPage addKeyboardPanningWithActionHandler:nil];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setSlider:self];
    _mainPageX = 0;
    _isSidebarShowing = NO;
    
    _propMainPage.layer.shadowColor = [UIColor blackColor].CGColor;
    _propMainPage.layer.shadowOpacity = 1;
    _propMainPage.layer.shadowOffset = CGSizeMake(0, 0);
    
    [self updateSidebarItemsShouldReload:NO];
    _propLvSidebar.delegate = self;
    _propLvSidebar.dataSource = self;
    
    NSIndexPath *initIndexPath = ([appDelegate.propGatewayOffline isLoggedIn])?[NSIndexPath indexPathForRow:0 inSection:0]:[NSIndexPath indexPathForRow:0 inSection:2];
    [_propLvSidebar selectRowAtIndexPath:initIndexPath animated:NO  scrollPosition:UITableViewScrollPositionBottom];
    [_propLvSidebar.delegate tableView:_propLvSidebar didSelectRowAtIndexPath:initIndexPath];
}

#pragma mark private methods
- (void)changePage:(UIViewController *)controller{
    if([controller isKindOfClass:[UINavigationController class]])
        [(UINavigationController *)controller setDelegate:self];
    
    if (_currMainController == nil) {
        controller.view.frame = _propMainPage.bounds;
        _currMainController = controller;
        [self addChildViewController:_currMainController];
        [_propMainPage addSubview:_currMainController.view];
        [_currMainController didMoveToParentViewController:self];
    } else if (_currMainController != controller && controller !=nil) {
        controller.view.frame = _propMainPage.bounds;
        [_currMainController willMoveToParentViewController:nil];
        [self addChildViewController:controller];
        self.view.userInteractionEnabled = NO;
        [self transitionFromViewController:_currMainController
                          toViewController:controller
                                  duration:0
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{}
                                completion:^(BOOL finished){
                                    self.view.userInteractionEnabled = YES;
                                    [_currMainController removeFromParentViewController];
                                    [controller didMoveToParentViewController:self];
                                    _currMainController = controller;
                                    
                                    [self updateSidebarWillShow:NO];
                                }
         ];
    }
}

- (void)updateSidebarWillShow:(BOOL)willShow{
    _propMainPage.userInteractionEnabled = NO;
    _propLvSidebar.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
        _propMainPage.transform = CGAffineTransformMakeTranslation((willShow)?MAXPANNING:0, 0);
    } completion:^(BOOL finished){
        _propMainPage.userInteractionEnabled = YES;
        _propLvSidebar.userInteractionEnabled = YES;
        _isSidebarShowing = willShow;
        _mainPageX = 0;
    }];
}

#pragma mark public methods
- (void)toggleSidebar{
    if(!_isSidebarShowing)
        [self.view endEditing:YES];
    
    [self updateSidebarWillShow:!_isSidebarShowing];
}

#pragma mark implemented methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0: return 1;
        case 1: return ([[appDelegate staff] isAdmin] || [[appDelegate staff] isCM] || [[appDelegate staff] isAM])?5:4;
        case 2: return 1;
            
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellSidebar *cell = [_propLvSidebar dequeueReusableCellWithIdentifier:@"cell"];
//    UILabel *selBgView = [[UILabel alloc] initWithFrame:cell.backgroundView.frame];
//    selBgView.backgroundColor = [VelosiColors orangeVelosi];
//    cell.selectedBackgroundView = selBgView;
    
    switch (indexPath.section) {
        case 0:
            cell.cellIImage.image = [UIImage imageNamed:@"icon_home"];
            cell.cellIImage.highlightedImage = [UIImage imageNamed:@"icon_home_sel"];
            cell.cellTitle.text = @"Home";
            break;
            
        case 1:
            cell.cellIImage.image = [UIImage imageNamed:[_sidebarLeaveItemImages objectAtIndex:indexPath.row]];
            cell.cellIImage.highlightedImage = [UIImage imageNamed:[_sidebarLeaveItemHighlightedImages objectAtIndex:indexPath.row]];
            cell.cellTitle.text = [_sidebarLeaveItemLabels objectAtIndex:indexPath.row];
            break;
            
        case 2:
            cell.cellIImage.image = [UIImage imageNamed:@"icon_logout"];
            cell.cellIImage.highlightedImage = [UIImage imageNamed:@"icon_logout_sel"];
            cell.cellTitle.text = @"Logout";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Have to manually set label and image colors before and after selection since ios will remove borders when relying to default highlighting functionalities
    NSIndexPath *temp = indexPath;
    if(_currIndexPath!=nil && _currIndexPath.section == indexPath.section && _currIndexPath.row == indexPath.row)
        [self updateSidebarWillShow:NO];
    else{
        CellSidebar *currSelectedCell = (CellSidebar *)[_propLvSidebar cellForRowAtIndexPath:indexPath];
        CellSidebar *prevSelectedCell = (CellSidebar *)[_propLvSidebar cellForRowAtIndexPath:_currIndexPath];
        
        //manage icon and label color for previously selected cells
        [prevSelectedCell.cellTitle setTextColor:[VelosiColors blackSidebarFont]];
        switch (_currIndexPath.section) {
            case 0: [prevSelectedCell.cellIImage setImage:[UIImage imageNamed:@"icon_home"]]; break;
            case 1: [prevSelectedCell.cellIImage setImage:[UIImage imageNamed:[_sidebarLeaveItemImages objectAtIndex:_currIndexPath.row]]]; break;
            case 2: [prevSelectedCell.cellIImage setImage:[UIImage imageNamed:@"icon_logout"]]; break;
            default: break;
        }
        
        [currSelectedCell.cellTitle setTextColor:[VelosiColors orangeVelosi]];
        switch (indexPath.section) {
            case 0:
                [currSelectedCell.cellIImage setImage:[UIImage imageNamed:@"icon_home_sel"]];
                [self changePage:[appDelegate.propPageNavigator vcHome]];
                break;
                
            case 1:
                [currSelectedCell.cellIImage setImage:[UIImage imageNamed:[_sidebarLeaveItemHighlightedImages objectAtIndex:indexPath.row]]];
                
                if([[_sidebarLeaveItemLabels objectAtIndex:indexPath.row] isEqualToString:SIDEBAR_MYLEAVES]) [self changePage:[appDelegate.propPageNavigator vcMyLeaves]];
                else if([[_sidebarLeaveItemLabels objectAtIndex:indexPath.row] isEqualToString:SIDEBAR_LEAVESFORAPPROVAL]) [self changePage:[appDelegate.propPageNavigator vcLeavesForApproval]];
                else if([[_sidebarLeaveItemLabels objectAtIndex:indexPath.row] isEqualToString:SIDEBAR_MONTHLYHOLIDAYS]) [self changePage:[appDelegate.propPageNavigator vcMonthlyHolidays]];
                else if([[_sidebarLeaveItemLabels objectAtIndex:indexPath.row] isEqualToString:SIDEBAR_LOCALHOLIDAYS]) [self changePage:[appDelegate.propPageNavigator vcLocalHolidays]];
                else if([[_sidebarLeaveItemLabels objectAtIndex:indexPath.row] isEqualToString:SIDEBAR_MYCALENDAR]) [self changePage:[appDelegate.propPageNavigator vcMyCalendar]];
               break;
                
            case 2:
                [currSelectedCell.cellIImage setImage:[UIImage imageNamed:@"icon_logout_sel"]];
                [appDelegate.propGatewayOffline logout];
                [appDelegate.propPageNavigator logout];
                [self changePage:[appDelegate.propPageNavigator vcLogin]];
                break;
                
            default:
                break;
        }
    }
    
    _currIndexPath = temp;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0: return @"";
        case 1: return @"Leave";
        default: return @"";
    }
}

- (void)login:(VCLogin *)key{
    if([appDelegate.propGatewayOffline isLoggedIn]){
        NSIndexPath *reloadedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_propLvSidebar selectRowAtIndexPath:reloadedIndexPath animated:NO  scrollPosition:UITableViewScrollPositionBottom];
        [_propLvSidebar.delegate tableView:_propLvSidebar didSelectRowAtIndexPath:reloadedIndexPath];
        [self updateSidebarItemsShouldReload:YES];
    }else
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Error! Not logged in" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

- (void)updateSidebarItemsShouldReload:(BOOL)shouldReload{
    if([[appDelegate staff] isAdmin] || [[appDelegate staff] isCM] || [[appDelegate staff] isAM]){ //has approval privileges
        _sidebarLeaveItemLabels = @[SIDEBAR_MYLEAVES, SIDEBAR_LEAVESFORAPPROVAL, SIDEBAR_MONTHLYHOLIDAYS, SIDEBAR_LOCALHOLIDAYS, SIDEBAR_MYCALENDAR];
        _sidebarLeaveItemImages = @[@"icon_myleaves", @"icon_leavesforapproval", @"icon_monthlyholidays", @"icon_localholidays", @"icon_mycalendar"];
        _sidebarLeaveItemHighlightedImages = @[@"icon_myleaves_sel", @"icon_leavesforapproval_sel", @"icon_monthlyholidays_sel", @"icon_localholidays_sel", @"icon_mycalendar_sel"];
    }else{
        _sidebarLeaveItemLabels = @[SIDEBAR_MYLEAVES, SIDEBAR_MONTHLYHOLIDAYS, SIDEBAR_LOCALHOLIDAYS, SIDEBAR_MYCALENDAR];
        _sidebarLeaveItemImages = @[@"icon_myleaves", @"icon_monthlyholidays", @"icon_localholidays", @"icon_mycalendar"];
        _sidebarLeaveItemHighlightedImages = @[@"icon_myleaves_sel", @"icon_monthlyholidays_sel", @"icon_localholidays_sel", @"icon_mycalendar_sel"];
    }

    [_propLvSidebar reloadData];
}

@end
