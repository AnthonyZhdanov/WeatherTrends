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
        //when data received (completion block) parse it:
        [localData parseData:weatherData];
    }];
}

- (NSArray *)weatherStationData {
    NSArray *parsedData = [localData weatherStationData];
    //returns parsed data
    return parsedData;
}

- (NSDictionary *)getListOfStations {
    NSDictionary *allStations = [localData getListOfStations];
    //returns list of all weather stations
    return allStations;
}

@end
