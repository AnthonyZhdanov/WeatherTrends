//
//  WTLocalData.h
//  WeatherTrends
//
//  Created by BRABUS on 2/10/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTModel.h"

@interface WTLocalData : NSObject

- (void)parseData:(NSData *)weatherData;
- (NSMutableArray *)weatherStationData;
- (NSDictionary *)getListOfStations;

@end
