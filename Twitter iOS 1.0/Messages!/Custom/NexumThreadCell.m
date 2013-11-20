//
//  NexumThreadCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadCell.h"

@implementation NexumThreadCell

- (void) reuseCellWithThread: (NSDictionary *) thread andQueue:(dispatch_queue_t)queue {
    BOOL opened = [thread[@"opened"] boolValue];
    NSString *threadIdentifier = thread[@"identifier"];
    
    if(opened){
        self.indicator.backgroundColor = [UIColor C_ededea];
    } else {
        self.indicator.backgroundColor = [UIColor C_4fdd86];
    }
    
    self.title.text = thread[@"title"];
    self.preview.text = thread[@"preview"];
    self.timeago.text = thread[@"timeago"];
    
    if(![self.expectedIdentifier isEqualToString:self.identifier]){
        self.picture.image = [UIImage imageWithContentsOfFile:@""];
        
        dispatch_async(queue, ^{
            if([self.expectedIdentifier isEqualToString:threadIdentifier]){
                self.pictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thread[@"picture"]]];
            }
            
            if([self.expectedIdentifier isEqualToString:threadIdentifier]){
                self.pictureImage = [UIImage imageWithData:self.pictureData];
                self.pictureImage = [NexumUtil imageWithRoundedCornersSize:36.0 usingImage:self.pictureImage];
                
            }
            
            if([self.expectedIdentifier isEqualToString:threadIdentifier]){
                self.identifier = threadIdentifier;
                [self performSelectorOnMainThread:@selector(pictureImageReady) withObject:nil waitUntilDone:NO];
            }
        });
    }
}

- (void) pictureImageReady {
    self.picture.image = self.pictureImage;
    [self setNeedsLayout];
}

@end
