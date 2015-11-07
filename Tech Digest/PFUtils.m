//
//  PFUtils.m
//  Tech Digest
//
//  Created by Robert Varga on 01/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "PFUtils.h"
#import "PFArticle.h"

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


@end
