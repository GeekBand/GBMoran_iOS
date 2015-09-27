//
//  GBMHeadImageViewController.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBMHeadImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeHeadImageButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)doneBarButtonClicked:(id)sender;
- (IBAction)changeHeadImageButtonClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;

@end
