//
//  MRLoginViewController.m
//  MoRan
//
//  Created by yikobe_mac on 15/9/20.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import "GBMLoginViewController.h"
#import "GBMUserModel.h"
#import "AppDelegate.h"
#import "GBMGlobal.h"
#import "GBMPublishViewController.h"
@interface GBMLoginViewController () <GBMLoginRequestDelegate>

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
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 点击登录按钮后的相关方法

- (IBAction)loginButtonClicked:(id)sender
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // 验证邮箱和密码是否都有输入内容，且检查邮箱格式是否正确
    if (([email length] == 0) ||
        ([password length] == 0)) {
        [self showErrorMessage:@"邮箱和密码不能为空"];
    } else {
        [self loginHandle];
    }
}

// 核对用户的登录信息
- (void)loginHandle
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *gbid = @"GeekBand-I150001";
    
    
    self.loginRequest = [[GBMLoginRequest alloc] init];
    [self.loginRequest sendLoginRequestWithEmail:email
                                        password:password
                                            gbid:gbid
                                        delegate:self];
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
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    // 键盘收回后，视图恢复到原始位置
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

// 通过代理来让键盘上的return键实现关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    // 键盘收回后，视图恢复到原始位置
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    return YES;
}

// 通过键盘弹出时，适当上移视图，避免键盘遮挡输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.loginButton.frame;
    int offset = frame.origin.y + 36 - (self.view.frame.size.height - 216); // 键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    // 将视图的Y坐标向上移Y个单位，为键盘腾出空间
    if (offset > 0) {
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}

#pragma mark - GBMLoginRequestDelegate methods
- (void)loginRequestSuccess:(GBMLoginRequest *)request user:(GBMUserModel *)user
{
    if ([user.loginReturnMessage isEqualToString:@"Login success"]) {
        NSLog(@"登录成功，现在转换页面");
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate loadMainViewWithController:self];
         
        [GBMGlobal shareGloabl].user = user;
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"GBMPublish" bundle:nil];
//        GBMPublishViewController *pulish =  [story instantiateViewControllerWithIdentifier:@"CMJ"];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pulish];
//        [self presentViewController:nav animated:YES completion:nil];
    } else {
        NSLog(@"服务器报错:%@", user.loginReturnMessage);
    }
}

- (void)loginRequestFailed:(GBMLoginRequest *)request error:(NSError *)error
{
    NSLog(@"登录错误原因:%@", error);
}




@end
