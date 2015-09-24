//
//  ViewController.m
//  Tech Digest
//
//  Created by Robert Varga on 12/09/2015.
//  Copyright (c) 2015 Robert Varga. All rights reserved.
//

#import "ViewController.h"
#import "JDFPeekabooCoordinator.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;

@end



@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //transparet NAV BAR
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    //hide nav bar
//    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
//    self.scrollCoordinator.scrollView = self.scrollView;
//    self.scrollCoordinator.topView = self.navigationController.navigationBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    

}


@end
