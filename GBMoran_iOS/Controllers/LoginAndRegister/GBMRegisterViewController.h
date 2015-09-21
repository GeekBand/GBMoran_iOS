//
//  MRRegisterViewController.h
//  MoRan
//
//  Created by yikobe_mac on 15/9/21.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMRegisterRequest.h"

@interface GBMRegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)touchDownAction:(id)sender;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;

@end
