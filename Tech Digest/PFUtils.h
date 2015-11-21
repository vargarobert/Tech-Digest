//
//  PFUtils.h
//  Tech Digest
//
//  Created by Robert Varga on 01/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PFUtils : NSObject

+(void)_getArticlesFromDatastoreForDate:(NSDate*)today completion:(void (^)(NSArray *array))completionBlock;
+(void)_getArticlesFromCloudForDate:(NSDate*)today completion:(void (^)(int HTTPCode, NSArray *array))completionBlock;

@end
