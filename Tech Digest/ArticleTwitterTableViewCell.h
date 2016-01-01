//
//  ArticleTwitterTableViewCell.h
//  Tech Digest
//
//  Created by Robert Varga on 27/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import <UIKit/UIKit.h>


//@interface TwitterCollectionView : UICollectionView
//
//@property (nonatomic, strong) NSIndexPath *indexPath;
//
//@end


static NSString *CollectionViewCellIdentifier = @"TwitterCollectionViewCellIdentifier";


@interface ArticleTwitterTableViewCell : UITableViewCell


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;


@end
