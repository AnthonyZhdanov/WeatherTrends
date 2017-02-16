//
//  WTModel.h
//  WeatherTrends
//
//  Created by BRABUS on 2/14/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTModel : NSObject

@property (nonatomic, copy, readonly) NSString * year;
@property (nonatomic, copy, readonly) NSString * month;
@property (nonatomic, copy, readonly) NSString * tMax;
@property (nonatomic, copy, readonly) NSString * tMin;
@property (nonatomic, copy, readonly) NSString * af;
@property (nonatomic, copy, readonly) NSString * rain;
@property (nonatomic, copy, readonly) NSString * sun;

- (id)initWithYear:(NSString *)year
             month:(NSString *)month
              tMax:(NSString *)tMax
              tMin:(NSString *)tMin
                af:(NSString *)af
              rain:(NSString *)rain
               sun:(NSString *)sun;




@end
