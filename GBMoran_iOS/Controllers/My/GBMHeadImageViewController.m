//
//  GBMHeadImageViewController.m
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMHeadImageViewController.h"

@interface GBMHeadImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation GBMHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.changeHeadImageButton.layer.cornerRadius = 5.0;
    self.headImageView.image = self.headImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)doneBarButtonClicked:(id)sender
{
    [self.delegate updateHeadImage:self.headImageView.image];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeHeadImageButtonClicked:(id)sender
{
    [self addActionSheet];
}

// 添加ActionSheet
- (void)addActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"无法获取相机"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.headImage = info[UIImagePickerControllerOriginalImage];
    self.headImageView.image = self.headImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
