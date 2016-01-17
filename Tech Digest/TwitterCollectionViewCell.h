//
//  TwitterCollectionViewCell.h
//  Tech Digest
//
//  Created by Robert Varga on 30/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface TwitterCollectionViewCell : UICollectionViewCell

-(void)setTweetTitle:(NSString *)tweetTitle andTweetScreenName:(NSString *)tweetScreenName andTweetText:(NSString *)tweetText;
//Twitter Box outlets
@property (weak, nonatomic) IBOutlet UILabel *tweetTitle;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetScreenName;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetText;

@property (weak, nonatomic) IBOutlet UIImageView *tweetIcon;
@property (weak, nonatomic) IBOutlet UIImageView *tweetMore;

@end
