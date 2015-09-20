//
//  GBMConfiguration.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 8/31/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMConfiguration.h"
#import "GBMUserDefault.h"

@implementation GBMConfiguration

+ (void)setLoginId:(NSString *)loginId
{
    [GBMUserDefault setUserDefault:@"loginId" value:loginId];
}

+ (NSInteger)loginId
{
    return [[GBMUserDefault getUserDefaultValue:@"loginId"] integerValue];
}


+ (NSString *)loginIdStringValue
{
    return [NSString stringWithFormat:@"%zd",[self loginId]];
}


+ (void)setToken:(NSString *)token
{
    NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];
    [GBMUserDefault setUserDefaultObject:@"token" value:tokenData];
}

+ (NSString *)token
{
    NSData *tokenData = [GBMUserDefault getUserDefaultObject:@"token"];
    return [[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
}

@end
