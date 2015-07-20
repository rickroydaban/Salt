//
//  LoaderDelegate.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/11/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoaderDelegate <NSObject>

- (void)loadFinished;
- (void)loadFailedWithError:(NSString *)error;

@end
