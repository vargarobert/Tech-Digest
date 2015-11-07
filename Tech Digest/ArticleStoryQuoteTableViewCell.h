//
//  ArticleStoryQuoteTableViewCell.h
//  Tech Digest
//
//  Created by Robert Varga on 15/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleStoryQuoteTableViewCell : UITableViewCell

- (void)setQuote:(NSString *)quote forAuthor:(NSString *)author;
- (void)setCategoryColor:(UIColor *)color;

@end
