//
//  Suggestion.m
//  GoEuro-MobileTest
//
//  Created by islam metwally on 10/3/15.
//  Copyright (c) 2015 Islam Metwally. All rights reserved.
//

#import "Suggestion.h"

@implementation Suggestion

-(id) initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self) {
        if ([dict objectForKey:@"_id"] && ![[dict objectForKey:@"_id"] isKindOfClass:[NSNull class]])
            self.ID = [[dict objectForKey:@"_id"] intValue];
        if ([dict objectForKey:@"key"])
            self.Key = [dict objectForKey:@"key"];
        if ([dict objectForKey:@"name"])
            self.name = [dict objectForKey:@"name"];
        if ([dict objectForKey:@"fullName"])
            self.fullName = [dict objectForKey:@"fullName"];
        if ([dict objectForKey:@"type"])
            self.type = [dict objectForKey:@"type"];
        if ([dict objectForKey:@"country"])
            self.country = [dict objectForKey:@"country"];
        if ([dict objectForKey:@"locationId"] && ![[dict objectForKey:@"locationId"] isKindOfClass:[NSNull class]])
            self.LocationID = [[dict objectForKey:@"locationId"] intValue];
        if ([dict objectForKey:@"countryCode"])
            self.countryCode = [dict objectForKey:@"countryCode"];
        if ([dict objectForKey:@"coreCountry"])
            self.coreCountry = [[dict objectForKey:@"coreCountry"] boolValue];
        if ([dict objectForKey:@"distance"] && ![[dict objectForKey:@"distance"] isKindOfClass:[NSNull class]])
            self.distance = [[dict objectForKey:@"distance"] doubleValue];
        if ([dict objectForKey:@"inEurope"])
            self.inEurope = [[dict objectForKey:@"inEurope"] boolValue];
        
        double latitude, longitude;
        if ([dict objectForKey:@"geo_position"])
            latitude = [[[dict objectForKey:@"geo_position"] objectForKey:@"latitude"] doubleValue];
        if ([dict objectForKey:@"geo_position"])
            longitude = [[[dict objectForKey:@"geo_position"] objectForKey:@"longitude"] doubleValue];
        self.geoPosition = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    }
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:[[userDict objectForKey:@"latitude"] doubleValue] longitude:[[userDict objectForKey:@"longitude"] doubleValue]];
    self.distance = [userLocation distanceFromLocation:self.geoPosition];
    
    return self;
}




@end
