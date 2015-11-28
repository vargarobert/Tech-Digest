//
//  DateUtils.h
//  Tech Digest
//
//  Created by Robert Varga on 24/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject


+ (NSDate*)resetTimeFromDateByLocation:(NSDate*)date;
+ (int)weekdayForDate:(NSDate*)date;


@end
