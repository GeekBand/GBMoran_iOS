//
//  GBMSquareViewController.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 8/9/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMSquareViewController.h"
#import "GBMSquareCell.h"
#import "KxMenu.h"
#define SPAN  MACoordinateSpanMake(0.025, 0.025)
#import "MJRefresh.h"
#import "GBMSquareRequest.h"
#import "GBMUserModel.h"
#import "GBMGlobal.h"

#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]
@interface GBMSquareViewController ()<UITableViewDelegate, UITableViewDataSource, GBMSquareRequestDelegate>
@property (nonatomic, strong) NSArray *scrollArray;
@property (nonatomic ,strong) NSMutableDictionary * userLocationDict;

@property (strong, nonatomic) NSMutableArray *data; // Temp Refresh

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIButton *titleButton;



@end

@implementation GBMSquareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeLocationValue:) name:@"observeLocationValue" object:nil];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleButton setTitle:@"全部" forState:UIControlStateNormal];
    self.titleButton.frame = CGRectMake(0, 0, 200, 35);
    [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleButton setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    self.titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 133, 0, 0);
    self.titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    self.navigationItem.titleView = self.titleButton;
    
    [self requestAllData];
    
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.tableView.header endRefreshing];
            
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.tableView.footer endRefreshing];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)titleButtonClick:(UIButton *)button
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@" 显示全部"
                     image:nil
                    target:self
                    action:@selector(requestAllData)],
      
      [KxMenuItem menuItem:@"附近500米"
                     image:nil
                    target:self
                    action:@selector(request:)],
      [KxMenuItem menuItem:@"附近1000米"
                     image:nil
                    target:self
                    action:@selector(request1000kilometerData)],
      [KxMenuItem menuItem:@"附近1500米"
                     image:nil
                    target:self
                    action:@selector(pulishCircle:)],
      
      ];
    
    
    UIButton *btn = (UIButton *)button;
    CGRect editImageFrame = btn.frame;
    
    UIView *targetSuperview = btn.superview;
    CGRect rect = [targetSuperview convertRect:editImageFrame toView:[[UIApplication sharedApplication] keyWindow]];
    
    [KxMenu showMenuInView:[[UIApplication sharedApplication] keyWindow]
                  fromRect:rect
                 menuItems:menuItems];
    
}

- (void)observeLocationValue:(NSNotification *)noti
{
    self.locationDic = (NSMutableDictionary *)noti.userInfo;
    
}

- (NSMutableArray *)data
{
    if (!_data) {
        self.data = [NSMutableArray array];
    }
    return _data;
}



// 载入网络刷新数据
-(void) loadUpPullData {
    for (int i; i < 5; i ++) {
        [self.data insertObject:MJRandomData atIndex:0];
    }
    
}


-(void) upPullRefresh {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUpPullData];
    }];
    
    [self.tableView.header beginRefreshing];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"squareCell";
    GBMSquareCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[GBMSquareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.squareVC = self;
    NSLog(@"%zd", indexPath.section);
    cell.locationLabel.text = self.dataArr[indexPath.section][@"node"][@"addr"];
    cell.dataArr = self.dataArr[indexPath.section][@"pic"];
    [cell.collectionView reloadData];
    return cell;
}

- (void)toCheckPicture
{
}


- (void)request1000kilometerData
{
    
}

- (void)requestAllData
{
    ;
    
    NSDictionary *paramDic = @{@"user_id":[GBMGlobal shareGloabl].user.userId, @"token":[GBMGlobal shareGloabl].user.token, @"longitude":@"121.47794", @"latitude":@"31.22516", @"distance":@"1000"};
    
    GBMSquareRequest *squareRequest = [[GBMSquareRequest alloc] init];
    [squareRequest sendSquareRequestWithParameter:paramDic delegate:self];
}

- (void)squareRequestSuccess:(GBMSquareRequest *)request squareModel:(GBMSquareModel *)squareModel
{
    
}
- (void)squareRequestFailed:(GBMSquareRequest *)request error:(NSError *)error
{
    
}

@end
