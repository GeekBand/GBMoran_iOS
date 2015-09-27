//
//  GBMRegisterRequestParser.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/21.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMUserModel.h"    

@interface GBMRegisterRequestParser : NSObject

- (GBMUserModel *)parseJson:(NSData *)data;

@end
