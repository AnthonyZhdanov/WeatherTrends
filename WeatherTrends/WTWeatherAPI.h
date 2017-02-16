//
//  WTWeatherAPI.h
//  WeatherTrends
//
//  Created by BRABUS on 2/10/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTWeatherAPI : NSObject

+ (WTWeatherAPI *)sharedInstance;
- (void)getWeatherByPath:(NSString *)meteorologicalStationURL;
- (NSMutableArray *)weatherStationData;
- (NSDictionary *)getListOfStations;

@end
