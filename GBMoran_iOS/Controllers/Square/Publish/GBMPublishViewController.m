//
//  CMJPublishViewController.m
//  蓦然
//
//  Created by 陈铭嘉 on 15/9/21.
//  Copyright © 2015年 com.GeekBand. All rights reserved.
//

#import "GBMPublishViewController.h"
#import "GBMPublishCell.h"
#import "GBMPublishRequest.h"
#import "GBMGlobal.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "GBMLocationParser.h"
#define selfWidth self.view.frame.size.width
#define selfHeight self.view.frame.size.height

@interface GBMPublishViewController ()<CLLocationManagerDelegate>
{
    BOOL openOrNot;
    BOOL locationOrNot;
    BOOL keyboardOpen;
    CGFloat keyboardOffSet;
    UIButton* publishButton;
    UILabel* titleLabel;
    UIActivityIndicatorView *activity;
    GBMLocationModel *locationModel;
    NSDictionary *locationDic;
}

@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIControl *blackView;
@property(nonatomic , strong) CLLocationManager *locationManager;
@property(nonatomic , strong) NSMutableDictionary *dic;

@end

@implementation GBMPublishViewController


-(instancetype)initWithPulishPhoto:(UIImage *)pulishPhoto
{
    self = [super init];
    if (self) {
        _publishPhoto = pulishPhoto;
    }
    return self;
}



- (void)viewDidLoad {
   
    
    
    [self MakeBackButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeLocationValue:) name:@"observeLocationValue" object:nil];
    
    [self getLatitudeAndLongtitude];

    
    activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    CGFloat width =self.view.frame.size.width/2;
    [activity setCenter:CGPointMake(width , 160) ];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:activity];

    
    
    
    self.pulishview.image= self.publishPhoto;
//    [self.view bringSubviewToFront:self.textView];
    keyboardOpen = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [super viewDidLoad];
    [self makePublishButton];
    
    
    self.navigationController.navigationBar.backgroundColor = [[UIColor alloc]initWithRed:230/255.0 green:106/255.0 blue:58/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc]initWithRed:230/255.0 green:106/255.0 blue:58/255.0 alpha:1];
    self.textView.delegate = self;
    [self.navigationController.navigationBar setAlpha:1.0];
   titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 10, 100, 30)];
    titleLabel.text =@"发布照片";
    titleLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    
    // Do any additional setup after loading the view.
}

- (void)observeLocationValue:(NSNotification *)noti
{
    
    locationDic = (NSMutableDictionary *)noti.userInfo;
    [self.locationButton.titleLabel setText:[locationDic valueForKey:@"location"]];
    
}


-(void)getLatitudeAndLongtitude{

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

}


-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg
{
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"06d932a18b74aa1fcf83b46fc537c2e0" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                             
                                   locationOrNot = NO;
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                   message:@"获取地理位置信息失败"
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                                   
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   locationModel = [[GBMLocationModel alloc]init];
                                   GBMLocationParser *parser = [[GBMLocationParser alloc]init];
                                   locationModel = [parser parseJson:data];
                                   
                                   
                                   locationOrNot = YES;
                                    [self makeTableView];
                               }
                           }];
    
}


-(void)dealloc{

    [titleLabel removeFromSuperview];
    [publishButton removeFromSuperview];
    

}

//制作tableview
-(void)makeTableView{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, selfHeight, selfWidth, 230) style:UITableViewStylePlain];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setSeparatorColor:[UIColor blackColor]];
        [self.tableView setShowsHorizontalScrollIndicator:NO];
        [self.tableView setShowsVerticalScrollIndicator:YES];
        [self.tableView registerNib:[UINib nibWithNibName:@"GBMPublishCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"publishCell"];
        [self.view addSubview:self.tableView];
        openOrNot = NO;
    }
    
    if (openOrNot == NO) {
        _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, selfWidth, selfHeight-230)];
        [_blackView addTarget:self action:@selector(blackViewTouchDown) forControlEvents:UIControlEventTouchDown];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0;
        [self.view addSubview:_blackView];
        [UIView animateWithDuration:0.5 animations:^{
            [self.tableView setFrame:CGRectMake(0, selfHeight-230, selfWidth, 230)];
            _blackView.alpha = 0.5;
        }
         ];
        openOrNot = YES;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.tableView setFrame:CGRectMake(0, selfHeight, selfWidth, 230)];
            _blackView.alpha = 0;
        }];
        [_blackView removeFromSuperview];
        openOrNot = NO;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

//制作发布按钮
-(void)makePublishButton{
    publishButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-65, 0, 50, 40)];
    publishButton.backgroundColor = [UIColor whiteColor];
    publishButton.alpha = 0.8;
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    [publishButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishPhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    publishButton.layer.cornerRadius = 3.0;
    publishButton.clipsToBounds = YES;
    [self.navigationController.navigationBar addSubview:publishButton];
}








