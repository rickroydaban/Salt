//
//  VCLeavesForApprovalCancelled.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/15/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCLeavesForApprovalCancelled.h"
#import "CellLFACancelled.h"
#import "Leave.h"
#import "VelosiCustomPicker.h"
#import "MBProgressHUD.h"
#import "VCLeavesForApprovalTab.h"
#import "VCLFACancelledDetail.h"

@interface VCLeavesForApprovalCancelled (){
    
    IBOutlet UITableView *_propLV;
    IBOutlet UITextField *_fieldName;
    IBOutlet UITextField *_fieldType;
    UIPickerView *_pickerLeaveType;
    VCLeavesForApprovalTab *parentTabBar;
    NSMutableArray *_cancelledLeavesForApproval;
    
    NSArray *_leaveTypes;
}

@end

@implementation VCLeavesForApprovalCancelled

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leaveTypes = [Leave propTypeDescriptionListhasAll:YES];
    _cancelledLeavesForApproval = [NSMutableArray array];
    _pickerLeaveType = [[VelosiCustomPicker alloc] initWithArray:_leaveTypes rowSelectionDelegate:self selectedItem:[AppDelegate all]];
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.delegate = self;
    _propLV.dataSource = self;

    parentTabBar = (VCLeavesForApprovalTab *)self.tabBarController;
    [parentTabBar setCurrentLoaderDelegate:self];
    _fieldName.delegate = self;
    _fieldType.delegate = self;
    
    _fieldType.text = [AppDelegate all];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadCancelledLeavesForApprovalWithName:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellLFACancelled *cell = (CellLFACancelled *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    Leave *cancelledLeave = [_cancelledLeavesForApproval objectAtIndex:indexPath.row];
    
    cell.propLabelType.text = [cancelledLeave propTypeDescription];
    cell.propLabelDuration.text = [NSString stringWithFormat:@"%@ - %@", [cancelledLeave propStartDate], [cancelledLeave propEndDate]];
    cell.propLabelStaff.text = [cancelledLeave propStaffName];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cancelledLeavesForApproval.count;
}

- (void)pickerSelection:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickerLeaveType){
        _fieldType.text = [_leaveTypes objectAtIndex:row];
        [self reloadCancelledLeavesForApprovalWithName:_fieldName.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _fieldType)
        textField.inputView = _pickerLeaveType;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == _fieldName){
        if(string.length > 0)
            [self reloadCancelledLeavesForApprovalWithName:[NSString stringWithFormat:@"%@%@",textField.text,string]];
        else
            [self reloadCancelledLeavesForApprovalWithName:[textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)]];
    }
    
    return YES;
}

- (void)reloadCancelledLeavesForApprovalWithName:(NSString *)name{
    [_cancelledLeavesForApproval removeAllObjects];
    for(Leave *leaveForApproval in [self.propAppDelegate leavesForApproval]){
        if([leaveForApproval propStatusID] == LEAVESTATUSID_CANCELLED){ //filter by status
            if([[leaveForApproval propTypeDescription] isEqualToString:_fieldType.text] || [_fieldType.text isEqualToString:[AppDelegate all]]){
                if([[[leaveForApproval propStaffName] lowercaseString] containsString:[name lowercaseString]] || name.length<1){
                    [_cancelledLeavesForApproval addObject:leaveForApproval];
                }
            }
        }
    }
    
    [_propLV reloadData];
}

- (IBAction)toggleList:(id)sender {
    [self.propAppDelegate.propSlider toggleSidebar];
}
- (IBAction)refresh:(id)sender {
    [self reloadCancelledLeavesForApprovalWithName:_fieldName.text];
}

- (void)loadFinished{
    [self reloadCancelledLeavesForApprovalWithName:_fieldName.text];
}

- (void)loadFailedWithError:(NSString *)error{
    [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    VCLFACancelledDetail *vcLFACancelledDetail = (VCLFACancelledDetail *)segue.destinationViewController;
    vcLFACancelledDetail.propLeave = [_cancelledLeavesForApproval objectAtIndex:((UITableViewCell *)sender).tag];
}


@end
