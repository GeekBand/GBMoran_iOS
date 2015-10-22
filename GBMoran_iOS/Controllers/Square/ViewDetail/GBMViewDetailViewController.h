//
//  GBMViewDetailViewController.h
//  GBMoran_iOS
//
//  Created by ZHY on 15/10/2.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMViewDetailRequest.h"
@interface GBMViewDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *PhotoImage;
@property (copy,nonatomic ) NSString *pic_id;
@property (copy,nonatomic) NSString *pic_url;
@property (nonatomic, strong) NSArray *commentArr;
@end
