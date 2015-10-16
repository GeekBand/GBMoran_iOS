//
//  GBMNickNameViewController.m
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMNickNameViewController.h"
#import "GBMMyViewController.h"
@interface GBMNickNameViewController () <GBMReNameRequestDelegate>


@end

@implementation GBMNickNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.nickNameTextField.text =  self.nickName;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:237 / 255.0f green:127 / 255.0f blue:74 / 255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)doneBarButtonClicked:(id)sender
{
    
    GBMReNameRequest *reNameRequest=[[GBMReNameRequest alloc]init];
    [reNameRequest sendReNameRequestWithName:self.nickNameTextField.text delegate:self];
    
    
}

-(void) renameRequestSuccess:(GBMReNameRequest *)request{
    [GBMGlobal shareGloabl].user.username=self.nickNameTextField.text;
      [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)renameRequestfail:(GBMReNameRequest *)request error:(NSError *)error{
    [self.navigationController popViewControllerAnimated:YES];
}

@end


