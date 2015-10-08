//
//  GBMSquareCell.h
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 8/11/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMSquareViewController.h"
//#import "GBMCheckPictureViewController.h"


@interface GBMSquareCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) GBMSquareViewController *squareVC;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSString *pic_url;
@property (nonatomic, strong) NSString *pic_id;

@end
