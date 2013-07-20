/*
 * Copyright 2013 JaanusSiim
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "JCSNetworkOperation.h"
#import "JCSFoundationConstants.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@implementation JCSNetworkOperation

- (void)execute {
    JCS_ABSTRACT_METHOD;
}

- (void)postData:(NSDictionary *)data toPath:(NSString *)path {
    [self executeOperationWithMethod:@"POST" path:path parameters:data];
}

- (void)getToPath:(NSString *)path withParameters:(NSDictionary *)parameters {
    [self executeOperationWithMethod:@"GET" path:path parameters:parameters];
}

- (void)postBinaryDataFromFiles:(NSDictionary *)files usingParams:(NSDictionary *)params toPath:(NSString *)postPath {
    NSMutableURLRequest *request = [[self httpClient] multipartFormRequestWithMethod:@"POST" path:postPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        for (NSString *key in files) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:files[key]] name:key error:nil];
        }
    }];

    [self executeRequest:request];
}

- (void)executeOperationWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSLog(@"%@ to %@", method, path);
    NSLog(@"Data: %@", parameters);

    NSMutableURLRequest *request = [[self httpClient] requestWithMethod:method path:path parameters:parameters];
    [self executeRequest:request];
}

- (void)executeRequest:(NSMutableURLRequest *)request {
    NSLog(@"Body:%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);

    [self setOptionalHeaders:request];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setThreadPriority:0.1];
    [op setQueuePriority:NSOperationQueuePriorityLow];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self handleResponseData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleErrorResponse:operation.responseData error:error];
    }];
    [op start];
}

- (AFHTTPClient *)httpClient {
    JCS_ABSTRACT_METHOD;
    return nil;
}

- (void)setOptionalHeaders:(NSMutableURLRequest *)request {

}

- (void)handleResponseData:(id)responseObject {
    JCSFLog(@"handleResponse");
}

- (void)handleErrorResponse:(id)responseData error:(NSError *)error {
    JCSFLog(@"handleErrorResponse");
}

@end
