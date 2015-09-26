//
//  CMJPublishViewController.h
//  蓦然
//
//  Created by 陈铭嘉 on 15/9/21.
//  Copyright © 2015年 com.GeekBand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBMPublishViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong , nonatomic)UIImage *publishPhoto;

-(instancetype)initWithPulishPhoto:(UIImage*)pulishPhoto;


@end
