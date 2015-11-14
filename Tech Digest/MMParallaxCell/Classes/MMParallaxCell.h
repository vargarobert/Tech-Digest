//
//  MMParallaxCell.h
//  MMParallaxCell
//
//  Created by Ralph Li on 3/27/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RoundedRectLabel.h"
#import "InsetUILabel.h"

@interface MMParallaxCell : UITableViewCell

@property (nonatomic, strong) UIImageView *parallaxImage;

@property (nonatomic, assign) CGFloat parallaxRatio; //ratio of cell height, should between [1.0f, 2.0f], default is 1.5f;



@property (weak, nonatomic) IBOutlet UILabel *title;


@property (weak, nonatomic) IBOutlet UILabel *rowNumber;
@property (weak, nonatomic) IBOutlet InsetUILabel *category;
-(void) setCategoryColor:(UIColor *) color;
-(void) markAsRead;
- (void) markAsReadAnimated;

@property (nonatomic, strong) CAShapeLayer *circleLayer;




@end
