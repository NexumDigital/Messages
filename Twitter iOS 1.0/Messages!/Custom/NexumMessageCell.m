//
//  NexumMessageCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumMessageCell.h"

@implementation NexumMessageCell

- (void) reuseCell:(BOOL)isPortrait withMessage: (NSDictionary *)message andQueue:(dispatch_queue_t)queue {
    BOOL sent = [message[@"sent"] boolValue];
    
    self.backgroundColor = [UIColor clearColor];
    
    int screenWidth;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if(isPortrait){
        screenWidth = screenRect.size.width;
    } else {
        screenWidth = screenRect.size.height;
    }
    
    if(nil == self.messageView){
        self.messageView = [[UITextView alloc] init];
        self.messageView.editable = NO;
        self.messageView.scrollEnabled = NO;
        self.messageView.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.messageView];
    }
    
    self.messageView.text = message[@"text"];
    if(sent) {
        self.messageView.backgroundColor = [UIColor C_45d5ff];
    } else {
        self.messageView.backgroundColor = [UIColor whiteColor];
    }
    self.messageView.layer.cornerRadius = 15;
    
    CGRect messageFrame = self.messageView.frame;
    CGSize messageSize = [self.messageView sizeThatFits:CGSizeMake((screenWidth - 100), FLT_MAX)];
    messageFrame.origin.y = 5;
    messageFrame.origin.x = 50;
    messageFrame.size.width = (screenWidth - 100);
    messageFrame.size.height = messageSize.height;
    self.messageView.frame = messageFrame;
}

@end
