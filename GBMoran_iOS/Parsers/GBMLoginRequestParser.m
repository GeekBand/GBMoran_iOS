//
//  GBMLoginRequestParser.m
//  GBDemo05
//
//  Created by yikobe_mac on 9/17/15.
//  Copyright (c) 2015 yikobe. All rights reserved.
//

#import "GBMLoginRequestParser.h"

@implementation GBMLoginRequestParser

- (GBMUserModel *)parseJson:(NSData *)data
{
    NSError *error = nil;
    id jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    if (error) {
        NSLog(@"The parser is not work.");
    } else {
        GBMUserModel *user = [[GBMUserModel alloc] init];
        if ([[jsonDic class] isSubclassOfClass:[NSDictionary class]]) {
            
            id data = [jsonDic valueForKey:@"data"];
            if ([[data class] isSubclassOfClass:[NSDictionary class]]) {
                
                id userId = [data valueForKey:@"user_id"];
                if ([[userId class] isSubclassOfClass:[NSString class]]) {
                    user.userId = userId;
                }
                
                id token = [data valueForKey:@"token"];
                if ([[token class] isSubclassOfClass:[NSString class]]) {
                    user.token = token;
                }
                
            }
            
            
            
            id returnMessage = [jsonDic valueForKey:@"message"];
            if ([[returnMessage class] isSubclassOfClass:[NSString class]]) {
                
                user.loginReturnMessage = returnMessage;
                
                
            }
            
            return user;
        }
    }
    return nil;
}

@end