//
//  NexumThreadCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadCell.h"

@implementation NexumThreadCell

- (void) reuseCellWithThread: (NSDictionary *) thread {
    
    BOOL opened = [thread[@"opened"] boolValue];
    
    if(opened){
        self.indicator.backgroundColor = [UIColor C_ededea];
    } else {
        self.indicator.backgroundColor = [UIColor C_4fdd86];
    }
    
    self.title.text = thread[@"title"];
    self.preview.text = [NSString stringWithFormat:@"%@\n\n", thread[@"preview"]];
    self.timeago.text = thread[@"timeago"];
    
    NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
    
    profilePicture.identifier = thread[@"identifier"];
    profilePicture.pictureURL = thread[@"picture"];
    
    BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
    if(!exists)
        self.picture.image = [UIImage imageNamed:@"placeholder"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if(!exists)
            usleep(500000);
        if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.picture.image = image;
                    });
                }
            }];
        }
    });
}

@end
