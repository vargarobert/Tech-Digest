//
//  TwitterCollectionViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 30/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "TwitterCollectionViewCell.h"
//colors
#import "CategoryColors.h"

//icons
#import "FontAwesomeKit/FAKFontAwesome.h"
#import "FontAwesomeKit/FAKIonIcons.h"



@implementation TwitterCollectionViewCell

-(void)setTweetTitle:(NSString *)tweetTitle andTweetScreenName:(NSString *)tweetScreenName andTweetText:(NSString *)tweetText {
    //tweetTitle
    _tweetTitle.text = tweetTitle;

    //tweetScreenName
    _tweetScreenName.text = [NSString stringWithFormat:@"@%@",tweetScreenName];
    NSRange range = [_tweetScreenName.text rangeOfString:_tweetScreenName.text];
    [_tweetScreenName addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@",tweetScreenName]] withRange:range];
    
    //tweetText
    _tweetText.text = tweetText;
    [self twitterTagsCheck:_tweetText];

}

- (void)awakeFromNib {
    //border
    self.layer.borderColor = [CategoryColors getTwitterColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    //tweet icon
    FAKFontAwesome *icon = [FAKFontAwesome twitterIconWithSize:15];
    [icon addAttribute:NSForegroundColorAttributeName value:[CategoryColors getTwitterColor]];
    UIImage *iconImage = [icon imageWithSize:CGSizeMake(15, 15)];
    self.tweetIcon.contentMode = UIViewContentModeLeft;
    self.tweetIcon.image = iconImage;
    
    //more icon
    FAKIonIcons *moreIcon = [FAKIonIcons moreIconWithSize:22];
    [moreIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333" withAlpha:0.2]];
    self.tweetMore.contentMode = UIViewContentModeRight;
    self.tweetMore.image = [moreIcon imageWithSize:CGSizeMake(19, 19)];
    
    //title
    self.tweetTitle.text = @"Test tweet to see how long is text";
    
    //text
    self.tweetText.linkAttributes = @{NSForegroundColorAttributeName:[CategoryColors getTwitterColor],
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    self.tweetText.activeLinkAttributes = @{NSForegroundColorAttributeName:[CategoryColors getTwitterColor],
                                            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    _tweetText.enabledTextCheckingTypes = NSTextCheckingTypeLink;

    //screen name
    self.tweetScreenName.linkAttributes = @{NSForegroundColorAttributeName:[CategoryColors getTwitterColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    self.tweetScreenName.activeLinkAttributes = @{NSForegroundColorAttributeName:[CategoryColors getTwitterColor],
                                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
}

-(void)twitterTagsCheck:(TTTAttributedLabel*)label {
    NSArray *words = [label.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for(__strong NSString *word in words) {
        NSString *wordURL;
        if ([word hasPrefix:@"."]) {
            //fix for when '.@word' is used in twitter text
            word = [word substringFromIndex:1]; //remove first character .
            if ([word hasSuffix:@":"]) {
                word = [word substringToIndex:[word length] - 1]; //remove last character :
            }
        }
        if ([word hasPrefix:@"#"])
        {
            wordURL = [NSString stringWithFormat:@"https://twitter.com/hashtag/%@",[word substringFromIndex:1]];
        }
        else if ([word hasPrefix:@"@"])
        {
            wordURL = [NSString stringWithFormat:@"https://twitter.com/%@",[word substringFromIndex:1]];
        }
        //add link to label
        if(wordURL) {
            NSRange range = [label.text rangeOfString:word];
            [label addLinkToURL:[NSURL URLWithString:wordURL] withRange:range];
        }
    }
}

@end
