//
//  NexumInboxTableViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumInboxTableViewController.h"

@interface NexumInboxTableViewController ()

@end

@implementation NexumInboxTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.threads = [NSMutableArray array];
    self.visibleCells = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [NexumBackend apiRequest:@"GET" forPath:@"threads/twitter" withParams:@"" andBlock:^(BOOL success, NSDictionary *data) {
        if(success){
            self.threads = data[@"threads_data"];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.threads count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InboxCell";
    NexumThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(nil == cell.index)
        cell.index = [NSString stringWithFormat:@"%lu", (unsigned long)[self.visibleCells count]];
    
    NSDictionary *thread = [self.threads objectAtIndex:indexPath.row];
    
    BOOL opened = [thread[@"opened"] boolValue];
    
    if(opened){
        cell.indicator.backgroundColor = [UIColor C_ededea];
    } else {
        cell.indicator.backgroundColor = [UIColor C_4fdd86];
    }
    
    cell.title.text = thread[@"title"];
    cell.preview.text = thread[@"preview"];
    cell.timeago.text = thread[@"timeago"];
    
    NSString *threadIdentifier = [NSString stringWithFormat:@"%@", thread[@"identifier"]];
    NSString *assignedCell = [NSString stringWithFormat:@"%@", self.visibleCells[cell.index]];
    if(![assignedCell isEqualToString:threadIdentifier]){
        [self.visibleCells setObject:thread[@"identifier"] forKey:cell.index];
        cell.picture.image = [UIImage imageWithContentsOfFile:@""];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSString *threadIdentifier = nil;
            NSString *assignedCell = nil;
            NSData *thumbData = nil;
            
            threadIdentifier = [NSString stringWithFormat:@"%@", thread[@"identifier"]];
            assignedCell = [NSString stringWithFormat:@"%@", self.visibleCells[cell.index]];
            if([assignedCell isEqualToString:threadIdentifier]){
                thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thread[@"picture"]]];
            }
            
            threadIdentifier = [NSString stringWithFormat:@"%@", thread[@"identifier"]];
            assignedCell = [NSString stringWithFormat:@"%@", self.visibleCells[cell.index]];
            if([assignedCell isEqualToString:threadIdentifier]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.picture.image = [UIImage imageWithData:thumbData];
                    [cell setNeedsLayout];
                });
            }
        });
    }
    
    return cell;
}

@end
