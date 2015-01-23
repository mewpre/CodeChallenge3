//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#import "BikeStation.h"
#import "JSONParser.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, JSONParserDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSMutableArray *bikeStationsArray;
@property NSMutableArray *filteredBikeStationsArray;
@property JSONParser *parser;

@property CLLocationManager *myLocationManager;
@property CLLocation *userLocation;

@end

@implementation StationsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parser = [JSONParser new];
    self.parser.delegate = self;
    self.bikeStationsArray = [NSMutableArray new];
    self.filteredBikeStationsArray = [NSMutableArray new];

    self.myLocationManager = [CLLocationManager new];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];
}

-(void)didFinishJSONSearchWithMutableArray:(NSMutableArray *)mutableArray
{
    self.bikeStationsArray = mutableArray;
    [self.tableView reloadData];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 500 && location.horizontalAccuracy < 500)
        {
            self.userLocation = location;
            [self.parser getBikeStationsFromAPI: self.userLocation];
            [self.myLocationManager stopUpdatingLocation];
            break;
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog (@"%@", error);
}

#pragma mark - UITableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBar.text.length !=0)
    {
        return self.filteredBikeStationsArray.count;
    }
    else
    {
        return self.bikeStationsArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.searchBar.text.length != 0)
    {
        BikeStation *selectedBikeStation = [self.filteredBikeStationsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = selectedBikeStation.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Available Bikes: %@\nDistance: %.02f mi", selectedBikeStation.availableBikes, selectedBikeStation.distanceFromUserInMeters/1609.34];
    }
    else
    {
        BikeStation *selectedBikeStation = [self.bikeStationsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = selectedBikeStation.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Available Bikes: %@\nDistance: %.02f mi", selectedBikeStation.availableBikes, selectedBikeStation.distanceFromUserInMeters/1609.34];
    }
    cell.detailTextLabel.numberOfLines = 2;
    cell.imageView.image = [UIImage imageNamed:@"bikeImage"];
    return cell;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    self.filteredBikeStationsArray = [NSMutableArray arrayWithArray:[self.bikeStationsArray filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    MapViewController *mvc = segue.destinationViewController;
    if (self.searchBar.text.length != 0)
    {
        mvc.selectedBikeStation = [self.filteredBikeStationsArray objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
    }
    else
    {
        mvc.selectedBikeStation = [self.bikeStationsArray objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
    }

    MKPointAnnotation *userLocation = [MKPointAnnotation new];
    userLocation.coordinate = self.userLocation.coordinate;
}

@end
