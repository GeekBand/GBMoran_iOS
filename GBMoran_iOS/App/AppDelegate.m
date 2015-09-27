//
//  AppDelegate.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 9/21/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "AppDelegate.h"
#import "GBMLoginViewController.h"
#import "GBMSquareViewController.h"
#import "GBMMyViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)loadLoginView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GBMLoginAndRegister" bundle:[NSBundle mainBundle]];
    self.loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
    self.window.rootViewController = self.loginViewController;
}

- (void)loadMainView
{
    UIStoryboard *squareStoryboard = [UIStoryboard storyboardWithName:@"GBMSquare" bundle:[NSBundle mainBundle]];
    GBMSquareViewController *squareVC = [squareStoryboard instantiateViewControllerWithIdentifier:@"SquareStoryboard"];
    squareVC.tabBarItem.title = @"广场";
    squareVC.tabBarItem.image = [UIImage imageNamed:@"square"];
    
    UIStoryboard *myStoryboard
    = [UIStoryboard storyboardWithName:@"GBMMy" bundle:[NSBundle mainBundle]];
    GBMMyViewController *myVC = [myStoryboard instantiateViewControllerWithIdentifier:@"MyStoryboard"];
    myVC.tabBarItem.title = @"我的";
    myVC.tabBarItem.image = [UIImage imageNamed:@"my"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[squareVC, myVC];
    
    self.window.rootViewController = tabBarController;
    
    // 添加切换页面的动画效果
    [self.window addSubview:self.loginViewController.view];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loginViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         self.loginViewController = nil;
                     }];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self loadLoginView];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
