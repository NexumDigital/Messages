//
//  NexumSearchViewController.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NexumProfileCell.h"
#import "NexumProfileViewController.h"

@interface NexumSearchViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *profiles;
@property (strong, nonatomic) NSDictionary *nextProfile;

@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) dispatch_queue_t imagesQueue;

- (void) loadDataFromPath:(NSString *)path withPage:(NSString *)page andQuery:(NSString *)query;
- (void) clearTable;

@end