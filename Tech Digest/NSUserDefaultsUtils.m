//
//  NSUserDefaultsUtils.m
//  Tech Digest
//
//  Created by Robert Varga on 07/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "NSUserDefaultsUtils.h"

@implementation NSUserDefaultsUtils


+(void)markObjectAsRead:(NSString*)objectId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:objectId];
    [prefs synchronize];
}

+(BOOL)isObjectMarkedAsRead:(NSString*)objectId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if( [prefs floatForKey:objectId] )
        return true;
    else
        return false;
}

@end
