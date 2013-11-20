//
//  NexumProfileCell.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumProfileCell : UITableViewCell

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) NSString *expectedIdentifier;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *fullname;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) NSData *pictureData;
@property (strong, nonatomic) UIImage *pictureImage;

- (void) reuseCellWithProfile: (NSDictionary *) profile andQueue: (dispatch_queue_t) queue;
- (void) pictureImageReady;

@end