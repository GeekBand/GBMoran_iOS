//
//  MRRegisterViewController.m
//  MoRan
//
//  Created by yikobe_mac on 15/9/21.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import "GBMRegisterViewController.h"

@interface GBMRegisterViewController ()

@property (nonatomic, strong) GBMRegisterRequest *registerRequest;

@end

@implementation GBMRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 把注册按钮设为圆角矩形
    self.registerButton.layer.cornerRadius = 5.0;
    self.registerButton.clipsToBounds = YES;
    
    // 为输入框添加代理
    self.userNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.repeatPasswordTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 处理键盘事件

// 通过代理来让键盘上的return键实现关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 通过把整个视图UIView改成UIControl，可以响应屏幕上任意区域的点击，会调用此方法，都可以关闭键盘
- (IBAction)touchDownAction:(id)sender
{
    [self.userNameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.repeatPasswordTextField resignFirstResponder];
}

#pragma mark - 点击登录按钮后的相关方法

- (IBAction)loginButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击注册按钮后的相关方法

- (IBAction)registerButtonClicked:(id)sender
{
    NSString *userName = self.userNameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *repeatPassword = self.repeatPasswordTextField.text;
    
    // 验证邮箱和密码是否都有输入内容，且检查邮箱格式是否正确
    if (([userName length] == 0) ||
        ([email length] == 0) ||
        ([password length] == 0) ||
        ([repeatPassword length] == 0)){
        [self showErrorMessage:@"用户名、邮箱和密码不能为空"];
    } else if (![self isValidateEmail:email]) {
        [self showErrorMessage:@"您输入的邮箱格式有误，请重试"];
    } else if (![password isEqualToString:repeatPassword]){
        [self showErrorMessage:@"您两次输入的密码不一致，请重试"];
    } else {
        [self registerHandle];
    }
}

// 利用正则表达式验证用户输入的邮箱是否合法
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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

- (void)registerHandle
{
    NSString *userName = self.userNameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *gbid = @"GeekBand-I150001";
    
    self.registerRequest = [[GBMRegisterRequest alloc] init];
    [self.registerRequest sendRegisterRequestWithUserName:userName
                                                    email:email password:password
                                                     gbid:gbid];
}



@end
