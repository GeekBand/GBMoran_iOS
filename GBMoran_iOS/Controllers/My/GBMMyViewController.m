//
//  GBMMyViewController.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 9/21/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMMyViewController.h"
#import "AppDelegate.h"
#import "GBMGlobal.h"
@interface GBMMyViewController ()

@end

@implementation GBMMyViewController
- (void)viewDidAppear:(BOOL)animated{
    self.nickNameLabel.text=[GBMGlobal shareGloabl].user.username;
    self.headImageView.image=[GBMGlobal shareGloabl].user.image;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 给navigation bar 设置背景色，颜色选择和蓦然登录注明界面的button颜色一致
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:237 / 255.0f green:127 / 255.0f blue:74 /255.0f alpha:1.0f];
    self.emailLabel.text=[GBMGlobal shareGloabl].user.email;
    
    
    // 把头像显示成圆形
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2.0f;
    self.headImageView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Data Source methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat header;
    if (section == 0) {
        header = 13.0;
    } else if (section == 1) {
        header = 10;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - TableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定注销吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self dismissViewControllerAnimated:YES completion:nil];
                [GBMGlobal shareGloabl].user=nil;
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate loadLoginView];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:enterAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:true completion:nil];

        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - Storyboard segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settingNickName"]) {
        GBMNickNameViewController *nickNameVC = segue.destinationViewController;
        nickNameVC.nickName = self.nickNameLabel.text;
    } else if ([segue.identifier isEqualToString:@"settingHeadImage"]) {
        GBMHeadImageViewController *headImageVC = segue.destinationViewController;
        headImageVC.headImage = self.headImageView.image;
    }
}






@end
