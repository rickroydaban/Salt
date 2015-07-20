//
//  VCHomeLeaves.m
//  Salt
//
//  Created by Rick Royd Aban on 8/19/14.
//  Copyright (c) 2014 applusvelosi. All rights reserved.
//


#import "VCHomeLeaves.h"
#import "VCHomeScrollPage.h"
#import "VelosiColors.h"
#import "HomeOverviewItem.h"
#import "CellHomeHeader.h"
#import "CellHomeItem1.h"
#import "CellHomeItem2.h"
#import "StaffLeaveCounter.h"
@class StaffLeaveCounter;

@interface VCHomeLeaves (){
    
    NSMutableArray *_items;
    StaffLeaveCounter *_leaveCtr;
    AppDelegate *_appDelegate;
}

@end

@implementation VCHomeLeaves

- (void)viewDidLoad{
    [super viewDidLoad];

    _items = [[NSMutableArray alloc] init];
    _leaveCtr = self.propAppDelegate.staffLeaveCounter;
    
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Consumed Leaves" requestCountStr:@"# of Reqs" daysCount:@"# of Days" cellType:HomeOverviewItem_HEADER]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Vacation" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Sick" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM2]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Unpaid" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Maternity/Paternity" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM2]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Doctor/Dentist" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Bereavement" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM2]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Hospitalization" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Business Trip" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM2]];
    
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Balance" requestCountStr:@"" daysCount:@"# of Days" cellType:HomeOverviewItem_HEADER]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Vacation" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Sick" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM2]];
    
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Pending" requestCountStr:@"# of Reqs" daysCount:@"# of Days" cellType:HomeOverviewItem_HEADER]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Vacation" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Unpaid" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM2]];
    
    if([[self.propAppDelegate staff] isAdmin] || [[self.propAppDelegate staff] isCM] || [[self.propAppDelegate staff] isAM]){
        [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Approver's Section" requestCountStr:@"# of Reqs" daysCount:@"" cellType:HomeOverviewItem_HEADER]];
        int leavesForApprovalCtr = 0;
        for(Leave *leave in [self.propAppDelegate leavesForApproval]){
            if([leave propStatusID] == LEAVESTATUSID_PENDING && [leave isApprover:[self.propAppDelegate.staff staffID]])
                leavesForApprovalCtr++;
        }
        
        [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Leaves for Approval" requestCountStr:@"" daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeOverviewItem *item = [_items objectAtIndex:indexPath.row];
    if([item propCellType] == HomeOverviewItem_HEADER){
        CellHomeHeader *cell = (CellHomeHeader *)[tableView dequeueReusableCellWithIdentifier:@"cell_header"];

        cell.propLabelName.text = item.propName;
        cell.propLabelCntReqs.text = item.propRequestCnt;
        cell.propLabelCntDays.text = item.propDaysCnt;
        
        return cell;
    }else if([item propCellType] == HomeOverviewItem_ITEM1){
        CellHomeItem1 *cell = (CellHomeItem1 *)[tableView dequeueReusableCellWithIdentifier:@"cell_item1"];

        cell.propLabelName.text = item.propName;
        cell.propLabelCntReqs.text = item.propRequestCnt;
        cell.propLabelCntDays.text = item.propDaysCnt;
        
        return cell;
    }else{
        CellHomeItem2 *cell = (CellHomeItem2 *)[tableView dequeueReusableCellWithIdentifier:@"cell_item2"];

        cell.propLabelName.text = item.propName;
        cell.propLabelCntReqs.text = item.propRequestCnt;
        cell.propLabelCntDays.text = item.propDaysCnt;
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

- (void)refresh{
    [_items removeAllObjects];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Consumed Leaves" requestCountStr:@"# of Reqs" daysCount:@"# of Days" cellType:HomeOverviewItem_HEADER]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Vacation" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr approvedVLRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedVLDays]] cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Sick" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr approvedSLReqests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedSLDays]] cellType:HomeOverviewItem_ITEM2]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Unpaid" requestCountStr:[NSString stringWithFormat:@"%d", [_leaveCtr approvedULRequest]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedULDays]] cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Maternity/Paternity" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr approvedMPLRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedMPLDays]] cellType:HomeOverviewItem_ITEM2]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Doctor/Dentist" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr approvedDLRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedDLDays]] cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Bereavement" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr approvedBLRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedBLDays]] cellType:HomeOverviewItem_ITEM2]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Hospitalization" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr approvedHLRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedHLDays]] cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Business Trip" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr approvedBTLRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr approvedBTLDays]] cellType:HomeOverviewItem_ITEM2]];
    
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Balance" requestCountStr:@"" daysCount:@"# of Days" cellType:HomeOverviewItem_HEADER]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Vacation" requestCountStr:@"" daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr remainingVLDays]] cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Sick" requestCountStr:@"" daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr remainingSLDays]] cellType:HomeOverviewItem_ITEM2]];
    
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Pending" requestCountStr:@"# of Reqs" daysCount:@"# of Days" cellType:HomeOverviewItem_HEADER]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Vacation" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr pendingVLRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr pendingVLDays]] cellType:HomeOverviewItem_ITEM1]];
    [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Unpaid" requestCountStr:[NSString stringWithFormat:@"%d",[_leaveCtr pendingULRequests]] daysCount:[NSString stringWithFormat:@"%.1f",[_leaveCtr pendingULDays]] cellType:HomeOverviewItem_ITEM2]];
    
    if([[self.propAppDelegate staff] isAdmin] || [[self.propAppDelegate staff] isCM] || [[self.propAppDelegate staff] isAM]){
        [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Approver's Section" requestCountStr:@"# of Reqs" daysCount:@"" cellType:HomeOverviewItem_HEADER]];
        int leavesForApprovalCtr = 0;
        for(Leave *leave in [self.propAppDelegate leavesForApproval]){
            if([leave propStatusID] == LEAVESTATUSID_PENDING && [leave isApprover:[self.propAppDelegate.staff staffID]])
                leavesForApprovalCtr++;
        }
        
        [_items addObject:[[HomeOverviewItem alloc] initWithName:@"Leaves for Approval" requestCountStr:[NSString stringWithFormat:@"%d",leavesForApprovalCtr] daysCount:@"" cellType:HomeOverviewItem_ITEM1]];
    }

    [self.tableView reloadData];
}

@end
