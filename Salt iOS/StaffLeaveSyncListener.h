//
//  StaffLeaveSyncListener.h
//  Salt
//
//  Created by Rick Royd Aban on 6/29/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StaffLeaveSyncListener <NSObject>

- (void)onSyncSuccess;
- (void)onSyncFailed:(NSString *)errorMessage;

@end
