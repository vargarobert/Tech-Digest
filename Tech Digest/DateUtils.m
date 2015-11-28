//
//  DateUtils.m
//  Tech Digest
//
//  Created by Robert Varga on 24/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils


+ (NSDate*)resetTimeFromDateByLocation:(NSDate*)date{
    //local time zone
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    NSString *tzName = [timeZone abbreviation];
    
    //remove abbreviation
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *clearedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return clearedDate;
}

+ (int)weekdayForDate:(NSDate*)date{
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [currentCalendar components:NSCalendarUnitWeekday fromDate:date];
    return (int)[dateComponents weekday]; // 1 = Sunday, 2 = Monday, etc.
}


@end
