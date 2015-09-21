//
//  MRLoginViewController.h
//  MoRan
//
//  Created by yikobe_mac on 15/9/20.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMLoginRequest.h"

@interface GBMLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)touchDownAction:(id)sender;

@end
