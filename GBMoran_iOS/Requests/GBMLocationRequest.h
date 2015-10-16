//
//  GBMLocationRequest.h
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/10/16.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GBMLocationRequest;

@protocol GBMLocationRequestDelegate <NSObject>

- (void)requestSuccess:(GBMLocationRequest *)request picId:(NSString *)picId;
- (void)requestFailed:(GBMLocationRequest *)request error:(NSError *)error;

@end



@interface GBMLocationRequest : NSObject


@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property(nonatomic, assign)id<GBMLocationRequestDelegate> delegate;

- (void)sendLoginRequestWithAPIKey:(NSString*)apiKey
                          delegate:(id<GBMLocationRequestDelegate>)delegate;

@end
