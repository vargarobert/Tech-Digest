//
//  TwitterAPI.h
//  Tech Digest
//
//  Created by Robert Varga on 27/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <Foundation/Foundation.h>
//twitter api
#import "STTwitterAPI.h"

@interface TwitterAPI : NSObject

+(STTwitterAPI*)twitterAPIWithOAuth;

@end
