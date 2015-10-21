//
//  GBMViewDetailParser.h
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/10/20.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBMViewDetailParser : NSObject


@property (nonatomic, strong) NSMutableArray *addrArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;
- (NSArray*)parseJson:(NSData *)data;

@end
