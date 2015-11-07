//
//  ArticleStoryQuoteTableViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 15/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleStoryQuoteTableViewCell.h"

@interface ArticleStoryQuoteTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *quote;
@property (weak, nonatomic) IBOutlet UILabel *quoteAuthor;
@property (weak, nonatomic) IBOutlet UIView *quoteSideBar;

@end

@implementation ArticleStoryQuoteTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuote:(NSString *)quote forAuthor:(NSString *)author {
    self.quote.text = [NSString stringWithFormat:@"\"%@\"", quote];
    self.quoteAuthor.text = [NSString stringWithFormat:@"- %@", author];
}

- (void)setCategoryColor:(UIColor *)color {
    self.quote.textColor = color;
    self.quoteSideBar.backgroundColor = color;
}

@end
