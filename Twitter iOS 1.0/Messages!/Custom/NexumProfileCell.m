//
//  NexumProfileCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumProfileCell.h"

@implementation NexumProfileCell

- (void) reuseCellWithProfile: (NSDictionary *) profile andQueue: (dispatch_queue_t) queue {
    NSString *profileIdentifier = [NSString stringWithFormat:@"%@", profile[@"identifier"]];
    BOOL follower = [profile[@"follower"] boolValue];
    BOOL following = [profile[@"following"] boolValue];
    
    self.fullname.text = profile[@"fullname"];
    self.username.text = [NSString stringWithFormat:@"@%@", profile[@"username"]];
    if(follower){
        [self.button setBackgroundImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"chat_tap"] forState:UIControlStateHighlighted];
    } else {
        if(following){
            [self.button setBackgroundImage:[UIImage imageNamed:@"request"] forState:UIControlStateNormal];
            [self.button setBackgroundImage:[UIImage imageNamed:@"request_tap"] forState:UIControlStateHighlighted];
        } else {
            [self.button setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            [self.button setBackgroundImage:[UIImage imageNamed:@"follow_tap"] forState:UIControlStateHighlighted];
        }
    }
    
    if(![self.expectedIdentifier isEqualToString:self.identifier]){
        self.picture.image = [UIImage imageWithContentsOfFile:@""];
        
        dispatch_async(queue, ^{
            if([self.expectedIdentifier isEqualToString:profileIdentifier]){
                self.pictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profile[@"picture"]]];
            }
            
            if([self.expectedIdentifier isEqualToString:profileIdentifier]){
                self.pictureImage = [UIImage imageWithData:self.pictureData];
                self.pictureImage = [NexumUtil imageWithRoundedCornersSize:36.0 usingImage:self.pictureImage];
                
            }
            
            if([self.expectedIdentifier isEqualToString:profileIdentifier]){
                self.identifier = profileIdentifier;
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
