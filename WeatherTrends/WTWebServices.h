//
//  WTWebServices.h
//  WeatherTrends
//
//  Created by BRABUS on 2/10/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTWebServices : NSObject

- (void)getWeatherByPath:(NSString *)meteorologicalStationURL withCompletionBlock:(void(^)(NSData *))completionBlock;

@end
