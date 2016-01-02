//
//  TwitterAPI.m
//  Tech Digest
//
//  Created by Robert Varga on 27/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "TwitterAPI.h"

@implementation TwitterAPI

+(STTwitterAPI*)twitterAPIWithOAuth {
    return [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"n08NvNm1im2MLXreFH9N2aKtC" consumerSecret:@"3GiyUN5ctqfoWveqQr6mUpZ0AmpKeYejXJKmYDJym4j4X0GKag" oauthToken:@"144604660-cQsJQdrT5vNa48EkoQtAIdZDnG6ERJpU0h1xwEWG" oauthTokenSecret:@"wYKADmdPw7PkXI9y8WJdlNVtw1iLEUDYRuG2olmnUdKzX"];
}

@end
