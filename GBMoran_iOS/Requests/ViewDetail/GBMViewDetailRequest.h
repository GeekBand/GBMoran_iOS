//
//  GBMViewDetailRequest.h
//  GBMoran_iOS
//
//  Created by ZHY on 15/10/19.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GBMViewDetailRequest;

@protocol GBMViewDetailRequestDelegate <NSObject>

- (void)viewDetailRequestSuccess:(GBMViewDetailRequest *)request data:(NSArray *)array;

- (void)viewDetailRequestFailed:(GBMViewDetailRequest *)request error:(NSError *)error;

@end

@interface GBMViewDetailRequest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) id <GBMViewDetailRequestDelegate> delegate;

- (void)sendViewDetailRequestWithParameter:(NSDictionary *)paramDic
                              delegate:(id <GBMViewDetailRequestDelegate>)delegate;




@end