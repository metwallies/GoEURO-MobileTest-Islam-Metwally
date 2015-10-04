//
//  SuggestionsManager.m
//  
//
//  Created by islam metwally on 10/3/15.
//
//

#import "SuggestionsManager.h"
#import "AppDelegate.h"

@implementation SuggestionsManager

+(void) GetSuggestionsWithLocale:(NSString *)code andTerm:(NSString *)term withSuccess:(void (^)(NSArray *))successBlock andFailure:(void (^)(NSError *))FailureBlock {
    
    NSString *URLString = [NSString stringWithFormat:@"%@/position/suggest/%@/%@", ((AppDelegate *)[UIApplication sharedApplication].delegate).baseURL, code, term];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (data.length > 0 && connectionError == nil) {
                                   NSArray *Json = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:0
                                                                                          error:nil];
                                   if ([Json isKindOfClass:[NSArray class]]) {
                                       
                                       NSMutableArray *result = [[NSMutableArray alloc] init];
                                       for (NSDictionary *dict in Json) {
                                           Suggestion *tmpSuggestion = [[Suggestion alloc] initWithDictionary:dict];
                                           [result addObject:tmpSuggestion];
                                       }
                                       
                                       NSSortDescriptor *sortDescriptor;
                                       sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                                                    ascending:YES];
                                       NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                       [result sortUsingDescriptors:sortDescriptors];

                                       
                                       successBlock(result);
                                   }
                                   else {
                                       NSError *JsonError = [[NSError alloc] initWithDomain:@"Error With parsing JSON" code:101 userInfo:nil];
                                       FailureBlock (JsonError);
                                   }
                               }
                               else {
                                   FailureBlock(connectionError);
                               }
                           }];
}

@end
