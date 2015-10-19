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
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "GBMPictureModel.h"
#import "GBMSquareModel.h"
#import "GBMViewDetailViewController.h"
#import "UIImageView+WebCache.h"
#define VCFromSB(SB,ID) [[UIStoryboard storyboardWithName:SB bundle:nil] instantiateViewControllerWithIdentifier:ID]
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]
@interface GBMSquareViewController ()<UITableViewDelegate, UITableViewDataSource, GBMSquareRequestDelegate, AMapSearchDelegate, MAMapViewDelegate>
@property (nonatomic, strong) NSArray *scrollArray;
@property (nonatomic ,strong) NSMutableDictionary * userLocationDict;

@property (strong, nonatomic) NSMutableArray *data; // Temp Refresh

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *mapSearchAPI;
@property (nonatomic, strong) MAUserLocation *currentLocation;


@property (nonatomic, strong) NSMutableArray *addrArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;


@end

@implementation GBMSquareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationDic = [NSMutableDictionary dictionary];
    
    [MAMapServices sharedServices].apiKey = @"69b035e62c17ae7f98898392e2b17376";
    [AMapSearchServices sharedServices].apiKey = @"69b035e62c17ae7f98898392e2b17376";
    self.mapView = [[MAMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapSearchAPI = [[AMapSearchAPI alloc] init];
    self.mapSearchAPI.delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeLocationValue:) name:@"observeLocationValue" object:nil];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleButton setTitle:@"全部" forState:UIControlStateNormal];
    self.titleButton.frame = CGRectMake(0, 0, 200, 35);
    [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleButton setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    self.titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 133, 0, 0);
    self.titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    self.navigationItem.titleView = self.titleButton;
    
    [self requestAllData];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            
        });
    }];
    
    self.tableView.header.automaticallyChangeAlpha = YES;
    
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


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation == YES)
    {
            }
    
    [self.locationDic setObject:[NSNumber numberWithFloat:userLocation.location.coordinate.longitude] forKey:@"longitude"];
    [self.locationDic setObject:[NSNumber numberWithFloat:userLocation.location.coordinate.latitude] forKey:@"latitude"];
    
    self.currentLocation = userLocation;
    [self.mapView setRegion:MACoordinateRegionMake(self.currentLocation.coordinate, SPAN) animated:YES];
    
    CLLocation * location = userLocation.location;
    
    AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc] init];
    request.requireExtension = YES;
    request.radius = 10000;
    AMapGeoPoint * point = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    request.location = point;
    [self.mapSearchAPI AMapReGoecodeSearch:request];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
//                NSLog(@"ReGeo: %@", result);
        
        [self.locationDic setObject:result forKey:@"location"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"observeLocationValue" object:nil userInfo:self.locationDic];
    }
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
    static NSString *str = @"squareCell";
    GBMSquareCell * cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    if (!cell) {
        cell = [[GBMSquareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
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
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void)request1000kilometerData
{
   
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
