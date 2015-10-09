//
//  GBMSquareRequestParser.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 10/9/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMSquareRequestParser.h"

@implementation GBMSquareRequestParser

- (GBMSquareModel *)parseJson:(NSData *)data
{
    NSError *error = nil;
    id jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    if (error) {
        NSLog(@"The parser is not work.");
    } else {
        GBMSquareModel *squareModel = [[GBMSquareModel alloc] init];
        if ([[jsonDic class] isSubclassOfClass:[NSDictionary class]]) {
            
            id data = [jsonDic valueForKey:@"data"];
            if ([[data class] isSubclassOfClass:[NSDictionary class]]) {
                
                id addr = [data valueForKey:@"addr"];
                if ([[addr class] isSubclassOfClass:[NSString class]]) {
                    squareModel.addr = addr;
                }
                
                id pic = [data valueForKey:@"pic"];
                if ([[addr class] isSubclassOfClass:[NSString class]]) {
                    squareModel.pic = pic;
                }
                
            }
            
            
            
//            id returnMessage = [jsonDic valueForKey:@"message"];
//            if ([[returnMessage class] isSubclassOfClass:[NSString class]]) {
//                
//                squareModel.loginReturnMessage = returnMessage;
//                
//                
//            }
            
            return squareModel;
        }
    }
    return nil;
}

@end
