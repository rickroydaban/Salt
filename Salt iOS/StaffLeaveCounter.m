//
//  StaffLeaveCounter.m
//  Salt
//
//  Created by Rick Royd Aban on 6/29/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "StaffLeaveCounter.h"
#import "Leave.h"

@interface StaffLeaveCounter(){
    AppDelegate *_appDelegate;
    
    int _approvedVLReqs, _approvedSLReqs, _approvedULReqs, _approvedMPLReqs, _approvedDLReqs, _approvedBLReqs, _approvedHLReqs, _approvedBTLReqs,
        _pendingVLReqs, _pendingULReqs;
    float _approvedVLDays, _approvedSLDays, _approvedULDays, _approvedMPLDays, _approvedDLDays, _approvedBLDays, _approvedHLDays, _approvedBTLDays,
          _pendingVLDays, _pendingSLDays, _pendingULDays, _pendingBLDays, _pendingHLDays, _pendingMPLDays;
}
@end

@implementation StaffLeaveCounter

- (StaffLeaveCounter *)initWithAppDelegate:(AppDelegate *)appDelegate{
    if(self = [super init]){
        _appDelegate = appDelegate;
    }
    
    return self;
}

- (void)syncToServer:(id<StaffLeaveSyncListener>)syncListener{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *updateStaffResult = [_appDelegate.propGatewayOnline updateAppStaffDataWithStaffID:[_appDelegate.staff staffID] securityLevel:[_appDelegate.staff securityLevel] officeID:[_appDelegate.staff officeID]];
        id myLeaveResult = [_appDelegate.propGatewayOnline myLeaves];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(updateStaffResult!=nil || [myLeaveResult isKindOfClass:[NSString class]])
                [syncListener onSyncFailed:myLeaveResult];
            else{
                [_appDelegate updateMyLeaves:myLeaveResult];
                if([_appDelegate.staff isApprover]){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        id leavesForApprovalResult = [_appDelegate.propGatewayOnline leavesForApproval];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if([leavesForApprovalResult isKindOfClass:[NSString class]])
                                [syncListener onSyncFailed:leavesForApprovalResult];
                            else{
                                [_appDelegate updateLeavesForApproval:leavesForApprovalResult];
                                [self updateValues];
                                [syncListener onSyncSuccess];
                            }
                        });
                    });
                }else{
                    [self updateValues];
                    [syncListener onSyncSuccess];
                }
            }
                
        });
    });
}

- (void)updateValues{
    _approvedVLReqs = _approvedSLReqs = _approvedULReqs = _approvedMPLReqs = _approvedDLReqs = _approvedBLReqs = _approvedHLReqs = _approvedBTLReqs = _pendingVLReqs = _pendingULReqs = 0;
    _approvedVLDays = _approvedSLDays = _approvedULDays = _approvedMPLDays = _approvedDLDays = _approvedBLDays = _approvedHLDays = _approvedBTLDays = _pendingVLDays = _pendingSLDays = _pendingBLDays = _pendingHLDays = _pendingMPLDays = 0;
    
    for(Leave *leave in [_appDelegate myLeaves]){
        if([leave propStatusID] == LEAVESTATUSID_APPROVED){
            if([leave propTypeID] == LEAVETYPEID_VACATION) { _approvedVLReqs++; _approvedVLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_SICK) {  _approvedSLReqs++; _approvedSLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_MATERNITY) { _approvedMPLReqs++; _approvedMPLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_DOCTOR) { _approvedDLReqs++; _approvedDLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_BEREAVEMENT) {_approvedBLReqs++; _approvedBLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_HOSPITALIZATION) {_approvedHLReqs++; _approvedHLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_BUSINESSTRIP) { _approvedBTLReqs++; _approvedBTLDays+=[leave propWorkingDays]; }
        }else if([leave propStatusID] == LEAVESTATUSID_PENDING){
            if([leave propTypeID] == LEAVETYPEID_VACATION) {_pendingVLReqs++; _pendingVLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_UNPAID) { _pendingULReqs++; _pendingULDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_SICK) { _pendingSLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_BEREAVEMENT) { _pendingBLDays+=[leave propWorkingDays]; }
            else if([leave propTypeID] == LEAVETYPEID_MATERNITY) { _pendingMPLDays+=[leave propWorkingDays]; }
        }
    }
    
}

- (int)approvedVLRequests{
    return _approvedVLReqs;
}

- (int)approvedSLReqests{
    return _approvedSLReqs;
}

- (int)approvedULRequest{
    return _approvedULReqs;
}

- (int)approvedMPLRequests{
    return _approvedMPLReqs;
}

- (int)approvedDLRequests{
    return _approvedDLReqs;
}

- (int)approvedBLRequests{
    return _approvedBLReqs;
}

- (int)approvedHLRequests{
    return _approvedHLReqs;
}

- (int)approvedBTLRequests{
    return _approvedBTLReqs;
}

- (int)pendingVLRequests{
    return _pendingVLReqs;
}

- (int)pendingULRequests{
    return _pendingULReqs;
}

- (float)approvedVLDays{
    return _approvedVLDays;
}

- (float)approvedSLDays{
    return _approvedSLDays;
}

- (float)approvedULDays{
    return _approvedULDays;
}

- (float)approvedMPLDays{
    return _approvedMPLDays;
}

- (float)approvedDLDays{
    return _approvedDLDays;
}

- (float)approvedBLDays{
    return _approvedBLDays;
}

- (float)approvedHLDays{
    return _approvedHLDays;
}

- (float)approvedBTLDays{
    return _approvedBTLDays;
}

- (float)pendingVLDays{
    return _pendingVLDays;
}

- (float)pendingSLDays{
    return _pendingSLDays;
}

- (float)pendingULDays{
    return _pendingULDays;
}

- (float)remainingVLDays{
    NSLog(@"maxVL %f approvedVLDays %f pendingVLDays %f",[_appDelegate.staff maxVL], _approvedVLDays, _pendingVLDays);
    NSLog(@"returning remVL %f", [_appDelegate.staff maxVL] - _approvedVLDays - _pendingVLDays);
    return [_appDelegate.staff maxVL] - _approvedVLDays - _pendingVLDays;
}

- (float)remainingSLDays{
    return [_appDelegate.staff maxSL] - _approvedSLDays - _pendingSLDays;
}

- (float)remainingMatPatDays{
    return [_appDelegate.office maternityLimit] - _approvedMPLDays - _pendingMPLDays;
}

- (float)remainingHLDays{
    return [_appDelegate.office hospitalizationLimit] - _approvedHLDays - _pendingHLDays;
}

- (float)remainingBLDays{
    return [_appDelegate.office bereavementLimit] - _approvedBLDays - _pendingBLDays;
}

@end
