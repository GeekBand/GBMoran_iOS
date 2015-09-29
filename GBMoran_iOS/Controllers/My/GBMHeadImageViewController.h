//
//  GBMHeadImageViewController.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBMHeadImageViewController;

@protocol GBMHeadImageViewControllerDelegate <NSObject>

- (void)updateHeadImage:(UIImage *)newImage;

@end

@interface GBMHeadImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeHeadImageButton;
@property (nonatomic, weak) UIImage *headImage;
@property (nonatomic, weak) id <GBMHeadImageViewControllerDelegate> delegate;

- (IBAction)doneBarButtonClicked:(id)sender;
- (IBAction)changeHeadImageButtonClicked:(id)sender;

@end
