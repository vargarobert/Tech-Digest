//
//  MMParallaxCell.m
//  MMParallaxCell
//
//  Created by Ralph Li on 3/27/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "MMParallaxCell.h"
#import "HexColors.h"


@interface MMParallaxCell()

@property (nonatomic, strong) UITableView *parentTableView;
@property (strong, nonatomic) UIColor *articleTypeColor;

@end

@implementation MMParallaxCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
	[self setup];
}

- (void) setCategoryColor:(UIColor *)color {
    self.articleTypeColor = color;
    self.rowNumber.layer.borderColor = color.CGColor;
    self.category.layer.backgroundColor = color.CGColor;
    self.circleLayer.strokeColor = color.CGColor;
}

- (void) markAsRead {
    self.rowNumber.layer.backgroundColor = self.articleTypeColor.CGColor;
}


- (void) setup
{
    // Initialization code
    self.contentView.backgroundColor = [UIColor blackColor];

    //circle around the Row Number
//    self.circleLayer = [CAShapeLayer layer]; //self.rowNumber.frame.size.width/2*-1
//    self.circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 0, self.rowNumber.frame.size.height, self.rowNumber.frame.size.height)].CGPath;
//    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
//    self.circleLayer.strokeColor = [UIColor whiteColor].CGColor;
//    self.circleLayer.lineWidth = 1.5f;
//    [self.rowNumber.layer insertSublayer:self.circleLayer atIndex:0];

    
    //ROW number
    self.rowNumber.textColor = [UIColor whiteColor];
    self.rowNumber.layer.borderWidth = 1;

    
    //CATEGORY label
    self.category.textColor = [UIColor whiteColor];
    self.category.layer.cornerRadius = 7;
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
    self.category.edgeInsets = titleInsets;
    
    
    //TITLE
    self.title.textColor = [UIColor whiteColor];
    
    
    //parallax IMAGE
	self.parallaxImage = [UIImageView new];
	[self.contentView addSubview:self.parallaxImage];
	[self.contentView sendSubviewToBack:self.parallaxImage];
	self.parallaxImage.backgroundColor = [UIColor whiteColor];
	self.parallaxImage.contentMode = UIViewContentModeScaleAspectFill;
    //transparent view to dim parallax image
    UIView *blackOverlay = [[UIView alloc] initWithFrame: self.parallaxImage.frame];
    blackOverlay.layer.backgroundColor = [[UIColor blackColor] CGColor];
    blackOverlay.layer.opacity = 0.5;
    blackOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.parallaxImage addSubview: blackOverlay];
    self.parallaxRatio = 1.5f;

    
	self.clipsToBounds = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    
    [self safeRemoveObserver];
    
    UIView *v = newSuperview;
    while ( v )
    {
        if ( [v isKindOfClass:[UITableView class]] )
        {
            self.parentTableView = (UITableView*)v;
            break;
        }
        v = v.superview;
    }
    [self safeAddObserver];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self safeRemoveObserver];
}

- (void)safeAddObserver
{
    if ( self.parentTableView )
    {
        @try
        {
            [self.parentTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        @catch(NSException *exception)
        {
            
        }
    }
}

- (void)safeRemoveObserver
{
    if ( self.parentTableView )
    {
        @try
        {
            [self.parentTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            self.parentTableView = nil;
        }
    }
}

- (void)dealloc
{
    [self safeRemoveObserver];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.parallaxRatio = self.parallaxRatio;
    
//        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];/// change size as you need.
//        separatorLineView.backgroundColor = [UIColor whiteColor];
//        [[self contentView] addSubview:separatorLineView];

    return;
}

- (void)setParallaxRatio:(CGFloat)parallaxRatio
{
    _parallaxRatio = MAX(parallaxRatio, 1.0f);
    _parallaxRatio = MIN(parallaxRatio, 2.0f);
    
    CGRect rect = self.bounds;
    rect.size.height = rect.size.height*parallaxRatio;
    self.parallaxImage.frame = rect;
    
    [self updateParallaxOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"contentOffset"] )
    {
        if ( ![self.parentTableView.visibleCells containsObject:self] || (self.parallaxRatio==1.0f) )
        {
            return;
        }
        
        [self updateParallaxOffset];
    }
}

- (void)updateParallaxOffset
{
    CGFloat contentOffset = self.parentTableView.contentOffset.y;
    
    CGFloat cellOffset = self.frame.origin.y - contentOffset;
    
    CGFloat percent = (cellOffset+self.frame.size.height)/(self.parentTableView.frame.size.height+self.frame.size.height);
    
    CGFloat extraHeight = self.frame.size.height*(self.parallaxRatio-1.0f);
    
    CGRect rect = self.parallaxImage.frame;
    rect.origin.y = -extraHeight*percent;
    self.parallaxImage.frame = rect;
}

@end
