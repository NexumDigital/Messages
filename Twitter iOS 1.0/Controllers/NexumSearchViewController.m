//
//  NexumSearchViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumSearchViewController.h"

@interface NexumSearchViewController ()

@end

@implementation NexumSearchViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.profiles = [NSMutableArray array];
    self.visibleCells = [NSMutableDictionary dictionary];
    self.isLoading = NO;
    self.path = @"contacts/twitter/suggested";
    self.page = @"0";
    self.query = @"";
    
    self.searchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadDataFromPath:self.path withPage:self.page andQuery:self.query];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showProfile"]){
        NexumProfileViewController *profileView = [segue destinationViewController];
        profileView.profile = self.selectedProfile;
    }
}

#pragma mark - SearchBar delegate

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.profiles = [NSMutableArray array];
    self.visibleCells = [NSMutableDictionary dictionary];
    self.isLoading = NO;
    self.path = @"contacts/twitter/search";
    self.page = @"";
    self.query = searchBar.text;
    
    [self loadDataFromPath:self.path withPage:self.page andQuery:searchBar.text];
}

#pragma mark - TableView delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedProfile = [self.profiles objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"showProfile" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.profiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProfileCell";
    NexumProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(nil == cell.index)
        cell.index = [NSString stringWithFormat:@"%lu", (unsigned long)[self.visibleCells count]];
    
    NSDictionary *profile = [self.profiles objectAtIndex:indexPath.row];
    
    cell.fullname.text = profile[@"fullname"];
    cell.username.text = [NSString stringWithFormat:@"@%@", profile[@"username"]];
    BOOL follower = [profile[@"follower"] boolValue];
    if(follower){
        [cell.button setBackgroundImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"chat_tap"] forState:UIControlStateHighlighted];
    } else {
        [cell.button setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"invite_tap"] forState:UIControlStateHighlighted];
    }
    
    NSString *profileIdentifier = [NSString stringWithFormat:@"%@", profile[@"identifier"]];
    NSString *assignedCell = [NSString stringWithFormat:@"%@", self.visibleCells[cell.index]];
    if(![assignedCell isEqualToString:profileIdentifier]){
        [self.visibleCells setObject:profile[@"identifier"] forKey:cell.index];
        cell.picture.image = [UIImage imageWithContentsOfFile:@""];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSString *profileIdentifier = nil;
            NSString *assignedCell = nil;
            NSData *thumbData = nil;
            
            profileIdentifier = [NSString stringWithFormat:@"%@", profile[@"identifier"]];
            assignedCell = [NSString stringWithFormat:@"%@", self.visibleCells[cell.index]];
            if([assignedCell isEqualToString:profileIdentifier]){
                thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profile[@"picture"]]];
            }
            
            profileIdentifier = [NSString stringWithFormat:@"%@", profile[@"identifier"]];
            assignedCell = [NSString stringWithFormat:@"%@", self.visibleCells[cell.index]];
            if([assignedCell isEqualToString:profileIdentifier]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.picture.image = [UIImage imageWithData:thumbData];
                    [cell setNeedsLayout];
                });
            }
        });
    }
    
    if([self.profiles count] < (indexPath.row + 20)){
        if([NSNull null] != (NSNull *)self.page){
            [self loadDataFromPath:self.path withPage:self.page andQuery:self.query];
        }
    }
    
    return cell;
}

#pragma mark - Load data

- (void) loadDataFromPath:(NSString *)path withPage:(NSString *)page andQuery:(NSString *)query{
    if(!self.isLoading){
        self.isLoading = YES;
        
        NSString *params = [NSString stringWithFormat:@"identifier=%@&page=%@&query=%@",
                            [NexumDefaults currentAccount][@"identifier"],
                            page,
                            query
                            ];
        
        [NexumBackend apiRequest:@"GET" forPath:path withParams:params andBlock:^(BOOL success, NSDictionary *data) {
            if(success){
                self.page = data[@"pagination"][@"next"];
                [self.profiles addObjectsFromArray:data[@"profiles_data"]];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            self.isLoading = NO;
        }];
    }
}

@end
