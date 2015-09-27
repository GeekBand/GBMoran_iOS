//
//  GBMViewDetailRequest.m
//  GBMoran_iOS
//
//  Created by ZHY on 15/9/27.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMViewDetailRequest.h"


@implementation GBMViewDetailRequest
-(void) sendViewDetailRequestWithUserId:(NSString *)UserId token:(NSString *)token picId:(NSString *)picId delegate:(id<GBMViewDetailRequestDelegate>)delegate{
    [self.URLConnection cancel];
    self.delegate = delegate;
    NSString *URLString = @"￼moran.chinacloudapp.cn/moran/web/picture/read";
    URLString = [NSString stringWithFormat:@"%@?user_id=%@&token=%@pic_id=%@", URLString, UserId    , token,picId];
    NSString *encodedURLString
    = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:encodedURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 60;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    self.URLConnection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self
                                                 startImmediately:YES];
}
//如果否
- (void)start
{
    [self.URLConnection start];
}
//取消请求
- (void)cancelRequest
{
    if (self.URLConnection) {
        [self.URLConnection cancel];
        self.URLConnection = nil;
    }
}
#pragma mark - 网络请求代理方法

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {
        self.receivedData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.receivedData = [NSMutableData data];
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *string = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"receive data string:%@", string);
    
   
    
    if ([_delegate respondsToSelector:@selector(ViewDetailRequestSuccess:)]) {
        [_delegate ViewDetailRequestSuccess:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
    if ([_delegate respondsToSelector:@selector(ViewDetailRequestFailed:error:)]) {
        [_delegate ViewDetailRequestFailed:self error:error];
    }
}


@end
