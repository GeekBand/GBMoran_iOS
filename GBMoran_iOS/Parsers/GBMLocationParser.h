//
//  GBMLocationParser.h
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/10/16.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMLocationModel.h"


@interface GBMLocationParser : NSObject

- (GBMLocationModel *)parseJson:(NSData *)data;

@end
