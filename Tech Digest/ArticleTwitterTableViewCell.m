//
//  ArticleTwitterTableViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 27/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleTwitterTableViewCell.h"
//colors
#import <ChameleonFramework/Chameleon.h>
//icons
#import "FontAwesomeKit/FAKFontAwesome.h"
#import "FontAwesomeKit/FAKIonIcons.h"

@interface ArticleTwitterTableViewCell ()

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

//Twitter Box outlets
@property (weak, nonatomic) IBOutlet UILabel *tweetTitle;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;

@property (weak, nonatomic) IBOutlet UIView *tweetViewBorder;
@property (weak, nonatomic) IBOutlet UIImageView *tweetIcon;

@end


@implementation ArticleTwitterTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    _swipeView.alignment = SwipeViewAlignmentCenter;
    _swipeView.pagingEnabled = YES;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    
    

}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return 5;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //    if (!view)
    //    {
    //load new item view instance from nib
    //control events are bound to view controller in nib file
    //note that it is only safe to use the reusingView if we return the same nib for each
    //item view, if different items have different contents, ignore the reusingView value
    //    }
    
    view = [[NSBundle mainBundle] loadNibNamed:@"TwitterBox" owner:self options:nil][0];

    self.tweetViewBorder.layer.borderColor = [UIColor colorWithHexString:@"00aced"].CGColor;
    self.tweetViewBorder.layer.borderWidth = 1.0f;
    
    
    FAKFontAwesome *icon = [FAKFontAwesome twitterIconWithSize:15];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aced"]];
    UIImage *iconImage = [icon imageWithSize:CGSizeMake(15, 15)];
    
    self.tweetIcon.contentMode = UIViewContentModeLeft;
    self.tweetIcon.image = iconImage;

    
    self.tweetTitle.text = @"Test tweet to see how long is text";//[_data objectAtIndex:index];
    
    
    return view;
}




- (void)dealloc
{
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
}

@end
