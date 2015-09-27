//
//  GBMPublishRequest.h
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/9/23.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GBMPublishRequest;


@protocol GBMPublishRequestDelegate <NSObject>

- (void)requestSuccess:(GBMPublishRequest *)request picId:(NSString *)picId;
- (void)requestFailed:(GBMPublishRequest *)request error:(NSError *)error;

@end

@interface GBMPublishRequest : NSObject

@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property(nonatomic, assign)id<GBMPublishRequestDelegate> delegate;

- (void)sendLoginRequestWithUserId:(NSString *)userId
                             token:(NSString *)token
                         longitude:(NSString *)longitude
                          latitude:(NSString *)latitude
                              data:(NSData *)data
                          delegate:(id<GBMPublishRequestDelegate>)delegate;

@end
