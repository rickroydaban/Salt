//
//  VCLeavesForApprovalProcessed.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/15/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCLeavesForApprovalProcessed.h"
#import "VCLeavesForApprovalTab.h"
#import "VelosiCustomPicker.h"
#import "Leave.h"
#import "CellLFAProcessed.h"
#import "MBProgressHUD.h"
#import "VCLFAProcessedDetail.h"

@interface VCLeavesForApprovalProcessed (){
    IBOutlet UITableView *_propLV;
    IBOutlet UITextField *_fieldName;
    IBOutlet UITextField *_fieldType;
    UIPickerView *_pickerLeaveType;
    VCLeavesForApprovalTab *_parentTabBar;
 
    NSMutableArray *_processedLeavesForApproval;
    NSArray *_leaveTypes;
}

@end

@implementation VCLeavesForApprovalProcessed

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leaveTypes = [Leave propTypeDescriptionListhasAll:YES];
    _processedLeavesForApproval = [NSMutableArray array];
    _pickerLeaveType = [[VelosiCustomPicker alloc] initWithArray:_leaveTypes rowSelectionDelegate:self selectedItem:[AppDelegate all]];
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.delegate = self;
    _propLV.dataSource = self;
    
    _parentTabBar = (VCLeavesForApprovalTab *)self.tabBarController;
    [_parentTabBar setCurrentLoaderDelegate:self];
    _fieldName.delegate = self;
    _fieldType.delegate = self;
    
    _fieldType.text = [AppDelegate all];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadApprovedLeavesForApprovalWithName:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellLFAProcessed *cell = (CellLFAProcessed *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell assignLeavesForApprovalProcessed:self];
    Leave *processedLeave = [_processedLeavesForApproval objectAtIndex:indexPath.row];
    
    cell.propLabelType.text = [processedLeave propTypeDescription];
    cell.propLabelDuration.text = [NSString stringWithFormat:@"%@ - %@",[processedLeave propStartDate],[processedLeave propEndDate]];
    cell.propLabelStaff.text = [processedLeave propStaffName];
    
    if([processedLeave propStatusID] == LEAVESTATUSID_REJECTED)
        cell.propButtonCancel.hidden = YES;
    else if([processedLeave propStatusID] == LEAVESTATUSID_APPROVED)
        cell.propButtonCancel.hidden = NO;
    cell.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _processedLeavesForApproval.count;
}

- (void)pickerSelection:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickerLeaveType){
        _fieldType.text = [_leaveTypes objectAtIndex:row];
        [self reloadApprovedLeavesForApprovalWithName:_fieldName.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _fieldType)
        textField.inputView = _pickerLeaveType;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == _fieldName){
        if(string.length > 0)
            [self reloadApprovedLeavesForApprovalWithName:[NSString stringWithFormat:@"%@%@",textField.text,string]];
        else
            [self reloadApprovedLeavesForApprovalWithName:[textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)]];
    }
    
    return YES;
}

- (void)reloadApprovedLeavesForApprovalWithName:(NSString *)name{
    [_processedLeavesForApproval removeAllObjects];
    for(Leave *leaveForApproval in _parentTabBar.propLeavesForApproval){
        if([leaveForApproval propStatusID]==LEAVESTATUSID_APPROVED || [leaveForApproval propStatusID]==LEAVESTATUSID_REJECTED){
            if([[leaveForApproval propTypeDescription] isEqualToString:_fieldType.text] || [_fieldType.text isEqualToString:[AppDelegate all]]){
                if([[[leaveForApproval propStaffName] lowercaseString] containsString:[name lowercaseString]] || name.length<1){ //filter by staff name
                    [_processedLeavesForApproval addObject:leaveForApproval];
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
    [_parentTabBar reloadLeavesForApprovalList];
}

- (void)loadFinished{
    [self reloadApprovedLeavesForApprovalWithName:_fieldName.text];
}

- (void)loadFailedWithError:(NSString *)error{
    [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

- (void)cancelLeaveAtIndex:(int)index{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        Leave *leave = [_processedLeavesForApproval objectAtIndex:index];
        [leave cancelLeaveFromStaff:self.propAppDelegate.staff now:[self.propAppDelegate.propDateFormatDateTime stringFromDate:[NSDate date]]];
        NSString *result = [self.propAppDelegate.propGatewayOnline processLeaveJSON:[[leave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forStatusID:LEAVESTATUSID_CANCELLED];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(result != nil)
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else{
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Leave Cancelled" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                [self reloadApprovedLeavesForApprovalWithName:@""];
            }
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    VCLFAProcessedDetail *vcLFAProcessedDetail = (VCLFAProcessedDetail *)segue.destinationViewController;
    vcLFAProcessedDetail.propLeave = [_processedLeavesForApproval objectAtIndex:((UITableViewCell *)sender).tag];
}


@end
