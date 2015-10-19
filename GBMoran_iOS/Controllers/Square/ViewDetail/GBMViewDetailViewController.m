//
//  GBMViewDetailViewController.m
//  GBMoran_iOS
//
//  Created by ZHY on 15/10/2.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMViewDetailViewController.h"
#import "GBMGlobal.h"
@interface GBMViewDetailViewController ()<GBMViewDetailRequestDelegate>

@end

@implementation GBMViewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *token= [GBMGlobal shareGloabl].user.token;
     NSString *userId= [GBMGlobal shareGloabl].user.userId;
    NSDictionary *dic=@{@"pic_id":_pic_id,@"token":token,@"user_id":userId};
    GBMViewDetailRequest *request= [[GBMViewDetailRequest alloc]init];
    [request sendViewDetailRequestWithParameter:dic delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDetailRequestSuccess:(GBMViewDetailRequest *)request data:(NSData *)data{
    _PhotoImage.image=[[UIImage alloc]initWithData:data];
}
- (void)viewDetailRequestFailed:(GBMViewDetailRequest *)request error:(NSError *)error{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
