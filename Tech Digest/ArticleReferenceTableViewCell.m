//
//  ArticleReferenceTableViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 16/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleReferenceTableViewCell.h"
#import "FontAwesomeKit/FAKFontAwesome.h"
#import <ChameleonFramework/Chameleon.h>

@interface ArticleReferenceTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *referenceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *referenceIcon;

@end

@implementation ArticleReferenceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategoryColor:(UIColor *)color {
    FAKFontAwesome *icon = [FAKFontAwesome anchorIconWithSize:15];
    [icon addAttribute:NSForegroundColorAttributeName value:color];
    UIImage *iconImage = [icon imageWithSize:CGSizeMake(15, 15)];
    
    self.referenceIcon.contentMode = UIViewContentModeLeft;
    self.referenceIcon.image = iconImage;
}

- (void)setReference:(NSString *)reference {
    self.referenceLabel.text = [NSString stringWithFormat:@"Source: %@", reference];;
}


@end
