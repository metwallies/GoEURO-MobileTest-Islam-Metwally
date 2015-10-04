//
//  SuggestionsManager.h
//  
//
//  Created by islam metwally on 10/3/15.
//
//

#import <Foundation/Foundation.h>
#import "Suggestion.h"

@interface SuggestionsManager : NSObject 

/* 
 * message to get suggestions
 * on success it returns array of parsed suggestions object sorted by distance from User
 * on failure, returns error
 */
+(void) GetSuggestionsWithLocale:(NSString *)code andTerm:(NSString *)term withSuccess:(void (^)(NSArray *suggesstions))successBlock andFailure:(void (^) (NSError *error))FailureBlock;

@end
