//
//  GBMConfiguration.h
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 8/31/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBMConfiguration : NSObject

//loginID,doctorID
+ (void)setLoginId:(NSString *)loginId;
+ (NSInteger)loginId;
+ (NSString *)loginIdStringValue;

//token
+ (void)setToken:(NSString *)token;
+ (NSString *)token;

@end
