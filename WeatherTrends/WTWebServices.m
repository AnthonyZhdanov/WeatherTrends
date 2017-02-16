//
//  WTWebServices.m
//  WeatherTrends
//
//  Created by BRABUS on 2/10/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import "WTWebServices.h"

@implementation WTWebServices 

- (void)getWeatherByPath:(NSString *)meteorologicalStationURL withCompletionBlock:(void(^)(NSData *))completionBlock {
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURL* downloadTaskURL = [NSURL URLWithString:meteorologicalStationURL];
    [[session dataTaskWithURL:downloadTaskURL completionHandler:^(NSData * _Nullable data,
                                                                  NSURLResponse * _Nullable response,
                                                                  NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            completionBlock(data);
        }
    }] resume];
}
@end
