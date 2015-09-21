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
        if ([[jsonDic class] isSubclassOfClass:[NSDictionary class]]) {
            id returnMessage = [jsonDic valueForKey:@"message"];
            if ([[returnMessage class] isSubclassOfClass:[NSString class]]) {
                GBMUserModel *user = [[GBMUserModel alloc] init];
                user.loginReturnMessage = returnMessage;
                
                return user;
            }
        }
    }
    return nil;
}

@end
