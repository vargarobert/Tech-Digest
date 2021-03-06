//
//  CategoryColors.h
//  Tech Digest
//
//  Created by Robert Varga on 15/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>

@interface CategoryColors : UIColor

+ (NSDictionary *)getAllCategories;
+ (UIColor *)getCategoryColor:(NSString *)category;

//particular
+ (UIColor *)getTwitterColor;

@end
