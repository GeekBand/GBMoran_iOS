//
//  MRLoginViewController.m
//  MoRan
//
//  Created by yikobe_mac on 15/9/20.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import "GBMLoginViewController.h"

@interface GBMLoginViewController ()

@end

@implementation GBMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 点击登录按钮后的相关方法

- (IBAction)loginButtonClicked:(id)sender
{
    [self loginHandle];
}

// 核对用户的登录信息
- (void)loginHandle
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // 验证邮箱和密码是否都有输入内容，且检查邮箱格式是否正确
    if (([email length] == 0) ||
        ([password length] == 0)) {
        [self showErrorMessage:@"邮箱和密码不能为空"];
    }
}

// 创建一个弹出UIAlertView的方法，用来提示用户
- (void)showErrorMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - 处理键盘事件

- (IBAction)touchDownAction:(id)sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}



@end
