//
//  GBGlobal.m
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/9/24.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMGlobal.h"
static GBMGlobal *global = nil;
@implementation GBMGlobal

+ (GBMGlobal *)shareGloabl
{
    if (global == nil) {
        global = [[GBMGlobal alloc] init];
    }
    return global;
}

@end
