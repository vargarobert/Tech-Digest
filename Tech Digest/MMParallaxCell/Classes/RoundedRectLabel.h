//
//  RoundedRectLabel.h
//

#import <UIKit/UIKit.h>

@interface CountLabel : UILabel {
	NSInteger cornerRadius;
	UIColor *rectColor;
}

@property (nonatomic) NSInteger cornerRadius;
@property (nonatomic, retain) UIColor *rectColor;

- (void) setBackgroundColor:(UIColor *)color;
- (void) drawRoundedRect:(CGContextRef)c rect:(CGRect)rect radius:(int)corner_radius color:(UIColor *)color;

@end
