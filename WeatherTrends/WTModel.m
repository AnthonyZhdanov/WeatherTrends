//
//  WTModel.m
//  WeatherTrends
//
//  Created by BRABUS on 2/14/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import "WTModel.h"

@implementation WTModel

- (id)initWithYear:(NSString *)year
             month:(NSString *)month
              tMax:(NSString *)tMax
              tMin:(NSString *)tMin
                af:(NSString *)af
              rain:(NSString *)rain
               sun:(NSString *)sun {
    self = [super init];
    if (self)
    {
        NSArray *monthList = @[@"empty", @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
        _year = year;
        _month = monthList[[month intValue]];
        _tMax = tMax;
        _tMin = tMin;
        _af = af;
        _rain = rain;
        _sun = sun;
    }
    return self;
}

@end
