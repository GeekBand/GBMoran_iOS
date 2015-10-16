//
//  GBMHeadImageViewController.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMGlobal.h"
@class GBMHeadImageViewController;



@interface GBMHeadImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeHeadImageButton;
@property (nonatomic, weak) UIImage *headImage;


- (IBAction)doneBarButtonClicked:(id)sender;
- (IBAction)changeHeadImageButtonClicked:(id)sender;

@end
