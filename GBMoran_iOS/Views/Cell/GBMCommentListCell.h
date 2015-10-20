//
//  GBMCommentListCell.h
//  GBMoran_iOS
//
//  Created by ZhangBob on 8/19/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBMCommentListCell : UITableViewCell{
//    UILabel     *_usernameOfComment;
//    UILabel     *_textOfComment;
//    UIImageView *_headImageOfComment;
//    UILabel     *_dateOfComment;
}

@property(nonatomic,retain)UILabel     *usernameOfComment;
@property(nonatomic,retain)UILabel     *textOfComment;
@property(nonatomic,retain)UIImageView *headImageOfComment;
@property(nonatomic,retain)UILabel     *dateOfComment;

- (void)cleanComponents;

//- (void)setUsernameOfComment:(NSString *)usernameOfComment;
//- (void)setTextOfComment:(NSString *)textfComment;
//- (void)setHeadImageOfComment:(UIImage *)headImagefComment;
//- (void)setDateOfComment:(NSString *)dateOfComment;
@end

