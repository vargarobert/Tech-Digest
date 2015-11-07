//
//  PDBArticles.m
//  Tech Digest
//
//  Created by Robert Varga on 28/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "PFCategory.h"
#import <Parse/PFObject+Subclass.h>

@implementation PFCategory

@dynamic objectId;
@dynamic title;


+ (void)load {
    // Required to register the sub class with Parse
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"category";
}

//+ (PFQuery *)query {
//    PFQuery *query = [super query];
//    
//    // Include some child keys to avoid making another requests for them in the future
//    [query includeKey:@"category"];
//    [query orderByAscending:@"order"];
//    
//    // Load from the cache if network requests fail
////    query.cachePolicy = kPFCachePolicyNetworkElseCache;
//    
//    return query;
//}

@end
