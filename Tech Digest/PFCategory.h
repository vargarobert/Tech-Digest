//
//  PDBArticles.h
//  Tech Digest
//
//  Created by Robert Varga on 28/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PFCategory: PFObject<PFSubclassing>


@property (strong, nonatomic) NSString *objectId;

@property (strong, nonatomic) NSString *title;



@end
