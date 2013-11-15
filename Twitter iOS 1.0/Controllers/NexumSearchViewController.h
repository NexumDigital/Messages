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

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableDictionary *visibleCells;

@property (strong, nonatomic) NSMutableArray *profiles;
@property (strong, nonatomic) NSDictionary *selectedProfile;

@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *page;

- (void) loadDataFromPath:(NSString *)path withPage:(NSString *)page andQuery:(NSString *)query;

@end