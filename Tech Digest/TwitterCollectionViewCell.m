//
//  TwitterCollectionViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 30/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "TwitterCollectionViewCell.h"
//colors
#import <ChameleonFramework/Chameleon.h>
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
    self.tweetViewBorder.layer.borderColor = [UIColor colorWithHexString:@"00aced"].CGColor;
    self.tweetViewBorder.layer.borderWidth = 1.0f;
    
    //icon
    FAKFontAwesome *icon = [FAKFontAwesome twitterIconWithSize:15];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aced"]];
    UIImage *iconImage = [icon imageWithSize:CGSizeMake(15, 15)];
    self.tweetIcon.contentMode = UIViewContentModeLeft;
    self.tweetIcon.image = iconImage;
    
    //title
    self.tweetTitle.text = @"Test tweet to see how long is text";
    
    //text
    self.tweetText.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"00aced"],
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    self.tweetText.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"00aced"],
                                            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    _tweetText.enabledTextCheckingTypes = NSTextCheckingTypeLink;

    //screen name
    self.tweetScreenName.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"00aced"], NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    self.tweetScreenName.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"00aced"],
                                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
}

-(void)twitterTagsCheck:(TTTAttributedLabel*)label {
    NSArray *words = [label.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for(__strong NSString *word in words) {
        NSString *wordURL;
        if ([word hasPrefix:@"."] && [word hasSuffix:@":"]) {
            //fix for when '.@word' is used in twitter text
            word = [word substringFromIndex:1]; //remove first character .
            word = [word substringToIndex:[word length] - 1]; //remove last character :
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
