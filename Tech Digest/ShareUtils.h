//
//  ShareUtils.h
//  Tech Digest
//
//  Created by Robert Varga on 26/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareUtils : NSObject

+(UIActivityViewController*)shareText:(NSString *)text withUrl:(NSString *)url;

@end
