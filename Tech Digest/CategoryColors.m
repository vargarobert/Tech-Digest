//
//  CategoryColors.m
//  Tech Digest
//
//  Created by Robert Varga on 15/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "CategoryColors.h"

@implementation CategoryColors

NSDictionary *categoryColors;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}


+ (void)initialize {
    if(!categoryColors)
        categoryColors = @{
                       @"MOBILE" : [UIColor colorWithHexString:@"DE5149"], //red
                       @"SECURITY@" : [UIColor flatNavyBlueColor],
                       @"STARTUPS" : [UIColor flatPurpleColorDark],
                       @"GAMING" : [UIColor colorWithHexString:@"F0B80C"],//yellow
                       @"INTERNET" : [UIColor flatGreenColorDark],
                       @"BUSINESS IT" : [UIColor flatTealColor],
                       @"SOFTWARE" : [UIColor colorWithHexString:@"1486f9"], //blue
                       @"INFRASTRUCTURE" : [UIColor flatPlumColor],
                       @"GADGETS" : [UIColor flatOrangeColor],
                       @"HARDWARE" : [UIColor flatCoffeeColor]
                       };
}

+ (NSDictionary *)getAllCategories {
    return categoryColors;
}


+ (UIColor *)getCategoryColor:(NSString *)category {

    for (id key in categoryColors) {
        
        if( [key caseInsensitiveCompare:category] == NSOrderedSame ) {
            //reuturn UIColor for cateogry
            return categoryColors[key];
        }
        
    }

    //reuturn default UIColor
    return [UIColor blackColor];
}

+ (UIColor *)getTwitterColor {
    return [UIColor colorWithHexString:@"00aced"];
}




@end
