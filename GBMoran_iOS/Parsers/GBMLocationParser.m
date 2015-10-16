//
//  GBMLocationParser.m
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/10/16.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMLocationParser.h"

@implementation GBMLocationParser

-(GBMLocationModel *)parseJson:(NSData *)data
{
    NSError *error = nil;
    id jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    if (error) {
        NSLog(@"The parser is not work.");
    } else {
        GBMLocationModel *locationModel = [[GBMLocationModel alloc] init];
        if ([[jsonDic class] isSubclassOfClass:[NSDictionary class]]) {
            
            id data = [jsonDic valueForKey:@"addrList"];
            if ([[data class] isSubclassOfClass:[NSArray class]]) {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                
                id name = [data valueForKey:@"name"];
                if ([[name class] isSubclassOfClass:[NSArray class]]) {
                    locationModel.nameArray = name;
                    
                }
                
                id admName = [data valueForKey:@"admName"];
                if ([[admName class] isSubclassOfClass:[NSArray class]]) {
                    [tempDic setValue:admName forKey:@"admName"];
                    locationModel.addrArray = admName;
                }
                
            }
            

            
            return locationModel;
        }
    }
    return nil;
}

@end
