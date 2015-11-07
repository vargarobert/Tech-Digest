//
//  PDBArticles.m
//  Tech Digest
//
//  Created by Robert Varga on 28/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "PFArticle.h"
#import <Parse/PFObject+Subclass.h>

@implementation PFArticle

@dynamic objectId;
@dynamic batchDate;
@dynamic order;
@dynamic category;
@dynamic title;
@dynamic mainImageUrl;
@dynamic imagesUrls;
@dynamic descriptions;
@dynamic quotes;
@dynamic source;

+ (void)load {
    // Required to register the sub class with Parse
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"article";
}

+ (PFQuery *)query {
    PFQuery *query = [super query];
    
    // Include some child keys to avoid making another requests for them in the future
    [query includeKey:@"category"];
    [query orderByAscending:@"order"];
    
    // Load from the cache if network requests fail
//    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    return query;
}

@end
