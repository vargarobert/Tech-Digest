//
//  PFUtils.m
//  Tech Digest
//
//  Created by Robert Varga on 01/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "PFUtils.h"

//Article model
#import "PFArticle.h"
//HTTP codes
#import "FTHTTPCodes.h"



@implementation PFUtils

//LOCAL DATASTORE
+(void)_getArticlesFromDatastoreForDate:(NSDate*)date completion:(void (^)(NSArray *array))completionBlock {
    NSDate *tomorrow = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                value:1
                                                               toDate:date
                                                              options:0];
    //query parameters
    PFQuery *query = [PFArticle query];
    //get from local datastore
    [query fromLocalDatastore];
    [query whereKey:@"batchDate" greaterThanOrEqualTo:date];
    [query whereKey:@"batchDate" lessThan:tomorrow];
    
//    __block NSArray *data = [[NSArray alloc] init];
//    NSLog(@"_getArticlesFromDatastoreForDate %@", today);
    
    //begin query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
            //sucess
        completionBlock(objects);
            //sucess end
//        }
    }];
    
}

//CLOUD
+(void)_getArticlesFromCloudForDate:(NSDate*)date completion:(void (^)(int HTTPCode, NSArray *array))completionBlock {
    
    NSDate *tomorrow = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                value:1
                                                               toDate:date
                                                              options:0];
    //query parameters
    PFQuery *query = [PFArticle query];
    [query whereKey:@"batchDate" greaterThanOrEqualTo:date];
    [query whereKey:@"batchDate" lessThan:tomorrow];
    
//    NSLog(@"_getArticlesFromCloudForDate %@", today);
    //    NSLog(@"%@", tomorrow);
    
    //begin query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
//            for (PFArticle *object in objects) {
//                NSLog(@"%@", object.category.title);
//            }
            
            //sucess
            //if there is no previous data or there are query results
//            if ( !self.articleData.count || objects.count ) self.articleData = objects;
            
            if (completionBlock) {
                if ( objects.count ) {
                    completionBlock(HTTPCode200OK, objects);
                } else {
                    completionBlock(HTTPCode204NoContent, objects);
                }
            }
            //sucess end
        } else {
            //error
            if (completionBlock) { completionBlock(HTTPCode599NetworkConnectTimeoutErrorUnknown, objects); }
            
            if ([error code] == kPFErrorObjectNotFound) {
//                NSLog(@"Uh oh, we couldn't find the object!");
            } else if ([error code] == kPFErrorConnectionFailed) {
//                NSLog(@"ROBERT - Uh oh, we couldn't even connect to the Parse Cloud!");
            } else if (error) {
//                NSLog(@"Error: %@", [error userInfo][@"error"]);
            }
            //error end
        }
    }];

}


@end
