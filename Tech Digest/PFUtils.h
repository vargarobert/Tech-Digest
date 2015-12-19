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

/**
 Returns through completionBlock the tarticles from the local Parse data store.
 
 @param date Date for which to return articles.
 @param completionBlock The block to be executed on the completion of a  request. This block has no return value and takes two arguments: the HTTPCode of the operation and the object constructed from the response data of the request.rguments: the HTTPCode of the operation and the object constructed from the response data of the request.
 */
+(void)_getArticlesFromDatastoreForDate:(NSDate*)date completion:(void (^)(NSArray *array))completionBlock;


/**
 Returns through completionBlock the articles from the cloud Parse data store through a HTTP connection.
 
 @param date Date for which to return articles.
 @param completionBlock The block to be executed on the completion of a  request. This block has no return value and takes two arguments: the HTTPCode of the operation and the object constructed from the response data of the request.
 */
+(void)_getArticlesFromCloudForDate:(NSDate*)date completion:(void (^)(int HTTPCode, NSArray *array))completionBlock;

@end
