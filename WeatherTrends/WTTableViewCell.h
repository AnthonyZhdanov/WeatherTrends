//
//  WTTableViewCell.h
//  WeatherTrends
//
//  Created by BRABUS on 2/15/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *showMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *showTMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *showTMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *showAFLabel;
@property (weak, nonatomic) IBOutlet UILabel *showRainLabel;
@property (weak, nonatomic) IBOutlet UILabel *showSunLabel;

@end
