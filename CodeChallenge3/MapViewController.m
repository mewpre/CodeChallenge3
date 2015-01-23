//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.selectedBikeStation.coordinate, span);
    [self.mapView setRegion:region animated:YES];

    self.mapView.showsUserLocation = YES;
    self.mapView.userLocation.title = @"";

    [self.mapView addAnnotation:self.selectedBikeStation];
}

#pragma mark - MapView Methods
//Gets called for every annotation on map
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    else
    {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pin.canShowCallout = YES;
        pin.image = [UIImage imageNamed:@"bikeImage"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        rightButton.tintColor = [UIColor blueColor];
        [pin setRightCalloutAccessoryView:rightButton];

        return pin;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self directionsAlertView];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)directionsAlertView
{
    //Create a request using current location as the source
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];

    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:self.selectedBikeStation.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:placemark];
    request.destination = mapItem;

    //Get directions for specified request
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         NSArray *routes = response.routes;
         // Get the first route from array of multiple routes
         MKRoute *route = routes.firstObject;

         int x = 1;
         NSMutableString *directionsString = [NSMutableString string];
         for (MKRouteStep *step in route.steps)
         {
             [directionsString appendFormat:@"%d: %@\n", x, step.instructions];
             x++;
         }
         UIAlertView *directionsAlert = [[UIAlertView alloc] initWithTitle:@"Directions:" message:directionsString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [directionsAlert show];
     }];
}



@end
