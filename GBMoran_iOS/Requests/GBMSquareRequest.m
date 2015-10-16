//
//  GBMSquareRequest.m
//  GBMoran_iOS
//
//  Created by 柴勇峰 on 10/9/15.
//  Copyright (c) 2015 Brave. All rights reserved.
//

#import "GBMSquareRequest.h"
#import "BLMultipartForm.h"
#import "GBMSquareRequestParser.h"

@implementation GBMSquareRequest

- (void)sendSquareRequestWithParameter:(NSDictionary *)paramDic delegate:(id<GBMSquareRequestDelegate>)delegate
{
    [self.urlConnection cancel];
    
    self.delegate = delegate;
    
    NSString *urlString = @"http://moran.chinacloudapp.cn/moran/web/node/list";
    
    // POST请求
    NSString *encodeURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodeURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData; // 忽略本地和远程的缓存
    
    //    NSData *data1 = [request HTTPBody];
    
//    NSDictionary *dic = @{@"token":token, @"user_id":loginId, @"longitude":@"121.47794", @"latitude":@"31.22516", @"distance":@"1000"};
    
    BLMultipartForm *form = [[BLMultipartForm alloc] init];
    [form addValue:paramDic[@"token"] forField:@"token"];
    [form addValue:paramDic[@"user_id"] forField:@"user_id"];
    [form addValue:paramDic[@"longitude"] forField:@"longitude"];
    [form addValue:paramDic[@"latitude"] forField:@"latitude"];
    [form addValue:paramDic[@"distance"] forField:@"distance"];
    request.HTTPBody = [form httpBody];
    [request setValue:form.contentType forHTTPHeaderField:@"Content-Type"];
    
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
    self.receivedData = [NSMutableData data];
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *string = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
       NSLog(@"Square receive data string:%@", string);
    
    GBMSquareRequestParser *parser = [[GBMSquareRequestParser alloc] init];
    GBMSquareModel *squareModel = [parser parseJson:self.receivedData];
    if ([_delegate respondsToSelector:@selector(squareRequestSuccess:squareModel:)]) {
        [_delegate squareRequestSuccess:self squareModel:squareModel];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
    if ([_delegate respondsToSelector:@selector(squareRequestFailed:error:)]) {
        [_delegate squareRequestFailed:self error:error];
    }
}

@end
