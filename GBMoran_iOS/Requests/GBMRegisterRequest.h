//
//  GBMRegisterRequest.h
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/21.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMUserModel.h"

@class GBMRegisterRequest;

@protocol GBMRegisterRequestDelegate <NSObject>

- (void)registerRequestSuccess:(GBMRegisterRequest *)request user:(GBMUserModel *)user;
- (void)registerRequestFailed:(GBMRegisterRequest *)request error:(NSError *)error;

@end


@interface GBMRegisterRequest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, weak) id <GBMRegisterRequestDelegate> delegate;

- (void)sendRegisterRequestWithUserName:(NSString *)username
                                  email:(NSString *)email
                               password:(NSString *)password
                                   gbid:(NSString *)gbid
                               delegate:(id <GBMRegisterRequestDelegate>)delegate;


@end
