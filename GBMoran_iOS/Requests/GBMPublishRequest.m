//
//  GBMPublishRequest.m
//  GBMoran_iOS
//
//  Created by 陈铭嘉 on 15/9/23.
//  Copyright © 2015年 Brave. All rights reserved.
//

#import "GBMPublishRequest.h"
#import "BLMultipartForm.h"
#import "GBMPublishRequestParser.h"

@interface GBMPublishRequest()<NSURLConnectionDataDelegate>


@end


@implementation GBMPublishRequest


-(void)sendLoginRequestWithUserId:(NSString *)userId token:(NSString *)token longitude:(NSString *)longitude latitude:(NSString *)latitude title:(NSString *)title data:(NSData *)data delegate:(id<GBMPublishRequestDelegate>)delegate
{
    
    [self.urlConnection cancel];
    self.delegate = delegate;
    
    NSString *urlString = @"http://moran.chinacloudapp.cn/moran/web/picture/create";
    
    // POST请求
    NSString *encodeURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodeURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData; // 忽略本地和远程的缓存
    
    
    BLMultipartForm *form = [[BLMultipartForm alloc] init];
    [form addValue:token forField:@"token"];
    [form addValue:userId forField:@"user_id"];
    [form addValue:data forField:@"data"];
    [form addValue:title forField:@"title"];
    [form addValue:@"上海浦东软件园" forField:@"location"];
    [form addValue:longitude forField:@"longitude"];
    [form addValue:latitude forField:@"latitude"];
    [form addValue:@"上海浦东软件园" forField:@"addr"];
    
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
    NSLog(@"receive data string:%@", string);
    GBMPublishRequestParser *parser =[[GBMPublishRequestParser alloc]init];
    GBMPublishModel* model =  [parser parseJson:self.receivedData];
    if ([_delegate respondsToSelector:@selector(requestSuccess:picId:)]) {
        [_delegate requestSuccess:self picId:model.picId];
    }
    //    [parser parseJson:self.receivedData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
    if ([_delegate respondsToSelector:@selector(requestFailed:error:)]) {
        [_delegate requestFailed:self error:error];
    }
}




@end
