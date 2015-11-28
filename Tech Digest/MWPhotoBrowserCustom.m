//
//  MYPhotoBrowserCustom.m
//  Tech Digest
//
//  Created by Robert Varga on 24/11/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "MWPhotoBrowserCustom.h"

@interface MWPhotoBrowser ()

- (void)setNavBarAppearance:(BOOL)animated;

@end

@implementation MWPhotoBrowserCustom

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *subviews = [self.view subviews];
    
    for (int i = 0; i < subviews.count; i++)
    {
        UIView *subview = [subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIToolbar class]])
        {
            ((UIToolbar *) subview).barTintColor = [UIColor blueColor]; // the color wanted for the bottom toolbar
        }
    }
}

- (void)setNavBarAppearance:(BOOL)animated
{
    [super setNavBarAppearance:animated];
    //transparent nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

@end
