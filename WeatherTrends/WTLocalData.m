//
//  WTLocalData.m
//  WeatherTrends
//
//  Created by BRABUS on 2/10/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import "WTLocalData.h"
#import "WTConstants.h"

@interface WTLocalData () {
    NSMutableArray *stationWeatherData;
    NSString *modifiedString;
}

@end

@implementation WTLocalData

- (NSMutableArray *)weatherStationData {
    return stationWeatherData;
}

- (NSDictionary *)getListOfStations {
    NSDictionary *stationsList;
    stationsList = @{@"Aberporth" : Aberporth,
                     @"Armagh" : Armagh,
                     @"Ballypatrick Forest" : BallypatrickForest,
                     @"Bradford" : Bradford,
                     @"Braemar" : Braemar,
                     @"Camborne" : Camborne,
                     @"Cambridge NIAB" : CambridgeNIAB,
                     @"Bute Park" : CardiffButePark,
                     @"Chivenor" : Chivenor,
                     @"Cwmystwyth" : Cwmystwyth,
                     @"Dunstaffnage" : Dunstaffnage,
                     @"Durham" : Durham,
                     @"Eastbourne" : Eastbourne,
                     @"Eskdalemuir" : Eskdalemuir,
                     @"Heathrow" : Heathrow,
                     @"Hurn" : Hurn,
                     @"Lerwick" : Lerwick,
                     @"Leuchars" : Leuchars,
                     @"Lowestoft" : Lowestoft,
                     @"Manston" : Manston,
                     @"Nairn" : Nairn,
                     @"Newton Rigg" : NewtonRigg,
                     @"Oxford" : Oxford,
                     @"Paisley" : Paisley,
                     @"Ringway" : Ringway,
                     @"Ross-on-Wye" : RossonWye,
                     @"Shawbury" : Shawbury,
                     @"Sheffield" : Sheffield,
                     @"Southampton" : Southampton,
                     @"Stornoway Airport" : StornowayAirport,
                     @"Sutton Bonington" : SuttonBonington,
                     @"Tiree" : Tiree,
                     @"Valley" : Valley,
                     @"Waddington" : Waddington,
                     @"Whitby" : Whitby,
                     @"Wick Airport" : WickAirport,
                     @"Yeovilton" : Yeovilton};
    return stationsList;
}

- (void)parseData:(NSData *)weatherData {
    stationWeatherData = [NSMutableArray new];
    NSString *responseString = [[NSString alloc] initWithData:weatherData encoding:NSUTF8StringEncoding];
    NSArray *listArray = [responseString componentsSeparatedByString:@"\n"];
    NSMutableArray *delExtraSpacesArray = [NSMutableArray new];
    //removes extra "space" from strings in array
    for (NSString *tempString in listArray) {
        [delExtraSpacesArray addObject:[self deleteSpacesFromString:tempString]];
    }
    for (NSString *anotherTempString in delExtraSpacesArray) {
        if ([anotherTempString hasPrefix:@" 1"] || [anotherTempString hasPrefix:@" 2"]) {
            [stationWeatherData addObject:[self separateStringBySpaceSymbol:anotherTempString]];
        }
    }
    //sending message that data is ready
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WTDataReady"
                                                        object:self
                                                      userInfo:nil];
}

- (NSString *)deleteSpacesFromString:(NSString *)incomingString {
    //I know that data from station separated by "space" symbols and each time count of that symbols is different.
    //so the code below leaves only one "space" symbol betwen data
    //but it's necessary to check is thete such symbols in our string
    modifiedString = incomingString;
    NSString *twinSpace = @"  ";
    NSRange range;
    do {
        modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        range = [modifiedString rangeOfString:twinSpace];
    } while (range.location != NSNotFound);
    return modifiedString;
}

- (NSMutableDictionary *)separateStringBySpaceSymbol:(NSString *)incomingString {
    //parsing incoming string to an array of elements separated by single space symbol
    NSArray *listArray = [incomingString componentsSeparatedByString:@" "];
    NSMutableDictionary *yearData = [NSMutableDictionary new];
    
    yearData[@"Year"] = listArray[1];
    yearData[@"Month"] = listArray[2];
    yearData[@"tMaxC"] = listArray[3];
    yearData[@"tMinC"] = listArray[4];
    yearData[@"AfDays"] = listArray[5];
    yearData[@"RainMm"] = listArray[6];
    if (listArray.count < 8) {
        yearData[@"SunHours"] = @"---";
    }
    else {
        yearData[@"SunHours"] = listArray[7];
    }
    return yearData;
}
@end
