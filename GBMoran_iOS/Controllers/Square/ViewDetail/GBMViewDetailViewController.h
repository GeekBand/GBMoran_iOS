//
//  GBMViewDetailViewController.h
//  GBMoran_iOS
//
//  Created by ZHY on 15/10/2.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMViewDetailRequest.h"
@interface GBMViewDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *PhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (copy,nonatomic ) NSString *pic_id;
@end
