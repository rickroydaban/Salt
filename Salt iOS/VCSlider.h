//
//  VCSlider.h
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VCLogin;

@interface VCSlider : UIViewController<UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>


- (void)toggleSidebar;
- (void)login:(VCLogin *)key;

@end
