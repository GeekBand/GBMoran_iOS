//
//  GBMSquareRequestParser.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 10/9/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMSquareRequestParser.h"
#import "GBMPictureModel.h"

@implementation GBMSquareRequestParser

- (NSDictionary *)parseJson:(NSData *)data
{
    NSError *error = nil;
    id jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (error) {
        NSLog(@"The parser is not work.");
    } else {
        
        if ([[jsonDic class] isSubclassOfClass:[NSDictionary class]]) {
            
            id data = [[jsonDic valueForKey:@"data"] allValues];
            
            __block GBMSquareRequestParser *weakSelf = self;
            
            for (id dic in data) {
                weakSelf.addrArray = [NSMutableArray array];
                weakSelf.pictureArray = [NSMutableArray array];
               GBMSquareModel *squareModel = [[GBMSquareModel alloc] init];
                [squareModel setValuesForKeysWithDictionary:dic[@"node"]];
                for (id picDictionary in dic[@"pic"]) {
                    
                    GBMPictureModel *pictureModel = [[GBMPictureModel alloc] init];
                   [pictureModel setValuesForKeysWithDictionary:picDictionary];
                    [weakSelf.pictureArray addObject:pictureModel];
                }
                [weakSelf.addrArray addObject:squareModel];
            
                [dictionary setObject:_pictureArray forKey:_addrArray];
            }
        }
    }
    return dictionary;
}

@end
