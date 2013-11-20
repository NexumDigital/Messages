//
//  NexumThreadViewController.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/16/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NexumInputBar.h"
#import "NexumThreadTable.h"
#import "NexumMessageCell.h"

@interface NexumThreadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *thread;

@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) NSDictionary *profile;


@property (strong, nonatomic) dispatch_queue_t imagesQueue;
@property (assign, nonatomic) BOOL animatingRotation;
@property (assign, nonatomic) CGRect keyboardFrame;


@property (weak, nonatomic) IBOutlet NexumInputBar *inputBar;
@property (weak, nonatomic) IBOutlet NexumThreadTable *tableView;

-(void) scrollToBottom;

@end