//
//  ArticleViewController.h
//  Tech Digest
//
//  Created by Robert Varga on 24/09/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <UIKit/UIKit.h>
//Article Model
#import "PFArticle.h"

@interface ArticleViewController : UIViewController

@property (nonatomic,strong) PFArticle *articleObject;
@property (nonatomic,strong) NSString *articleOrder;

@end
