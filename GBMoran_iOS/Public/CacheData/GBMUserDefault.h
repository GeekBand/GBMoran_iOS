//
//  GBMUserDefault.h
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 8/31/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBMUserDefault : NSObject

+ (void)setUserDefault:(NSString *)type value:(NSString *)value;
+ (NSString *)getUserDefaultValue:(NSString *)type;

+ (void)setUserDefaultObject:(NSString *)key value:(id)value;
+ (id)getUserDefaultObject:(NSString *)type;

@end
