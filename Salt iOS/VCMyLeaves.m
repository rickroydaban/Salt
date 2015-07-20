//
//  VCMyLeaves.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/21/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCMyLeaves.h"
#import "MBProgressHUD.h"
#import "CellMyLeave.h"
#import "VelosiCustomPicker.h"
#import "VCMyLeaveDetail.h"
#import "VelosiColors.h"

@interface VCMyLeaves (){
    
    IBOutlet UITextField *_propFieldYear;
    IBOutlet UITextField *_propFieldLeaveStatus;
    IBOutlet UITextField *_propFieldLeaveType;
    IBOutlet UITableView *_propLV;
    
    UIBarButtonItem *_buttonNewLeaveRequest;
    UIPickerView *_pickerYear, *_pickerLeaveType, *_pickerLeaveStatus;
    
    NSMutableArray *_propListLeaves; //leaves fetched online
    NSMutableArray *_myLeaves; //filtered leaves
    NSArray *_leaveTypes, *_leaveStatuses;
}
@end

@implementation VCMyLeaves

- (void)viewDidLoad {
    [super viewDidLoad];
    _leaveTypes = [Leave propTypeDescriptionListhasAll:true];
    _leaveStatuses = [Leave propStatusDescriptionListhasAll:true];
    _propListLeaves = [NSMutableArray array];
    _myLeaves = [NSMutableArray array];
    
    _pickerYear = [[VelosiCustomPicker alloc] initWithArray:self.propAppDelegate.filterYears rowSelectionDelegate:self selectedItem:[NSString stringWithFormat:@"%d",self.propAppDelegate.currYear]];
    _pickerLeaveType = [[VelosiCustomPicker alloc] initWithArray:_leaveTypes rowSelectionDelegate:self selectedItem:@"All"];
    _pickerLeaveStatus = [[VelosiCustomPicker alloc] initWithArray:_leaveStatuses rowSelectionDelegate:self selectedItem:@"All"];
    
    _buttonNewLeaveRequest = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"actionbar_newleaverequest"] style:UIBarButtonItemStylePlain target:self action:@selector(newLeaveRequest)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)], _buttonNewLeaveRequest];
    
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.dataSource = self;
    _propLV.delegate = self;

    _propFieldYear.delegate = self;
    _propFieldLeaveType.delegate = self;
    _propFieldLeaveStatus.delegate = self;
    
    _propFieldYear.text = [NSString stringWithFormat:@"%d",self.propAppDelegate.currYear];
    _propFieldYear.tintColor = [UIColor clearColor];
    _propFieldLeaveType.text = @"All";
    _propFieldLeaveType.tintColor = [UIColor clearColor];
    _propFieldLeaveStatus.text = @"All";
    _propFieldLeaveStatus.tintColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [self refresh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellMyLeave *cell = (CellMyLeave *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    Leave *myLeave = [_myLeaves objectAtIndex:indexPath.row];
    cell.propLabelType.text = [myLeave propTypeDescription];
    cell.propLabelStatus.text = [myLeave propStatusDescription];
    cell.propLabelDuration.text = [NSString stringWithFormat:@"%@ - %@", [myLeave propStartDate], [myLeave propEndDate]];
    
    if([myLeave propStatusID] == LEAVESTATUSID_APPROVED) cell.propLabelStatus.textColor = [VelosiColors greenAcceptance];
    else if([myLeave propStatusID] == LEAVESTATUSID_PENDING) cell.propLabelStatus.textColor = [UIColor lightGrayColor];
    else cell.propLabelStatus.textColor = [VelosiColors redRejection];

    cell.tag = indexPath.row;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myLeaves.count;
}

- (IBAction)toggleList:(id)sender {
    [self.propAppDelegate.propSlider toggleSidebar];
}
                              
- (void)refresh{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id result = [self.propAppDelegate.propGatewayOnline myLeaves];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([result isKindOfClass:[NSString class]])
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else{
                [_propListLeaves removeAllObjects];
                [_propListLeaves addObjectsFromArray:result];
                
                [self reloadMyLeaves];
                [self.propAppDelegate.propGatewayOffline serializeMyLeaves:_propListLeaves];
            }
        });
    });
}

- (void)reloadMyLeaves{
    [_myLeaves removeAllObjects];
    for(Leave *myLeave in _propListLeaves){
        if([[myLeave propStatusDescription] isEqualToString:_propFieldLeaveStatus.text] || [_propFieldLeaveStatus.text isEqualToString:[AppDelegate all]]){ //filter by status
            if([[myLeave propTypeDescription] isEqualToString:_propFieldLeaveType.text] || [_propFieldLeaveType.text isEqualToString:[AppDelegate all]]){
                [_myLeaves addObject:myLeave];
            }
        }
    }
    
    [_propLV reloadData];
}

- (void)newLeaveRequest{
    [self performSegueWithIdentifier:@"myleavestonewleaverequest" sender:_buttonNewLeaveRequest];
}

- (void)pickerSelection:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickerYear)
        _propFieldYear.text = [self.propAppDelegate.filterYears objectAtIndex:row];
    else if(pickerView == _pickerLeaveType)
        _propFieldLeaveType.text = [_leaveTypes objectAtIndex:row];
    else if(pickerView == _pickerLeaveStatus)
        _propFieldLeaveStatus.text = [_leaveStatuses objectAtIndex:row];
    
    [self reloadMyLeaves];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _propFieldYear)
        textField.inputView = _pickerYear;
    else if(textField == _propFieldLeaveType)
        textField.inputView = _pickerLeaveType;
    else if(textField == _propFieldLeaveStatus)
        textField.inputView = _pickerLeaveStatus;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[UITableViewCell class]]){
        VCMyLeaveDetail *vcMyLeaveDetails = (VCMyLeaveDetail *)segue.destinationViewController;
        vcMyLeaveDetails.propLeave = [_propListLeaves objectAtIndex:((CellMyLeave *)sender).tag];
    }
}

@end
