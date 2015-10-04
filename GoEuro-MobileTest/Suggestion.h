//
//  Suggestion.h
//  GoEuro-MobileTest
//
//  Created by islam metwally on 10/3/15.
//  Copyright (c) 2015 Islam Metwally. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Suggestion : NSObject 
{
    CLLocation *userLocation;
}
/* object example from calling web service
 "_id":376583,
 "key":null,
 "name":"Hamburg",
 "fullName":"Hamburg, Deutschland",
 "iata_airport_code":null,
 "type":"location",
 "country":"Deutschland",
 "geo_position":{
 "latitude":53.57532,
 "longitude":10.01534
 },
 "locationId":8752,
 "inEurope":true,
 "countryCode":"DE",
 "coreCountry":true,
 "distance":null
 */

// suggestion id
@property (nonatomic, assign) int ID;
// suggestion Key
@property (nonatomic, copy) NSString *Key;
//// suggestion name
@property (nonatomic, copy) NSString *name;
// suggestion Full name, invluding country
@property (nonatomic, copy) NSString *fullName;
// suggestion type, i.e.:location
@property (nonatomic, copy) NSString *type;
// suggestion country
@property (nonatomic, copy) NSString *country;
// suggestion locationID
@property (nonatomic, assign) int LocationID;
// suggestion country code, short for country
@property (nonatomic, copy) NSString *countryCode;
// suggestion core country
@property (nonatomic, assign) BOOL coreCountry;
// suggestion in europe or not
@property (nonatomic, assign) BOOL inEurope;
// suggestion distance from user
@property (nonatomic, assign) double distance;
// suggestion location on map
@property (nonatomic, strong) CLLocation *geoPosition;

//given a dictionary of json, initalize a suggestion object with data
-(id) initWithDictionary:(NSDictionary *)dict;
@end
