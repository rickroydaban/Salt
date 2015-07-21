//
//  VCLeavesForApprovalPending.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/11/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//


#import "VCLeavesForApprovalPending.h"
#import "CellLFAPending.h"
#import "Leave.h"
#import "VelosiCustomPicker.h"
#import "MBProgressHUD.h"
#import "VCLeavesForApprovalTab.h"
#import "VCLFAPendingDetail.h"

@interface VCLeavesForApprovalPending (){
    IBOutlet UITableView *_propLV;
    IBOutlet UITextField *_fieldName;
    IBOutlet UITextField *_fieldType;
    UIPickerView *_pickerLeaveType;
    VCLeavesForApprovalTab *parentTabbar;
    NSMutableArray *_pendingLeavesForApproval;
    
    NSArray *_leaveTypes;
}

@end

@implementation VCLeavesForApprovalPending

- (void)viewDidLoad{
    [super viewDidLoad];

    _leaveTypes = [Leave propTypeDescriptionListhasAll:YES];
    _pendingLeavesForApproval = [NSMutableArray array];
    _pickerLeaveType = [[VelosiCustomPicker alloc] initWithArray:_leaveTypes rowSelectionDelegate:self selectedItem:[AppDelegate all]];
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.delegate = self;
    _propLV.dataSource = self;
    
    parentTabbar = (VCLeavesForApprovalTab *)self.tabBarController;
    [parentTabbar setCurrentLoaderDelegate:self];
    _fieldName.delegate = self;
    _fieldType.delegate = self;
    
    _fieldType.text = [AppDelegate all];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadPendingLeavesForApprovalWithName:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellLFAPending *cell = (CellLFAPending *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell assignVCLeavesForApprovalPending:self];
    Leave *pendingLeave = [_pendingLeavesForApproval objectAtIndex:indexPath.row];
    
    cell.propLabelType.text = [pendingLeave propTypeDescription];
    cell.propLabelDuration.text = [NSString stringWithFormat:@"%@ - %@", [pendingLeave propStartDate], [pendingLeave propEndDate]];
    cell.propLabelStaff.text = [pendingLeave propStaffName];
    cell.propButtonApprove.tag = indexPath.row;
    cell.propButtonReject.tag = indexPath.row;
    cell.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pendingLeavesForApproval.count;
}

- (void)pickerSelection:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickerLeaveType){
        _fieldType.text = [_leaveTypes objectAtIndex:row];
        [self reloadPendingLeavesForApprovalWithName:_fieldName.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _fieldType)
        textField.inputView = _pickerLeaveType;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == _fieldName){
        if(string.length > 0)
            [self reloadPendingLeavesForApprovalWithName:[NSString stringWithFormat:@"%@%@",textField.text,string]];
        else
            [self reloadPendingLeavesForApprovalWithName:[textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)]];
    }
    
    return YES;
}


- (void)reloadPendingLeavesForApprovalWithName:(NSString *)name{
     [_pendingLeavesForApproval removeAllObjects];
    for(Leave *leaveForApproval in [self.propAppDelegate leavesForApproval]){
        if([leaveForApproval propStatusID] == LEAVESTATUSID_PENDING){ //filter by status
            if([[leaveForApproval propTypeDescription] isEqualToString:_fieldType.text] || [_fieldType.text isEqualToString:[AppDelegate all]]){
                if([[[leaveForApproval propStaffName] lowercaseString] containsString:[name lowercaseString]] || name.length<1){ //filter by staff name
                    [_pendingLeavesForApproval addObject:leaveForApproval];
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
    [parentTabbar reloadLeavesForApprovalList];
}

- (void)loadFinished{
    [self reloadPendingLeavesForApprovalWithName:_fieldName.text];
}

- (void)loadFailedWithError:(NSString *)error{
    [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

//used by the corresponding cell in this tableview
- (void)approveLeaveAtIndex:(int)index{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        Leave *leave = [_pendingLeavesForApproval objectAtIndex:index];
        [leave approveLeaveFromStaff:self.propAppDelegate.staff now:[self.propAppDelegate.propDateFormatDateTime stringFromDate:[NSDate date]]];
        NSString *result = [self.propAppDelegate.propGatewayOnline processLeaveJSON:[[leave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forStatusID:LEAVESTATUSID_APPROVED];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(result != nil)
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else{
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Leave Approved" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                [self reloadPendingLeavesForApprovalWithName:@""];
            }
        });
    });
}

- (void)rejectLeaveAtIndex:(int)index{
    UIAlertView *rejectDialog = [[UIAlertView alloc] initWithTitle:@"" message:@"Reason for rejection" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Reject", nil];
    rejectDialog.tag = index;
    rejectDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [rejectDialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){ //reject
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            Leave *leave = [_pendingLeavesForApproval objectAtIndex:alertView.tag];
            [leave rejectLeaveFromStaff:self.propAppDelegate.staff withNotes:[alertView textFieldAtIndex:0].text now:[self.propAppDelegate.propDateFormatDateTime stringFromDate:[NSDate date]]];
            NSString *result = [self.propAppDelegate.propGatewayOnline processLeaveJSON:[[leave jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forStatusID:LEAVESTATUSID_REJECTED];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(result != nil)
                    [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                else{
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Leave Rejected" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                    [self reloadPendingLeavesForApprovalWithName:@""];
                }
            });
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    VCLFAPendingDetail *vcLFAPendingDetail = (VCLFAPendingDetail *)segue.destinationViewController;
    vcLFAPendingDetail.propLeave = [_pendingLeavesForApproval objectAtIndex:((UITableViewCell *)sender).tag];
}
@end
