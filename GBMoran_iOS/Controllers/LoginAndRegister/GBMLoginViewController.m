//
//  MRLoginViewController.m
//  MoRan
//
//  Created by yikobe_mac on 15/9/20.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import "GBMLoginViewController.h"
#import "GBMUserModel.h"

@interface GBMLoginViewController ()

@property (nonatomic, strong) GBMLoginRequest *loginRequest;


@end

@implementation GBMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置登录按钮为圆角矩形
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.clipsToBounds = YES;
    
    // 设置输入框的代理
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 点击登录按钮后的相关方法

- (IBAction)loginButtonClicked:(id)sender
{
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // 验证邮箱和密码是否都有输入内容，且检查邮箱格式是否正确
    if (([userName length] == 0) ||
        ([password length] == 0)) {
        [self showErrorMessage:@"邮箱和密码不能为空"];
    } else {
        [self loginHandle];
    }
}

// 核对用户的登录信息
- (void)loginHandle
{
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *gbid = @"GeekBand-I150001";
    
    self.loginRequest = [[GBMLoginRequest alloc] init];
    [self.loginRequest sendLoginRequestWithUserName:userName
                                           password:password
                                               gbid:gbid];
    
    GBMUserModel *user = [[GBMUserModel alloc] init];
    if ([user.loginReturnMessage isEqualToString:@"Login success"]) {
        NSLog(@"登录成功");
        [self showErrorMessage:@"登录成功了吗？"];
    } else {
        NSLog(@"服务器返回值：%@", user.loginReturnMessage);
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

// 通过把整个视图UIView改成UIControl，可以响应屏幕上任意区域的点击，会调用此方法，都可以关闭键盘
- (IBAction)touchDownAction:(id)sender
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

// 通过代理来让键盘上的return键实现关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
