//
//  VCWeeklyHolidays.m
//  Salt
//
//  Created by Rick Royd Aban on 7/16/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "VCWeeklyHolidays.h"
#import "MBProgressHUD.h"
#import "CellHoliday.h"
#import "Holiday.h"

@interface VCWeeklyHolidays(){
    
    IBOutlet UITableView *_propLV;
    NSMutableArray *_weeklyHolidays;
}
@end

@implementation VCWeeklyHolidays

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _weeklyHolidays = [NSMutableArray array];
    _propLV.delegate = self;
    _propLV.dataSource = self;
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.rowHeight = UITableViewAutomaticDimension;
    _propLV.estimatedRowHeight = 90;
    [self syncFromServer];
}

- (IBAction)refresh:(id)sender {
    [self syncFromServer];
}

- (void)syncFromServer{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id result = [self.propAppDelegate.propGatewayOnline weeklyholiday];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([result isKindOfClass:[NSString class]])
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else{
                [_weeklyHolidays removeAllObjects];
                [_weeklyHolidays addObjectsFromArray:result];
                [_propLV reloadData];
            }
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellHoliday *cell = (CellHoliday *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    Holiday *holiday = [_weeklyHolidays objectAtIndex:indexPath.row];
    
    cell.propLabelName.text = [holiday name];
    cell.propLabelCountry.text = [holiday country];
    cell.propLabelDate.text = [holiday dateStr];
    cell.propTextViewOffices.text = [holiday officeStr];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _weeklyHolidays.count;
}

@end
