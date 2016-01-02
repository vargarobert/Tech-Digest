//
//  ArticleTwitterTableViewCell.m
//  Tech Digest
//
//  Created by Robert Varga on 27/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleTwitterTableViewCell.h"
//collectionView sticky layout
#import "UICollectionViewFlowLayoutCenterItem.h"

//@implementation TwitterCollectionView
//
//@end


@interface ArticleTwitterTableViewCell ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation ArticleTwitterTableViewCell




- (void)awakeFromNib {
 
    // Register the colleciton cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TwitterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    //edge insets
    UIEdgeInsets insets = self.collectionView.contentInset;
    //    float value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
    //    self.superview
    float value = 8;
    insets.left = value;
    insets.right = value;
    self.collectionView.contentInset = insets;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
}




- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
//    self.collectionView.indexPath = indexPath;
    
    [self.collectionView reloadData];
}

- (void)dealloc
{

}

@end
