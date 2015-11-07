//
//  PDBArticles.h
//  Tech Digest
//
//  Created by Robert Varga on 28/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PFCategory.h"

@interface PFArticle : PFObject<PFSubclassing>


@property (strong, nonatomic) NSString *objectId;

@property (strong, nonatomic) NSString *batchDate;
@property (strong, nonatomic) NSString *order;

@property (strong, nonatomic) PFCategory *category;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *mainImageUrl;
@property (strong, nonatomic) NSArray *imagesUrls;
@property (strong, nonatomic) NSArray *descriptions;
@property (strong, nonatomic) NSArray *quotes;
@property (strong, nonatomic) PFObject *source;


@end
