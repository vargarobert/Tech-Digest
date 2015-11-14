//
//  MMParallaxCell.m
//  MMParallaxCell
//
//  Created by Ralph Li on 3/27/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "MMParallaxCell.h"
#import <ChameleonFramework/Chameleon.h>


@interface MMParallaxCell()

@property (nonatomic, strong) UITableView *parentTableView;
@property (strong, nonatomic) UIColor *articleTypeColor;
@property (strong, nonatomic) UIView *gradientMask;

@end

@implementation MMParallaxCell


- (void)awakeFromNib
{
	[self setup];
}

- (void) setCategoryColor:(UIColor *)color {
    self.articleTypeColor = color;
    self.rowNumber.layer.borderColor = color.CGColor;
    self.rowNumber.layer.backgroundColor = [self.articleTypeColor colorWithAlphaComponent:0.3].CGColor;//[UIColor clearColor].CGColor;
    self.category.layer.backgroundColor = color.CGColor;
    self.circleLayer.strokeColor = color.CGColor;
}

- (void) markAsRead {
    self.rowNumber.layer.backgroundColor = self.articleTypeColor.CGColor;
}

- (void) markAsReadAnimated {
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         self.rowNumber.layer.backgroundColor = self.articleTypeColor.CGColor;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}

- (void) setup
{
    // Initialization code
    self.contentView.backgroundColor = [UIColor blackColor];
    
    
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
	self.parallaxImage.backgroundColor = [UIColor blackColor];
	self.parallaxImage.contentMode = UIViewContentModeScaleAspectFill;
    
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

    //add gradient over the parallax image
    if(!self.gradientMask) {
        NSArray *colors = [NSArray arrayWithObjects:[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.7], [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0], nil];
        self.gradientMask = [[UIView alloc] initWithFrame:self.contentView.frame];
        self.gradientMask.layer.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                                                                         withFrame:self.contentView.frame                                                               andColors:colors].CGColor;
        // add it as a subview
        [self.contentView insertSubview:self.gradientMask atIndex:1];
    }
    
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
