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
    self.username.text = [NSString stringWithFormat:@"@%@", self.profile[@"username"]];
    
    self.description.numberOfLines = 0;
    self.description.text = self.profile[@"description"];
    BOOL follower = [self.profile[@"follower"] boolValue];
    if(follower){
        self.actionToolbar.barTintColor = [UIColor C_4fdd86];
        self.actionButton.tintColor = [UIColor whiteColor];
        self.actionButton.title = @"chat";
    } else {
        NSLog(@"%@", self.profile[@"following"]);
        BOOL following = [self.profile[@"following"] boolValue];
        if(following){
            self.actionToolbar.barTintColor = [UIColor whiteColor];
            self.actionButton.tintColor = [UIColor C_11749f];
            self.actionButton.title = @"request access";
        } else {
            self.actionToolbar.barTintColor = [UIColor C_11749f];
            self.actionButton.tintColor = [UIColor whiteColor];
            self.actionButton.title = @"follow";
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profile[@"picture"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picture.image = [UIImage imageWithData:pictureImageData];
            self.picture.image = [NexumUtil imageWithRoundedCornersSize:42.0 usingImage:self.picture.image];
            
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.picture.alpha = 1;
            }];
        });
    });
    
    dispatch_async(queue, ^{
        NSData *backgroundImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profile[@"back"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImage.image = [UIImage imageWithData:backgroundImageData];
            
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.backgroundImage.alpha = 1;
            }];
        });
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.description sizeToFit];
    
    self.infoPlaceholder.frame = CGRectMake(self.infoPlaceholder.frame.origin.x, self.infoPlaceholder.frame.origin.y, self.infoPlaceholder.frame.size.width, (self.description.frame.size.height + 74));
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.backgroundOverlay.alpha = 1;
        self.infoPlaceholder.center = self.mainPlaceholder.center;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
