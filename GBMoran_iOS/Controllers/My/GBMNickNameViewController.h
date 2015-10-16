//
//  GBMNickNameViewController.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMReNameRequest.h"


@interface GBMNickNameViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITextField *nickNameTextField;
@property (nonatomic, weak) NSString *nickName;


- (IBAction)doneBarButtonClicked:(id)sender;

@end
