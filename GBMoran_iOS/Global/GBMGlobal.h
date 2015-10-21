//
//  GBGlobal.h
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/9/24.
//  Copyright © 2015年 Brave. All rights reserved.
//
#import "GBMUserModel.h"
#import <Foundation/Foundation.h>

@interface GBMGlobal : NSObject

@property(nonatomic, strong)GBMUserModel *user;

+ (GBMGlobal *)shareGloabl;

@end
