//
//  GBMMyViewController.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 9/21/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMMyViewController.h"
#import "GBMNickNameViewController.h"

@interface GBMMyViewController ()

@end

@implementation GBMMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 给navigation bar 设置背景色，颜色选择和蓦然登录注明界面的button颜色一致
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:237 / 255.0f green:127 / 255.0f blue:74 /255.0f alpha:1.0f];
    
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
        if (indexPath.row == 1) {
            //            <#statements#>
        }
    }
}

#pragma mark - Storyboard segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settingNickName"]) {
        GBMNickNameViewController *nickNameVC = [[GBMNickNameViewController alloc] init];
        self.nickNameLabel.text = @"易科比";
        nickNameVC.nickNameTextField.text = self.nickNameLabel.text;
    }
}



@end
