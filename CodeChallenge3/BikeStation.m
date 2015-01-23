//
//  BikeStation.m
//  CodeChallenge3
//
//  Created by Yi-Chin Sun on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "BikeStation.h"

@implementation BikeStation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andUserLocation: (CLLocation *)location
{
    self = [super init];
    if (self)
    {
        self.title = dictionary[@"stAddress1"];
        self.coordinate = CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue], [dictionary[@"longitude"]doubleValue]);
        self.availableBikes = dictionary[@"availableBikes"];
        CLLocation *bikeLocation = [[CLLocation alloc]initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        self.distanceFromUserInMeters = [bikeLocation distanceFromLocation:location];
    }
    return self;
}

@end
