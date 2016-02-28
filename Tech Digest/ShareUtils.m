//
//  ShareUtils.m
//  Tech Digest
//
//  Created by Robert Varga on 26/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ShareUtils.h"

@implementation ShareUtils


+ (UIActivityViewController*)shareText:(NSString *)text withUrl:(NSString *)url
{
    //share
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    [sharingItems addObject:@"\nvia TECH DIGEST for iOS - http://apple.co/1XZxGcb"];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    //exclude share options
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact];
    //return share view
    return activityController;
}

@end
