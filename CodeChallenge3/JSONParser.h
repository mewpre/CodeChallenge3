//
//  JSONParser.h
//  GetOnThatBus
//
//  Created by Yi-Chin Sun on 1/20/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol JSONParserDelegate <NSObject>

- (void)didFinishJSONSearchWithMutableArray:(NSMutableArray *)mutableArray;

@end

@interface JSONParser : NSObject

-(void)getBikeStationsFromAPI:(CLLocation *)location;

@property (nonatomic, weak) id<JSONParserDelegate> delegate;

@end

