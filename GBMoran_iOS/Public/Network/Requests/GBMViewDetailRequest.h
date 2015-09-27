//
//  GBMViewDetailRequest.h
//  GBMoran_iOS
//
//  Created by ZHY on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GBMViewDetailRequest;
@protocol GBMViewDetailRequestDelegate <NSObject>

- (void)ViewDetailRequestSuccess:(GBMViewDetailRequest *)request ;
- (void)ViewDetailRequestFailed:(GBMViewDetailRequest *)request error:(NSError *)error;

@end

@interface GBMViewDetailRequest : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *URLConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) id <GBMViewDetailRequestDelegate> delegate;
-(void) sendViewDetailRequestWithUserId:(NSString *)UserId
                                  token:(NSString *)token
                                  picId:(NSString *)picId
                               delegate:(id<GBMViewDetailRequestDelegate>)delegate;

@end
