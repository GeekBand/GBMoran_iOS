//
//  AppDelegate.h
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 9/21/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIViewController *loginViewController;

- (void)loadLoginView;
- (void)loadMainViewWithController:(UIViewController *)controller;


@end

