//
//  ArticleCategoryAndTitleTableViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 24/09/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleCategoryAndTitleTableViewCell.h"


@interface ArticleCategoryAndTitleTableViewCell()


@end

@implementation ArticleCategoryAndTitleTableViewCell



- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCategoryColor:(UIColor *)color {
    self.rowNumber.layer.backgroundColor = color.CGColor;
    self.rowNumber.layer.borderColor = color.CGColor;
    self.category.layer.backgroundColor = color.CGColor;
}

- (void) setup
{
    // Initialization code
//    self.contentView.backgroundColor = [UIColor blackColor];
    

    //ROW number
    self.rowNumber.textColor = [UIColor whiteColor];
    self.rowNumber.layer.borderWidth = 1;

    
    //CATEGORY label
    self.category.textColor = [UIColor whiteColor];
    self.category.layer.cornerRadius = 7;
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
    self.category.edgeInsets = titleInsets;
    
    
    //TITLE
    self.title.textColor = [UIColor blackColor];
    
    
    self.clipsToBounds = YES;
}



@end
