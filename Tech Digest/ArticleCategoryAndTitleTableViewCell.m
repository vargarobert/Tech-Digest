//
//  ArticleCategoryAndTitleTableViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 24/09/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleCategoryAndTitleTableViewCell.h"
#import "FontAwesomeKit/FAKIonIcons.h"

@interface ArticleCategoryAndTitleTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *shareView;

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
    
    //share icon button
    FAKIonIcons *shareIcon = [FAKIonIcons androidShareAltIconWithSize:22];
    [shareIcon addAttribute:NSForegroundColorAttributeName value:color];
    UIImage *shareIconImage = [shareIcon imageWithSize:CGSizeMake(22, 22)];
    self.shareButton.tintColor = color;
    self.shareButton.frame = CGRectMake(0, 0, shareIconImage.size.width, shareIconImage.size.height);
    [self.shareButton setImage:shareIconImage forState:UIControlStateNormal];
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
    
    
    //SHARE
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareButton.contentMode = UIViewContentModeScaleAspectFill;
    self.shareView.backgroundColor = [UIColor clearColor];
    [self.shareView addSubview:self.shareButton];

    
    self.clipsToBounds = YES;
}



@end
