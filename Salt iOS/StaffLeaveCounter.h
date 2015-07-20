//
//  StaffLeaveCounter.h
//  Salt
//
//  Created by Rick Royd Aban on 6/29/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffLeaveSyncListener.h"
@class AppDelegate;

@interface StaffLeaveCounter : NSObject

- (StaffLeaveCounter *)initWithAppDelegate:(AppDelegate *)appDelegate;
- (void)syncToServer:(id<StaffLeaveSyncListener>)syncListener;
//reqs
- (int)approvedVLRequests;
- (int)approvedSLReqests;
- (int)approvedULRequest;
- (int)approvedMPLRequests;
- (int)approvedDLRequests;
- (int)approvedBLRequests;
- (int)approvedHLRequests;
- (int)approvedBTLRequests;
- (int)pendingVLRequests;
- (int)pendingULRequests;
//days
- (float)approvedVLDays;
- (float)approvedSLDays;
- (float)approvedULDays;
- (float)approvedDLDays;
- (float)approvedMPLDays;
- (float)approvedBLDays;
- (float)approvedHLDays;
- (float)approvedBTLDays;
- (float)pendingVLDays;
- (float)pendingSLDays;
- (float)pendingULDays;
//remaining days
- (float)remainingVLDays;
- (float)remainingSLDays;
- (float)remainingBLDays;
- (float)remainingMatPatDays;
- (float)remainingHLDays;

@end
