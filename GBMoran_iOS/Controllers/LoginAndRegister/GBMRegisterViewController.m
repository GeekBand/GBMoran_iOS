//
//  MRRegisterViewController.m
//  MoRan
//
//  Created by yikobe_mac on 15/9/21.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import "GBMRegisterViewController.h"
#import "GBMSquareViewController.h"

@interface GBMRegisterViewController () <GBMRegisterRequestDelegate>
{
    BOOL openOrNot;
    BOOL keyboardOpen;
    CGFloat keyboardOffSet;
    UIActivityIndicatorView *activity;
}

@property (nonatomic, strong) GBMRegisterRequest *registerRequest;
@property (nonatomic, strong) UITextField *textView;

@end

@implementation GBMRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    CGFloat width =self.view.frame.size.width/2;
    [activity setCenter:CGPointMake(width , 160) ];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:activity];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
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
    
    // 键盘收回后，视图恢复到原始位置
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
}

// 通过键盘弹出时，适当上移视图，避免键盘遮挡输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textView = textField;
    
}

#pragma mark - 点击登录按钮后的相关方法

- (IBAction)loginButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击注册按钮后的相关方法

- (IBAction)registerButtonClicked:(id)sender
{
    NSString *username = self.userNameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *repeatPassword = self.repeatPasswordTextField.text;
    
    // 验证邮箱和密码是否都有输入内容，且检查邮箱格式是否正确
    if (([username length] == 0) ||
        ([email length] == 0) ||
        ([password length] == 0) ||
        ([repeatPassword length] == 0)){
        [self showErrorMessage:@"用户名、邮箱和密码不能为空"];
    } else if (![self isValidateEmail:email]) {
        [self showErrorMessage:@"您输入的邮箱格式有误，请重试"];
    } else if (![password isEqualToString:repeatPassword]){
        [self showErrorMessage:@"您两次输入的密码不一致，请重试"];
    } else if (![self isValidatePassword:password]) {
        [self showErrorMessage:@"密码格式有误，应为6~20位的字母或数字"];
    } else {
        [self registerHandle];
        if ([activity isAnimating]) {
            [activity stopAnimating];
        }
        [activity startAnimating];
    }
}

// 利用正则表达式验证用户输入的邮箱是否合法
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 利用正则表达式验证用户输入的密码是否符合要求
// 密码为6~20位的字母或数字
- (BOOL) isValidatePassword:(NSString *)password
{
    NSString *passwordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordPredicate evaluateWithObject:password];
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
    NSString *username = self.userNameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *gbid = @"GeekBand-I150001";
    
    self.registerRequest = [[GBMRegisterRequest alloc] init];
    [self.registerRequest sendRegisterRequestWithUserName:username
                                                    email:email
                                                 password:password
                                                     gbid:gbid
                                                 delegate:self];
}

#pragma mark - GBMRegisterRequestDelegate methods

- (void)registerRequestSuccess:(GBMRegisterRequest *)request user:(GBMUserModel *)user
{
    if ([user.registerReturnMessage isEqualToString:@"Register success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"注册成功，请登录"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        [activity stopAnimating];
    }
}

- (void)registerRequestFailed:(GBMRegisterRequest *)request error:(NSError *)error
{
    NSLog(@"注册错误原因:%@", error);
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
        if (textViewHeight > keyboardHeight) {
            [UIView animateWithDuration:duration animations:^{
//                [self.textView setFrame:CGRectMake(textViewRect.origin.x, newy, textViewRect.size.width, textViewRect.size.height)];
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-keyboardOffSet, self.view.frame.size.width, self.view.frame.size.height)];
            }];
//            [self.textView setFrame:CGRectMake(textViewRect.origin.x, newy, textViewRect.size.width, textViewRect.size.height)];
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
