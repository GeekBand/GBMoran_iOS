//
//  MRLoginViewController.h
//  MoRan
//
//  Created by yikobe_mac on 15/9/20.
//  Copyright © 2015年 yikobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBMLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)touchDownAction:(id)sender;

@end
