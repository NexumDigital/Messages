//
//  NexumMessageCell.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumMessageCell : UITableViewCell

@property (strong, nonatomic) UITextView *messageView;

- (void) reuseCell:(BOOL)isPortrait withMessage: (NSDictionary *)message andQueue:(dispatch_queue_t)queue;

@end
