//
//  NexumProfileViewController.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/14/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumProfileViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *mainPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *infoPlaceholder;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIToolbar *actionToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;



@property (strong, nonatomic) NSDictionary *profile;

@end
