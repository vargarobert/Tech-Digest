//
//  PFUtils.m
//  Tech Digest
//
//  Created by Robert Varga on 01/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "PFUtils.h"
#import "PFArticle.h"

typedef void(^completion)(NSArray *array);

@implementation PFUtils

+ (id)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)findAllArticlesInBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [PFArticle query];
    [query includeKey:@"room"];
    [query includeKey:@"slot"];
    [query includeKey:@"speakers"];
//    
//    PFQuery *query = [PFArticle query];
//    [query whereKey:@"batchDate" greaterThanOrEqualTo:today];
//    [query whereKey:@"batchDate" lessThan:tomorrow];
    
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *articles, NSError *error) {
        resultBlock(articles, error);
    }];
}
///

+(void)_getArticlesFromDatastoreForDate:(NSDate*)today completion:(void (^)(NSArray *array))completionBlock  {
    NSDate *tomorrow = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                value:1
                                                               toDate:today
                                                              options:0];
    //query parameters
    PFQuery *query = [PFArticle query];
    //get from local datastore
    [query fromLocalDatastore];
    [query whereKey:@"batchDate" greaterThanOrEqualTo:today];
    [query whereKey:@"batchDate" lessThan:tomorrow];
    
//    __block NSArray *data = [[NSArray alloc] init];
    NSLog(@"%@", today);
    
    //begin query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //sucess
//            data = objects;
//            if ( objects.count ) {
//                return objects;
//            }
            completionBlock(objects);
            //sucess end
        }
    }];
    
}


@end
