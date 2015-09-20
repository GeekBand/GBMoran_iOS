//
//  GBMUserDefault.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 8/31/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMUserDefault.h"

@implementation GBMUserDefault

+ (void)setUserDefault:(NSString *)type value:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:type];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserDefaultValue:(NSString *)type
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:type];
}

+ (void)setUserDefaultObject:(NSString *)key value:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id )getUserDefaultObject:(NSString *)type
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:type];
}

@end
