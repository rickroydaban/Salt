//
//  VCLeavesForApprovalTab.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/11/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCLeavesForApprovalTab.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface VCLeavesForApprovalTab (){
    id<LoaderDelegate> _loaderDelegate;
}

@end

@implementation VCLeavesForApprovalTab

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _propLeavesForApproval = [NSMutableArray array];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self reloadLeavesForApprovalList];
}

- (void)setCurrentLoaderDelegate:(id<LoaderDelegate>)loaderDelegate{
    _loaderDelegate = loaderDelegate;
}

- (void)reloadLeavesForApprovalList{ //reload from tab item controllers
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id result = [((AppDelegate *)[[UIApplication sharedApplication] delegate]).propGatewayOnline leavesForApproval];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([result isKindOfClass:[NSString class]]) [_loaderDelegate loadFailedWithError:result];
            else{
                [_propLeavesForApproval removeAllObjects];
                [_propLeavesForApproval addObjectsFromArray:result];
                [((AppDelegate *)[[UIApplication sharedApplication] delegate]).propGatewayOffline serializeLeavesForApproval:self.propLeavesForApproval];
                [_loaderDelegate loadFinished];
            }
        });
    });
}

@end
