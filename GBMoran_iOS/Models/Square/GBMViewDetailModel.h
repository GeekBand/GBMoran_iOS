//
//  GBMViewDetailModel.h
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/10/20.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBMViewDetailModel : NSObject


@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *modified;


-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
