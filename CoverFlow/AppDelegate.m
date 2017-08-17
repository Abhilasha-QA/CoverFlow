//
//  AppDelegate.m
//  CoverFlow
//
//  Created by Mindinventory on 6/12/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "AppDelegate.h"
#import "MIViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MIViewController *VC = [[MIViewController alloc]initWithNibName:@"MIViewController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:VC];
    
    [self.window makeKeyAndVisible];

    return YES;
}




@end
