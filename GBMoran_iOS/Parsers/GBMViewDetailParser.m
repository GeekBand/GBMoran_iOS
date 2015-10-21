//
//  GBMViewDetailParser.m
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/10/20.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMViewDetailParser.h"
#import "GBMViewDetailModel.h"

@implementation GBMViewDetailParser

- (NSArray *)parseJson:(NSData *)data
{
    NSError *error = nil;
    id jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    
    if (error) {
        NSLog(@"The parser is not work.");
    } else {
        if ([[jsonDic class] isSubclassOfClass:[NSDictionary class]]) {
            id data = [jsonDic valueForKey:@"data"];
            for (id dic in data) {
                GBMViewDetailModel *model = [[GBMViewDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [array addObject:model];
            }
        }
    }
    return array;
}

@end
