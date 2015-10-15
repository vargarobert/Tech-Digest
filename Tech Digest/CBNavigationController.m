#import "CBNavigationController.h"

@interface CBNavigationController ()
@end

@implementation CBNavigationController
- (void)viewDidLoad
{
//    NSLog(@"%s",__FUNCTION__);
    __weak CBNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    NSLog(@"%s",__FUNCTION__);
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
//    NSLog(@"%s",__FUNCTION__);
    
    // Enable the gesture again once the new controller is shown AND is not the root view controller
    if (viewController == self.viewControllers.firstObject)
    {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
            self.interactivePopGestureRecognizer.enabled = NO;
    }
    else
    {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
            self.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end