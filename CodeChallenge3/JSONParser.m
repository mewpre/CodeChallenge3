//
//  JSONParser.m
//  GetOnThatBus
//
//  Created by Yi-Chin Sun on 1/20/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "JSONParser.h"
#import "BikeStation.h"

@implementation JSONParser

-(void)getBikeStationsFromAPI: (CLLocation *)location
{
    NSMutableArray *bikeStationsArray = [NSMutableArray new];
    NSURL * url = [NSURL URLWithString:@"http://www.bayareabikeshare.com/stations/json"];

    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSDictionary *bikeStationData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        NSArray *bikeStations = bikeStationData[@"stationBeanList"];
        for (NSDictionary *bikeStation in bikeStations)
        {
            BikeStation *newBikeStation = [[BikeStation alloc] initWithDictionary:bikeStation andUserLocation:location];
            [bikeStationsArray addObject:newBikeStation];
        }

        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromUserInMeters" ascending:YES];
        NSArray *sortedArray = [bikeStationsArray sortedArrayUsingDescriptors:@[sortDescriptor]];

        [self.delegate didFinishJSONSearchWithMutableArray:[[NSArray arrayWithArray:sortedArray]mutableCopy]];
    }];
}

@end