- (IBAction)publishLocation:(id)sender {
    
   
    [self MakeLocation];

   
}


-(void)MakeLocation{

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
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSString *latitude = [NSString stringWithFormat:@"l=%@",[locationDic valueForKey:@"latitude"]];
        NSString *string1 = [latitude stringByAppendingString:@"%2C"];
        NSString *httpArg = [NSString stringWithFormat:@"%@%@",string1,[locationDic valueForKey:@"longitude"]];
        
        
        
        NSString *httpUrl = @"http://apis.baidu.com/3023/geo/address";
//        NSString *httpArg = @"l=31.215865%2C121.510374";
        [self request: httpUrl withHttpArg: httpArg];
        
    }];
    [queue addOperation:operation];

}



#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    self.dic = [NSMutableDictionary dictionary];
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    NSString *latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//    NSNumber *latitude = [NSNumber numberWithFloat:newLocation.coordinate.latitude];
//    NSNumber *longitude = [NSNumber numberWithFloat:newLocation.coordinate.longitude];
    [self.dic setValue:latitude forKey:@"latitude"];
    [self.dic setValue:longitude forKey:@"longitude"];
    
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchDown:(id)sender {
    [self.textView resignFirstResponder];
    if (openOrNot == YES) {
        [self makeTableView];
    }
}

-(void)blackViewTouchDown{
    if (openOrNot == YES) {
        [self makeTableView];
    }
}


#pragma mark ------tableView的delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return locationModel.nameArray.count -1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBMPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publishCell" ];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.nameLabel.text = locationModel.nameArray[indexPath.row];
    cell.placeLabel.text = locationModel.addrArray[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.locationButton.titleLabel.text = locationModel.nameArray[indexPath.row];
    if (openOrNot == YES) {
        [self makeTableView];
    }
    
}



#pragma mark ------textView的delegate

-(void)textViewDidChange:(UITextView *)textView
{

    if (textView.text.length > 25) {

        [self.textView resignFirstResponder];

    }
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/25",textView.text.length];

}



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"你想说的话"]) {
        textView.text = @"";
    }
    
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        textView.text = @"你想说的话";
    }
    //    CGRect textViewRect  = self.textView.frame;
    //    if (keyboardOpen == YES) {
    //        [UIView animateWithDuration:1 animations:^{
    //            [self.textView setFrame:CGRectMake(textViewRect.origin.x, textViewRect.origin.y + keyboardOffSet, textViewRect.size.width, textViewRect.size.height)];
    //        }];
    //        keyboardOpen = NO;
    //    }
    
}

#pragma mark ---弹出键盘时适应
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (keyboardOpen == NO) {
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
        CGFloat keyboardHeight = endKeyboardRect.origin.y;
        CGRect textViewRect  = self.textView.frame;
        CGFloat textViewHeight = textViewRect.origin.y+textViewRect.size.height;
        keyboardOffSet = textViewHeight - keyboardHeight;
        CGFloat newy = textViewRect.origin.y - keyboardOffSet;
        [UIView animateWithDuration:duration animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-keyboardOffSet, self.view.frame.size.width, self.view.frame.size.height)];
        }];
     
        keyboardOpen = YES;
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect textViewRect  = self.textView.frame;
    if (keyboardOpen == YES) {
        [UIView animateWithDuration:1 animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+keyboardOffSet, self.view.frame.size.width, self.view.frame.size.height)];
        }];
        keyboardOpen = NO;
    }
}



#pragma mark ----发布照片事件

-(void)publishPhotoButtonClicked:(id)sender{
    
    if ([self.textView.text  isEqual: @"你想说的话"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请写上你的留言"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        
        [alert show];
        
    }else{
    
    NSData *data = UIImageJPEGRepresentation(self.pulishview.image, 0.00001);
    GBMPublishRequest *request = [[GBMPublishRequest alloc]init];
    GBMUserModel *user = [GBMGlobal shareGloabl].user;
    [request sendLoginRequestWithUserId:user.userId token:user.token longitude:[self.dic valueForKey:@"longitude"] latitude:[self.dic valueForKey:@"latitude"] title:self.textView.text data:data delegate:self];
    
    if ([activity isAnimating]) {
        [activity stopAnimating];
    }
    [activity startAnimating];
    }
    
}


-(void)requestSuccess:(GBMPublishRequest *)request picId:(NSString *)picId
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.tag == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    }else if (self.tag == 2 ){
         [self dismissViewControllerAnimated:YES completion:nil];
    }
   
    [activity stopAnimating];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate loadMainViewWithController:self];
}


-(void)requestFailed:(GBMPublishRequest *)request error:(NSError *)error
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [activity stopAnimating];
}



- (IBAction)returnToCamera:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate addOrderView];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark ---制作返回按钮
-(void)MakeBackButton{
  
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    


}

-(void)cancelAction:(id)sender{
    
    if (self.tag == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if (self.tag == 2 ){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
