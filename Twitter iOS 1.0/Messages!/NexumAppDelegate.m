//
//  NDIAppDelegate.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/11/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumAppDelegate.h"

@implementation NexumAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor C_f8f8f8];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor C_1ab4ef_T]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITableView appearance] setBackgroundColor:[UIColor C_f8f8f8]];
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor C_f8f8f8_T];
    [[UITableViewCell appearance] setSelectedBackgroundView:selectionColor];
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor C_f8f8f8_T]];
    [[UITabBar appearance] setTintColor:[UIColor C_74d2f6]];
    
    [Crashlytics startWithAPIKey:@"f3306f5f915daa17558ed40c9672f1d49830f4e2"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)applicationm {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
