//
//  NexumProfileCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumProfileCell.h"

@implementation NexumProfileCell

- (void) reuseCellWithProfile: (NSDictionary *) profile {
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
    
    NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
    
    profilePicture.identifier = profile[@"identifier"];
    profilePicture.pictureURL = profile[@"picture"];
    
    BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
    if(exists){
        if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    } else {
        self.picture.image = [UIImage imageNamed:@"placeholder"];
    }
}

- (void) loadImagesWithProfile: (NSDictionary *) profile{
    if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
        NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
        
        profilePicture.identifier = profile[@"identifier"];
        profilePicture.pictureURL = profile[@"picture"];
        
        [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
                self.picture.image = image;
            }
        }];
    }
}

@end
