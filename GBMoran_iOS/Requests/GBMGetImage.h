//
//  GBMGetImage.h
//  GBMoran_iOS
//
//  Created by ZHY on 15/10/16.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMUserModel.h"


@interface GBMGetImage : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;

- (void)sendGetImageRequest;

@end
