//
//  CategoryColors.m
//  Tech Digest
//
//  Created by Robert Varga on 15/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "CategoryColors.h"
#import <ChameleonFramework/Chameleon.h>

@implementation CategoryColors

NSDictionary *inventory;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}


+ (void)initialize {
    if(!inventory)
        inventory = @{
                       @"MOBILE" : [UIColor colorWithHexString:@"1486f9"], //blue
                       @"SECURITY@" : [UIColor flatNavyBlueColor],
                       @"STARTUPS" : [UIColor flatPurpleColorDark],
                       @"GAMING" : [UIColor colorWithHexString:@"F0B80C"],//yellow
                       @"INTERNET" : [UIColor flatGreenColorDark],
                       @"BUSINESS IT" : [UIColor flatTealColor],
                       @"SOFTWARE" : [UIColor flatRedColor],
                       @"INFRASTRUCTURE" : [UIColor flatPlumColor],
                       @"GADGETS" : [UIColor flatOrangeColor]
                       };
}

+ (UIColor *)getCategoryColor:(NSString *)category {

    for (id key in inventory) {
        
        if( [key caseInsensitiveCompare:category] == NSOrderedSame ) {
            //reuturn UIColor for cateogry
            return inventory[key];
        }
        
    }

    //reuturn default UIColor
    return [UIColor blackColor];
}




@end
