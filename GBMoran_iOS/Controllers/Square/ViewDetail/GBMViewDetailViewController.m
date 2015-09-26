//
//  GBMViewDetailViewController.m
//  GBMoran_iOS
//
//  Created by ZHY on 15/9/26.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMViewDetailViewController.h"

@interface GBMViewDetailViewController ()

@end

@implementation GBMViewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.navigationController.navigationBar.backgroundColor = [[UIColor alloc]initWithRed:230/255.0 green:106/255.0 blue:58/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc]initWithRed:230/255.0 green:106/255.0 blue:58/255.0 alpha:1];
    [self.navigationController.navigationBar setAlpha:1.0];}

@end
