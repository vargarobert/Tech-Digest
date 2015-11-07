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

+ (id)sharedInstance;
- (void)findAllArticlesInBackgroundWithBlock:(PFArrayResultBlock)resultBlock;

@end
