//
//  WTWeatherAPI.m
//  WeatherTrends
//
//  Created by BRABUS on 2/10/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import "WTWeatherAPI.h"
#import "WTWebServices.h"
#import "WTLocalData.h"

@interface WTWeatherAPI () {
    WTWebServices *webServices;
    WTLocalData *localData;
}
@end

@implementation WTWeatherAPI
//Singletone
+ (WTWeatherAPI *)sharedInstance {
    static WTWeatherAPI * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [WTWeatherAPI new];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self)
    {
        webServices = [WTWebServices new];
        localData = [WTLocalData new];
    }
    return self;
}

- (void)getWeatherByPath:(NSString *)meteorologicalStationURL {
    
    [webServices getWeatherByPath:meteorologicalStationURL withCompletionBlock:^(NSData *weatherData) {
        [localData parseData:weatherData];
    }];
}

- (NSMutableArray *)weatherStationData {

    return [localData weatherStationData];
}

- (NSDictionary *)getListOfStations {
    return [localData getListOfStations];
}

@end
