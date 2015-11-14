//
//  NSUserDefaultsUtils.h
//  Tech Digest
//
//  Created by Robert Varga on 07/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultsUtils : NSObject


+(void)markObjectAsRead:(NSString*)objectId;
+(BOOL)isObjectMarkedAsRead:(NSString*)objectId;

@end
