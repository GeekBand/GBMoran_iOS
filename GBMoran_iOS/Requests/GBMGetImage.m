//
//  GBMGetImage.m
//  GBMoran_iOS
//
//  Created by ZHY on 15/10/16.
//  Copyright © 2015年 Brave. All rights reserved.
//
//
//  GBMLoginRequest.m
//  GBMoran_iOS
//
//  Created by yikobe_mac on 15/9/21.
//  Copyright © 2015年 Brave. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GBMGlobal.h"
#import "GBMGetImage.h"
@implementation GBMGetImage

- (void) sendGetImageRequest{
    
    [self.urlConnection cancel];
    NSString *urlString = @"http://moran.chinacloudapp.cn/moran/web/user/show";
    //生成连接字符串
    urlString = [NSString stringWithFormat:@"%@?user_id=%@", urlString,[GBMGlobal shareGloabl].user.userId];
    NSString *encodedURLString
    = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 60;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData; // 忽略本地和远程的缓存
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self
                                                 startImmediately:YES];
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
    
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [GBMGlobal shareGloabl].user.image=[UIImage imageWithData:self.receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"getImage error = %@", error);
    
}


@end
