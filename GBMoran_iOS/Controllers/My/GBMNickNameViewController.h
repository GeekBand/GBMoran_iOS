//
//  GBMNickNameViewController.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBMNickNameViewController;

@protocol GBMNickNameViewControllerDelegate <NSObject>

- (void)updateNickName:(NSString *)newName;

@end

@interface GBMNickNameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (nonatomic, weak) NSString *nickName;
@property (nonatomic, weak) id <GBMNickNameViewControllerDelegate> delegate;

- (IBAction)doneBarButtonClicked:(id)sender;

@end
