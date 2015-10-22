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

#import "GBMPictureModel.h"
#import "GBMSquareModel.h"
#import "GBMViewDetailViewController.h"
#import "UIImageView+WebCache.h"
#define VCFromSB(SB,ID) [[UIStoryboard storyboardWithName:SB bundle:nil] instantiateViewControllerWithIdentifier:ID]
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]
@interface GBMSquareViewController ()<UITableViewDelegate, UITableViewDataSource, GBMSquareRequestDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) NSArray *scrollArray;
@property (nonatomic ,strong) NSMutableDictionary * userLocationDict;

@property (strong, nonatomic) NSMutableArray *data; // Temp Refresh

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIButton *titleButton;




@property (nonatomic, strong) NSMutableArray *addrArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;

@property(nonatomic , strong) CLLocationManager *locationManager;


@end

@implementation GBMSquareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationDic = [NSMutableDictionary dictionary];
    
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次
    // Do any additional setup after loading the view, typically from a nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationManager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
    

    
    //NavigationBar的设置
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleButton setTitle:@"全部" forState:UIControlStateNormal];
    self.titleButton.frame = CGRectMake(0, 0, 200, 35);
    [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleButton setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    self.titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 133, 0, 0);
    self.titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    self.navigationItem.titleView = self.titleButton;
    
    [self requestAllData];
    //头刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            
        });
    }];
    
    self.tableView.header.automaticallyChangeAlpha = YES;
     //尾刷新
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    self.locationDic = [NSMutableDictionary dictionary];
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    NSString *latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    //    NSNumber *latitude = [NSNumber numberWithFloat:newLocation.coordinate.latitude];
    //    NSNumber *longitude = [NSNumber numberWithFloat:newLocation.coordinate.latitude];
    [self.locationDic setValue:latitude forKey:@"latitude"];
    [self.locationDic setValue:longitude forKey:@"longitude"];
    CLLocationDegrees latitude2 = newLocation.coordinate.latitude;
    CLLocationDegrees longitude2 = newLocation.coordinate.longitude;
    
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:c
     //反向地理编码
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     if (!error && [placemarks count] > 0)
                     {
                         NSDictionary *dict =
                         [[placemarks objectAtIndex:0] addressDictionary]; NSLog(@"street address: %@",[dict objectForKey :@"Street"]);
                         [self.locationDic setValue:dict[@"Name"] forKey:@"location"];
                    
                     }
                     else
                     {
                         NSLog(@"ERROR: %@", error); }
                 }];
   
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
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
                    action:@selector(request500kilometerData)],
      [KxMenuItem menuItem:@"附近1000米"
                     image:nil
                    target:self
                    action:@selector(request1000kilometerData)],
      [KxMenuItem menuItem:@"附近1500米"
                     image:nil
                    target:self
                    action:@selector(request1000kilometerData)],
      
      ];
    
    
    UIButton *btn = (UIButton *)button;
    CGRect editImageFrame = btn.frame;
    
    UIView *targetSuperview = btn.superview;
    CGRect rect = [targetSuperview convertRect:editImageFrame toView:[[UIApplication sharedApplication] keyWindow]];
    
    [KxMenu showMenuInView:[[UIApplication sharedApplication] keyWindow]
                  fromRect:rect
                 menuItems:menuItems];
    
}

//- (void)observeLocationValue:(NSNotification *)noti
//{
//    self.locationDic = (NSMutableDictionary *)noti.userInfo;
//    
//}

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



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    NSLog(@"numberOfSectionsInTabelView: %zd", self.addrArray.count);
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"addrArray: %zd", self.addrArray.count);
    return self.addrArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *str = @"squareCell";
    GBMSquareCell * cell = [tableView dequeueReusableCellWithIdentifier:@"squareCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[GBMSquareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"squareCell"];
    }
    
    GBMSquareModel *squareModel = self.addrArray[indexPath.row][0];
    cell.squareVC = self;
//    NSLog(@"%zd", indexPath.section);
    cell.locationLabel.text = squareModel.addr;
    cell.dataArr = self.dataDic[self.addrArray[indexPath.row]];
    [cell.collectionView reloadData];
    return cell;
}

- (void)toCheckPicture
{
    GBMViewDetailViewController *detailVC = VCFromSB(@"GBMViewDetail", @"detailVC");
    [detailVC.PhotoImage sd_setImageWithURL:[NSURL URLWithString:_pic_url]];
    detailVC.pic_id=_pic_id;
    detailVC.pic_url = _pic_url;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void)request1000kilometerData
{
    NSDictionary *paramDic = @{@"user_id":[GBMGlobal shareGloabl].user.userId, @"token":[GBMGlobal shareGloabl].user.token, @"longitude":[self.locationDic valueForKey:@"longitude"], @"latitude":[self.locationDic valueForKey:@"latitude"], @"distance":@"1000"};
    
    GBMSquareRequest *squareRequest = [[GBMSquareRequest alloc] init];
    [squareRequest sendSquareRequestWithParameter:paramDic delegate:self];
    
}

- (void)requestAllData
{
    NSDictionary *paramDic = @{@"user_id":[GBMGlobal shareGloabl].user.userId, @"token":[GBMGlobal shareGloabl].user.token, @"longitude":@"121.47794", @"latitude":@"31.22516", @"distance":@"1000"};
    
    GBMSquareRequest *squareRequest = [[GBMSquareRequest alloc] init];
    [squareRequest sendSquareRequestWithParameter:paramDic delegate:self];
}

- (void)squareRequestSuccess:(GBMSquareRequest *)request dictionary:(NSDictionary *)dictionary
{
//    NSLog(@"%@", dictionary);
    self.addrArray = [NSMutableArray arrayWithArray:[dictionary allKeys]];
//    self.pictureArray = [NSMutableArray arrayWithArray:dictionary[@"pic"]];
    self.dataDic = dictionary;
    [self.tableView reloadData];
    
}
- (void)squareRequestFailed:(GBMSquareRequest *)request error:(NSError *)error
{
    
}

@end
