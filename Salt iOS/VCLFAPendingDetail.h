//
//  VCLFAPendingDetail.h
//  Salt
//
//  Created by Rick Royd Aban on 7/15/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "VCDetail.h"
#import "Leave.h"

@interface VCLFAPendingDetail : VCDetail<UIAlertViewDelegate>

@property (strong, nonatomic) Leave *propLeave;

@end
