//
//  ViewController.m
//  WeatherTrends
//
//  Created by BRABUS on 2/10/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import "WTViewController.h"
#import "WTWeatherAPI.h"
#import "WTModel.h"
#import "WTTableViewCell.h"

static NSString *const kCellIdentifier = @"MonthData";
static float const kTimeintervalForDoubleCkick = 0.3;

@interface WTViewController ()

@property (strong, nonatomic) NSArray *weatherDataArray;
@property (weak, nonatomic) IBOutlet UITableView *weatherTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property UISearchController *searchController;
@property (strong, nonatomic) NSArray *filteredArray;
@property BOOL shouldShowSearchResults;
@property NSTimeInterval lastClick;
@property NSIndexPath *lastIndexPath;

@end

@implementation WTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shouldShowSearchResults = NO;
    [self.pickerView setUserInteractionEnabled:YES];
    //color setup
    self.weatherTableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.weatherTableView.separatorColor = [UIColor clearColor];
    self.headerView.backgroundColor = [UIColor grayColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"backVarTwo"];
    self.headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    //hide elements while no data
    [self.weatherTableView setHidden:YES];
    //show indicator while data loading and parsing and setup
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicator.color = [UIColor whiteColor];
    //search bar
    [self configureSearchController];
    //get list of stations (returns NSDictionary)
    self.dict = [[WTWeatherAPI sharedInstance] getListOfStations];
    //add all keys to an array and sort it alphabetically
    NSArray *tempAllKeys = [self.dict allKeys];
    self.pickerData = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //catch message that data loaded and start operations with it
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createObjectsWithData)
                                                 name:@"WTDataReady"
                                               object:nil];
    //Request timed out
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enableActionsWStopIndicator)
                                                 name:@"RequestTimedOut"
                                               object:nil];
}
#pragma mark - Private
- (void)createObjectsWithData {
    NSMutableArray *mutableArrayWithWeatherData = [NSMutableArray new];
    NSArray *arrayWithAllData = [[WTWeatherAPI sharedInstance] weatherStationData];
    for (NSDictionary *weatherList in arrayWithAllData) {
        
        WTModel *year = [[WTModel alloc]initWithYear:weatherList[@"Year"]
                                               month:weatherList[@"Month"]
                                                tMax:weatherList[@"tMaxC"]
                                                tMin:weatherList[@"tMinC"]
                                                  af:weatherList[@"AfDays"]
                                                rain:weatherList[@"RainMm"]
                                                 sun:weatherList[@"SunHours"]];
        [mutableArrayWithWeatherData addObject:year];
        self.weatherDataArray = [mutableArrayWithWeatherData copy];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //reload tableView data and show it
        [self.weatherTableView reloadData];
        [self.weatherTableView setHidden:NO];
        [self.activityIndicator stopAnimating];
        if (![self.searchController.searchBar.text isEqualToString:@""]) {
        //this code allows to searchbar update the list by chosen year if there was search request before
            [self.searchController.searchBar becomeFirstResponder];
        }
        [self.pickerView setUserInteractionEnabled:YES];
    });
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldShowSearchResults) {
        return self.filteredArray.count;
    }
    else {
        return self.weatherDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    WTModel *weatherData = [WTModel new];

    if (self.shouldShowSearchResults) {
        weatherData = self.filteredArray[indexPath.row];
//        NSLog(@"FilteredData%@", self.filteredArray[indexPath.row]);
    }
    else {
        weatherData = self.weatherDataArray[indexPath.row];
//        NSLog(@"AllData%@", weatherData);
    }
    
    if ([weatherData.month isEqualToString:@"Jan"]) {
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10000);
        cell.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    }
    else {
        cell.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    cell.showYearLabel.text = weatherData.year;
    cell.showMonthLabel.text = weatherData.month;
    cell.showTMaxLabel.text = weatherData.tMax;
    cell.showTMinLabel.text = weatherData.tMin;
    cell.showAFLabel.text = weatherData.af;
    cell.showRainLabel.text = weatherData.rain;
    cell.showSunLabel.text = weatherData.sun;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSTimeInterval now = [[[NSDate alloc] init] timeIntervalSince1970];
    //return list of years back to the top (to the searchBar) when any cell doubleclicked
    if ((now - self.lastClick < kTimeintervalForDoubleCkick) && [indexPath isEqual:self.lastIndexPath]) {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
        [self.weatherTableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    self.lastClick = now;
    self.lastIndexPath = indexPath;
}

#pragma mark - UIPickerViewDataSource
// The columns of data number
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    //if there where search before updates serch info
    [self.searchController.searchBar resignFirstResponder];
    NSString *placeName = [self.dict valueForKey:self.pickerData[row]];
    NSString *pathToDataURL = [NSString stringWithFormat:@"http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/%@.txt", placeName];
    
    //hide tableView again while updating data and block picker
    [self.pickerView setUserInteractionEnabled:NO];
    [self.activityIndicator startAnimating];
    [self.weatherTableView setHidden:YES];
    [[WTWeatherAPI sharedInstance] getWeatherByPath:pathToDataURL];
}
#pragma mark - UISearchBarDelegate
- (void)configureSearchController {
    // Initialize and perform a minimum configuration to the search controller.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchBar.alpha = 0.3;
    self.searchController.searchBar.barTintColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    self.searchController.searchBar.backgroundColor = [UIColor clearColor];
    [self.searchController.searchBar setValue:@"Full list" forKey:@"_cancelButtonText"];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search by year";
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    //change color of back button
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    
    // Place the search bar view to the tableview headerview.
    self.weatherTableView.tableHeaderView = self.searchController.searchBar;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = YES;
    [self.weatherTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = NO;
    [self.weatherTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!self.shouldShowSearchResults) {
        self.shouldShowSearchResults = YES;
        [self.weatherTableView reloadData];
    }
    [self.searchController.searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = self.searchController.searchBar.text;
    NSMutableArray *tempArr = [NSMutableArray new];
    for (WTModel *element in self.weatherDataArray) {
        if ([element.year isEqualToString:searchString]) {
            [tempArr addObject:element];
        }
    }
    self.filteredArray = tempArr;
    // Reload the tableview.
    [self.weatherTableView reloadData];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Calculation number of rows in our tableView
//    
//    return (tableView.frame.size.height / 13);
//}

- (void)enableActionsWStopIndicator {
    [self.activityIndicator stopAnimating];
    [self.pickerView setUserInteractionEnabled:YES];
}

@end
