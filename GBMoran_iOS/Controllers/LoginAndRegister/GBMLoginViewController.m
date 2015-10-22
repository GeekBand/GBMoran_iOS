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
#import "GBMGetImage.h"
@interface GBMLoginViewController () <GBMLoginRequestDelegate,UIAlertViewDelegate>
{
    BOOL openOrNot;
    BOOL keyboardOpen;
    CGFloat keyboardOffSet;
    UIActivityIndicatorView *activity;
    NSString *myEmail;
    NSString *myPassword;
}
@property (nonatomic, strong) GBMLoginRequest *loginRequest;
@property (nonatomic, strong) UITextField *textView;


@end

@implementation GBMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readInformation];
    activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    CGFloat width =self.view.frame.size.width/2;
    [activity setCenter:CGPointMake(width , 160) ];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:activity];
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 设置登录按钮为圆角矩形
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.clipsToBounds = YES;
    
    // 设置输入框的代理
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

// 读取本地化的数据
-(void)readInformation{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    myEmail = [defaults stringForKey:@"email"];
    myPassword = [defaults stringForKey:@"password"];
    
    if (myEmail){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"是否使用本地邮箱密码"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
        
    [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.emailTextField.text = myEmail;
        self.passwordTextField.text = myPassword;
    }
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
        if ([activity isAnimating]) {
            [activity stopAnimating];
        }
        [activity startAnimating];
        
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
//    // 键盘收回后，视图恢复到原始位置
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
    return YES;
}

// 通过键盘弹出时，适当上移视图，避免键盘遮挡输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    self.textView = textField;
    
}

#pragma mark - GBMLoginRequestDelegate methods
- (void)loginRequestSuccess:(GBMLoginRequest *)request user:(GBMUserModel *)user
{
    if ([user.loginReturnMessage isEqualToString:@"Login success"]) {
//        NSLog(@"登录成功，现在转换页面");
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate loadMainViewWithController:self];
        [GBMGlobal shareGloabl].user = user;

       


        [GBMGlobal shareGloabl].user.email= self.emailTextField.text;
        GBMGetImage *getimage=[[GBMGetImage alloc]init];
        [getimage sendGetImageRequest];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.emailTextField.text forKey:@"email"];
        [defaults setObject:self.passwordTextField.text forKey:@"password"];
        [defaults synchronize];
        
        

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:user.loginReturnMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"服务器报错:%@", user.loginReturnMessage);
    }
     [activity stopAnimating];
}

- (void)loginRequestFailed:(GBMLoginRequest *)request error:(NSError *)error
{
    NSLog(@"登录错误原因:%@", error);
    [activity stopAnimating];
}

#pragma mark ---弹出键盘时适应
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (keyboardOpen == NO) {
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
        CGFloat keyboardHeight = endKeyboardRect.origin.y;
        CGRect textViewRect  = self.textView.frame;
        CGFloat textViewHeight = textViewRect.origin.y+textViewRect.size.height;
        keyboardOffSet = textViewHeight - keyboardHeight;
        CGFloat newy = textViewRect.origin.y - keyboardOffSet;
        if (textViewHeight > keyboardHeight) {
            [UIView animateWithDuration:duration animations:^{
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-keyboardOffSet, self.view.frame.size.width, self.view.frame.size.height)];
            }];
            [self.textView setFrame:CGRectMake(textViewRect.origin.x, newy, textViewRect.size.width, textViewRect.size.height)];
            keyboardOpen = YES;
        }
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    if (keyboardOpen == YES) {
        [UIView animateWithDuration:1 animations:^{
             [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+keyboardOffSet, self.view.frame.size.width, self.view.frame.size.height)];
        }];
        keyboardOpen = NO;
    }
}



@end
