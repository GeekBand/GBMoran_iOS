//
//  GBMSquareViewController.h
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 8/9/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBMSquareViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)toCheckPicture;
@property (nonatomic, strong) NSString *pic_url;
@property (nonatomic, strong) NSString *pic_id;
@property (nonatomic, strong) NSMutableDictionary *locationDic;

@end
