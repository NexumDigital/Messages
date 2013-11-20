//
//  NexumTabBarViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumTabBarViewController.h"

@interface NexumTabBarViewController ()

@end

@implementation NexumTabBarViewController

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(nil != [NexumDefaults currentSession]){
        NSString *params = [NSString stringWithFormat:@"id_session=%@&uiid=%@",
                            [NexumDefaults currentSession],
                            [[[[UIDevice alloc] init] identifierForVendor] UUIDString]
                            ];
        
        [NexumBackend apiRequest:@"POST" forPath:@"sessions" withParams:params andBlock:^(BOOL success, NSDictionary *data) {
            if(success){
                [NexumDefaults addAccount:data[@"account_data"]];
            } else {
                [NexumDefaults addSession:nil];
            }
        }];
    }
    
    if(nil == [NexumDefaults currentSession])
        [self performSegueWithIdentifier: @"showLogin" sender:self];
}

@end
