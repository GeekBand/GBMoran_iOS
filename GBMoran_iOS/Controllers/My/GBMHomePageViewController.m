//
//  GBMHomePageViewController.m
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/28.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMHomePageViewController.h"

@interface GBMHomePageViewController ()

@end

@implementation GBMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showHomePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showHomePage
{
    NSString *urlString = @"http://geekband.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
