//
//  CETimeView.m
//  TextKitNotepad
//
//  Created by Colin Eberhardt on 20/06/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "TimeIndicatorView.h"
#import <ChameleonFramework/Chameleon.h>
//Date utils
#import "DateUtils.h"

@implementation TimeIndicatorView
{
    UILabel* _label;
}

-(id)init:(NSDate *)date {
    if (self = [super init]) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentRight;
        
        // format and style the date
        NSDateFormatter* format = [NSDateFormatter new];
        [format setDateFormat:@"dd\rMMMM\ryyyy"];
        
        NSMutableString *formattedDate = [[NSMutableString alloc] init];

        //identify if weekend
        int weekday = [DateUtils weekdayForDate:date];
        if(weekday == 1 || weekday == 7)
            [formattedDate appendString:@"weekend\n"];
        
        //date
        [formattedDate appendString:[format stringFromDate:date]];

        
        _label.text = [formattedDate uppercaseString];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;

        
        self.color = [UIColor colorWithHexString:@"000"];
        
        [self addSubview:_label];
    }
    return self;
}


- (void)updateSize {
    
    // size the label based on the font
    _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _label.frame = CGRectMake(0, 0, FLT_MAX, FLT_MAX);
    [_label sizeToFit];
    
    // set the frame to be large enough to accomodate circle that surrounds the text
    float radius = [self radiusToSurroundFrame:_label.frame];
    self.frame = CGRectMake(0, 0, radius*2, radius*2);
    
    // center the label within this circle
    _label.center = self.center;
    
    // offset the center of this view to ... erm ... can I just draw you a picture?
    // You know the story - the designer provides a mock-up with some static data, leaving
    // you to work out the complex calculatins required to accomodate the variability of real-world
    // data. C'est la vie!
    float padding = 5.0f;
    self.center = CGPointMake(self.center.x + _label.frame.origin.x - padding,
                              self.center.y - _label.frame.origin.y + padding);

    //fill circle corner view -right-top
    UIView *fillView = [[UIView alloc] initWithFrame:CGRectMake(radius, 0, radius, radius)];
    fillView.backgroundColor = self.color;
    [self insertSubview:fillView atIndex:0];
}

// calculates the radius of the circle that surrounds the label
- (float) radiusToSurroundFrame:(CGRect)frame {
    return MAX(frame.size.width, frame.size.height) * 0.5 + 20.0f;
}

- (UIBezierPath *)curvePathWithOrigin:(CGPoint)origin {
    return [UIBezierPath bezierPathWithArcCenter:origin
                                          radius:[self radiusToSurroundFrame:_label.frame]
                                      startAngle:-180.0f
                                        endAngle:180.0f
                                       clockwise:YES];
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(ctx, YES);
    UIBezierPath* path = [self curvePathWithOrigin:_label.center];
    
    
//    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
//    pathAnim.toValue = (id)[self curvePathWithOrigin:_label.center];
//    
//    CABasicAnimation* boundsAnim = [CABasicAnimation animationWithKeyPath: @"bounds"];
//    boundsAnim.toValue = [NSValue valueWithCGRect:_label.frame];
//    
//    CAAnimationGroup *anims = [CAAnimationGroup animation];
//    anims.animations = [NSArray arrayWithObjects:pathAnim, boundsAnim, nil];
//    anims.removedOnCompletion = NO;
//    anims.duration = 2.0f;
//    anims.fillMode  = kCAFillModeForwards;
//    [self.layer addAnimation:anims forKey:nil];

    
    
    [self.color setFill];
    
    [path fill];
}

-(void) setNeedsDisplay {
    [self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    [super setNeedsDisplay];
}

@end
