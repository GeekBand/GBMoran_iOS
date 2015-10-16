//
//  GBMReNameRequest.h
//  GBMoran_iOS
//
//  Created by ZHY on 15/10/16.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GBMReNameRequest;

@protocol GBMReNameRequestDelegate <NSObject>

- (void)renameRequestSuccess:(GBMReNameRequest *)request ;
- (void)renameRequestfail:(GBMReNameRequest *)request error:(NSError *)error;

@end

@interface GBMReNameRequest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) id <GBMReNameRequestDelegate> delegate;

- (void)sendReNameRequestWithName:(NSString *)name
                         delegate:(id <GBMReNameRequestDelegate>)delegate;



@end
