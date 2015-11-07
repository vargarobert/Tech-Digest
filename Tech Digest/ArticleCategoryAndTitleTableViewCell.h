//
//  ArticleCategoryAndTitleTableViewCell.h
//  Tech Digest
//
//  Created by Robert Varga on 24/09/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetUILabel.h"

@interface ArticleCategoryAndTitleTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rowNumber;
@property (weak, nonatomic) IBOutlet InsetUILabel *category;

-(void)setCategoryColor:(UIColor *)color;


@end
