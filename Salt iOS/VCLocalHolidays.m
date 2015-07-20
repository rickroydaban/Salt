//
//  VCLocalHolidays.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 6/8/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "VCLocalHolidays.h"
#import "MBProgressHUD.h"
#import "CellLocalHolidays.h"

@interface VCLocalHolidays (){
    NSMutableArray *_propListLocalHolidays; //impose mutability since the values will change here every refresh
    NSMutableArray *_propListHeaders;
    NSMutableDictionary *_propDictHeaderItems;
    
    IBOutlet UITableView *_propLV;
    
}

@end

@implementation VCLocalHolidays

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _propListLocalHolidays = [NSMutableArray array];
    _propListHeaders = [NSMutableArray array];
    _propDictHeaderItems = [NSMutableDictionary dictionary];
    
    _propLV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _propLV.dataSource = self;
    _propLV.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self refresh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellLocalHolidays *cell = (CellLocalHolidays *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    LocalHoliday *localHoliday = [(NSMutableArray *)[_propDictHeaderItems objectForKey:[_propListHeaders objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.propLabelTitle.text = localHoliday.propName;
    cell.propLabelDay.text = localHoliday.propDay;
    cell.propLabelDate.text = localHoliday.propDate;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSMutableArray *)[_propDictHeaderItems objectForKey:[_propListHeaders objectAtIndex:section]] count];
}

- (IBAction)toggleList:(id)sender {
    [self.propAppDelegate.propSlider toggleSidebar];
}

- (IBAction)refresh:(id)sender {
    [self refresh];
}

- (void)refresh{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id result = [self.propAppDelegate.propGatewayOnline localHolidays];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([result isKindOfClass:[NSString class]])
                [[[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            else{
                [_propListHeaders removeAllObjects];
                [_propListLocalHolidays removeAllObjects];
                [_propListLocalHolidays addObjectsFromArray:result];
                [_propDictHeaderItems removeAllObjects];
                
                NSString *tempHeader = @"";
                for(LocalHoliday *localHoliday in _propListLocalHolidays){
                    if(![[localHoliday propMonth] isEqualToString:tempHeader]){
                        tempHeader = [localHoliday propMonth];
                        [_propListHeaders addObject:tempHeader];
                        [_propDictHeaderItems setObject:[NSMutableArray array] forKey:tempHeader];
                        [(NSMutableArray *)[_propDictHeaderItems objectForKey:tempHeader] addObject:localHoliday];
                    }else
                        [(NSMutableArray *)[_propDictHeaderItems objectForKey:tempHeader] addObject:localHoliday];
                }
                
                [_propLV reloadData];
                [self.propAppDelegate.propGatewayOffline serializeLocalHolidays:_propListLocalHolidays];
            }
        });
    });
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_propListHeaders objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _propListHeaders.count;
}

@end
