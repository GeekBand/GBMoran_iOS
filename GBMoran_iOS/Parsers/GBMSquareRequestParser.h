//
//  GBMSquareRequestParser.h
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 10/9/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMSquareModel.h"

@interface GBMSquareRequestParser : NSObject

- (GBMSquareModel *)parseJson:(NSData *)data;

@end
