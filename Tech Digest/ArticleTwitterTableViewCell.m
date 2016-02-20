//
//  ArticleTwitterTableViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 27/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleTwitterTableViewCell.h"

//UICollectionView cell for twitter
#import "TwitterCollectionViewCell.h"

//collectionView sticky layout
#import "UICollectionViewFlowLayoutCenterItem.h"

//empty data set
#import "UIScrollView+EmptyDataSet.h"
//colors
#import "CategoryColors.h"//icons
#import "FontAwesomeKit/FAKFontAwesome.h"
//twitter
#import "TwitterAPI.h"


@interface ArticleTwitterTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TTTAttributedLabelDelegate>

//twitter data
@property (nonatomic,strong) NSArray *twitterArticleRelatedObjects;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation ArticleTwitterTableViewCell


- (void)awakeFromNib {
    // Register the colleciton cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TwitterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    //Delegates
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}


//setter
-(void)setTwitterKeywords:(NSString *)twitterKeywords {
    _twitterKeywords = twitterKeywords;
    
    //fetch tweets if none exist
    if (!self.twitterArticleRelatedObjects) {
        [self getSearchTweetsWithResultType:@"popular"];
    }
}

-(void)getSearchTweetsWithResultType:(NSString*)resultType {
    [[TwitterAPI twitterAPIWithOAuth] getSearchTweetsWithQuery:_twitterKeywords
                                                       geocode:nil
                                                          lang:nil
                                                        locale:nil
                                                    resultType:resultType
                                                         count:@"8"
                                                         until:nil
                                                       sinceID:nil
                                                         maxID:nil
                                               includeEntities:nil
                                                      callback:nil
                                                  successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                                      //NSLog(@"-- success, more to come: %@, %@", searchMetadata, statuses);
                                                      //NSLog(@"%lu %@",(unsigned long)statuses.count, resultType);
                                                      //if no popular results found or not enough
                                                      if (statuses.count < 5) {
                                                          [self getSearchTweetsWithResultType:nil];
                                                      } else {
                                                          self.twitterArticleRelatedObjects = statuses;
                                                          [self.collectionView reloadData];
                                                      }
                                                  }
                                                    errorBlock:^(NSError *error) {
                                                        //NSLog(@"-- %@", error);
                                                    }];
}

#pragma mark - UICollectionView Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.twitterArticleRelatedObjects.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tweet = [self.twitterArticleRelatedObjects objectAtIndex:indexPath.row];
    [cell setTweetTitle:tweet[@"user"][@"name"] andTweetScreenName:tweet[@"user"][@"screen_name"] andTweetText:tweet[@"text"]];
    
    //enable delegates for text fields
    cell.tweetScreenName.delegate = self;
    cell.tweetText.delegate = self;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tweet = [self.twitterArticleRelatedObjects objectAtIndex:indexPath.row];

    //define
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:tweet[@"user"][@"name"] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //Cancel
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
    //OK
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open in Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //open tweet in Twitter
        NSURL *twitterURL = [NSURL URLWithString: [NSString stringWithFormat:@"twitter://status?id=%@",tweet[@"id"] ]];
        if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
            [[UIApplication sharedApplication] openURL:twitterURL];
        else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://mobile.twitter.com/%@/status/%@",tweet[@"user"][@"screen_name"],tweet[@"id"]] ]];
    }]];
    // Present action sheet.
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    FAKFontAwesome *icon = [FAKFontAwesome twitterIconWithSize:30];
    [icon addAttribute:NSForegroundColorAttributeName value:[CategoryColors getTwitterColor]];

    return [icon imageWithSize:CGSizeMake(30, 30)];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Looking for tweets...";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[CategoryColors getTwitterColor]};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    //if empty return YES, otherwise return NO
    if (self.twitterArticleRelatedObjects.count) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    //define
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[url absoluteString] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //Cancel
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
    //OK
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Link in Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //open URL in Safari
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
    }]];
    // Present action sheet.
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:actionSheet animated:YES completion:nil];
}

@end
