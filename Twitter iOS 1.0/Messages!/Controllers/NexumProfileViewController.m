//
//  NexumProfileViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/14/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumProfileViewController.h"

@interface NexumProfileViewController ()

@end

@implementation NexumProfileViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if(nil == self.profile)
        self.profile = [NexumDefaults currentAccount];
    else
        self.title = [NSString stringWithFormat:@"@%@", self.profile[@"username"]];
    
    self.username.text = [NSString stringWithFormat:@"@%@", self.profile[@"username"]];
    
    self.description.numberOfLines = 0;
    self.description.text = self.profile[@"description"];
    BOOL follower = [self.profile[@"follower"] boolValue];
    if(follower){
        self.actionToolbar.barTintColor = [UIColor C_4fdd86];
        self.actionButton.tintColor = [UIColor whiteColor];
        self.actionButton.title = @"chat";
    } else {
        BOOL following = [self.profile[@"following"] boolValue];
        if(following){
            self.actionToolbar.barTintColor = [UIColor whiteColor];
            self.actionButton.tintColor = [UIColor C_4fdd86];
            self.actionButton.title = @"send chat request";
        } else {
            self.actionToolbar.barTintColor = [UIColor C_1ab4ef];
            self.actionButton.tintColor = [UIColor whiteColor];
            self.actionButton.title = @"follow";
        }
    }
    
    [self clearTable];
    self.path = @"contacts/twitter/following";
    self.followingButton.tintColor = [UIColor whiteColor];
    [self loadDataFromPath:self.path withPage:self.page];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.description sizeToFit];
    
    self.infoPlaceholder.frame = CGRectMake(self.infoPlaceholder.frame.origin.x, self.infoPlaceholder.frame.origin.y, self.infoPlaceholder.frame.size.width, (self.description.frame.size.height + 74));
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.backOverlay.alpha = 1;
        self.infoPlaceholder.center = self.mainPlaceholder.center;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        self.pictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profile[@"picture"]]];
        self.pictureImage = [UIImage imageWithData:self.pictureData];
        self.pictureImage = [NexumUtil imageWithRoundedCornersSize:36.0 usingImage:self.pictureImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.picture.image = self.pictureImage;
            }];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if(![[NSString stringWithFormat:@"%@",self.profile[@"back"]] isEqualToString:@""]){
            self.backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profile[@"back"]]];
            self.backImage = [UIImage imageWithData:self.backData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^(void) {
                if(![[NSString stringWithFormat:@"%@",self.profile[@"back"]] isEqualToString:@""]){
                    self.back.image = self.backImage;
                }
                self.back.alpha = 1;
            }];
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark - TableView delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NexumProfileViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
    dest.profile =[self.profiles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dest animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0 < [self.profiles count])
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    return [self.profiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProfileCell";
    NexumProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *profile = [self.profiles objectAtIndex:indexPath.row];
    cell.identifier = profile[@"identifier"];
    [cell reuseCellWithProfile:profile];
    
    if([self.profiles count] < (indexPath.row + 20)){
        if([NSNull null] != (NSNull *)self.page){
            [self loadDataFromPath:self.path withPage:self.page];
        }
    }
    
    return cell;
}

#pragma mark - Load data

- (void) loadDataFromPath:(NSString *)path withPage:(NSString *)page {
    if(!self.isLoading){
        self.isLoading = YES;
        
        NSString *params = [NSString stringWithFormat:@"identifier=%@&page=%@",
                            self.profile[@"identifier"],
                            page
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

#pragma mark - Actions

- (IBAction)followingAction:(id)sender {
    [self clearTable];
    self.path = @"contacts/twitter/following";
    self.followersButton.tintColor = [UIColor C_22a1d9];
    self.followingButton.tintColor = [UIColor whiteColor];
    [self loadDataFromPath:self.path withPage:self.page];
}

- (IBAction)followersAction:(id)sender {
    [self clearTable];
    self.path = @"contacts/twitter/followers";
    self.followingButton.tintColor = [UIColor C_22a1d9];
    self.followersButton.tintColor = [UIColor whiteColor];
    [self loadDataFromPath:self.path withPage:self.page];
}

#pragma mark - Helpers

- (void) clearTable {
    self.profiles = [NSMutableArray array];
    self.isLoading = NO;
    self.page = @"0";
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
}

@end
