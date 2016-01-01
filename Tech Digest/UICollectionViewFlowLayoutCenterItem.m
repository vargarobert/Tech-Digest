//
//  UICollectionViewFlowLayoutCenterItem.m
//  Tech Digest
//
//  Created by Robert Varga on 30/12/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "UICollectionViewFlowLayoutCenterItem.h"

@implementation UICollectionViewFlowLayoutCenterItem


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5f;
    CGRect proposedRect = self.collectionView.bounds;
    UICollectionViewLayoutAttributes* candidateAttributes;
    for (UICollectionViewLayoutAttributes* attributes in [self layoutAttributesForElementsInRect:proposedRect])
    {
        // == Skip comparison with non-cell items (headers and footers) == //
        if (attributes.representedElementCategory != UICollectionElementCategoryCell)
        {
            continue;
        }
        if(candidateAttributes)
        {
            
            CGFloat a = attributes.center.x - proposedContentOffsetCenterX;
            CGFloat b = candidateAttributes.center.x - proposedContentOffsetCenterX;
            
            if ( fabs(a) < fabs(b) ) {
                candidateAttributes = attributes;
            }
            
        }
        else
        {
            candidateAttributes = attributes;
            continue;
        }
        
    }
    
    // Beautification step , I don't know why it works!
    if(proposedContentOffset.x == -(self.collectionView.contentInset.left)) {
        return proposedContentOffset;
    }

    return CGPointMake(candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f, proposedContentOffset.y);
}


@end
