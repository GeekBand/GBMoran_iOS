//
//  GBMLoginRequest.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/21.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMUserModel.h"

@class GBMLoginRequest;

@protocol GBMLoginRequestDelegate <NSObject>

- (void)loginRequestSuccess:(GBMLoginRequest *)request user:(GBMUserModel *)user;
- (void)loginRequestFailed:(GBMLoginRequest *)request error:(NSError *)error;

@end

@interface GBMLoginRequest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) id <GBMLoginRequestDelegate> delegate;

- (void)sendLoginRequestWithEmail:(NSString *)email
                         password:(NSString *)password
                             gbid:(NSString *)gbid
                         delegate:(id <GBMLoginRequestDelegate>)delegate;



@end
