//
//  BikeStation.h
//  CodeChallenge3
//
//  Created by Yi-Chin Sun on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BikeStation : MKPointAnnotation

@property NSNumber *availableBikes;
@property CLLocationDistance distanceFromUserInMeters;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andUserLocation: (CLLocation *)location;

@end
