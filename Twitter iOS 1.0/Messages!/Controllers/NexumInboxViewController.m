//
//  NexumInboxViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumInboxViewController.h"

@interface NexumInboxViewController ()

@end

@implementation NexumInboxViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.imagesQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.threads = [NSMutableArray array];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showChat"]){
        NexumThreadViewController *threadView = [segue destinationViewController];
        threadView.thread = self.nextThread;
    }
}

#pragma mark - TableView delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nextThread = [self.threads objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"showChat" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0 < [self.threads count])
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    return [self.threads count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InboxCell";
    NexumThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *thread = [self.threads objectAtIndex:indexPath.row];
    cell.expectedIdentifier = thread[@"identifier"];
    [cell reuseCellWithThread:thread andQueue:self.imagesQueue];
    
    return cell;
}

@end
