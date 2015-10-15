//
//  ArticlePicturesViewController.m
//  Tech Digest
//
//  Created by Robert Varga on 10/10/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticlePicturesViewController.h"
//animated buttons
#import "VBFPopFlatButton.h"
//sliding images
#import "KIImagePager.h"

@interface ArticlePicturesViewController () <KIImagePagerDelegate, KIImagePagerDataSource>

@property (nonatomic, strong) VBFPopFlatButton *flatRoundedButton;
@property (nonatomic,strong) KIImagePager *imagePager;

@end

@implementation ArticlePicturesViewController

//- (NSMutableArray*) images {
//    if (!_images) {
//        _images = [[NSMutableArray alloc] init];
//    }
//    return _images;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self navigationBarSetup];
    [self imagePagerSetup];

//
//
//        self.imagePager.scrollView.minimumZoomScale=0.5;
//        self.imagePager.scrollView.maximumZoomScale=6.0;
//        self.imagePager.scrollView.contentSize=CGSizeMake(1280, 960);
//        self.imagePager.scrollView.delegate=self;

    
}

-(void)navigationBarSetup {
    //transparet NAV BAR
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    //SETUP BACK BUTTON
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)
                                                         buttonType:buttonCloseType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    self.flatRoundedButton.roundBackgroundColor = [UIColor blackColor];
    self.flatRoundedButton.lineThickness = 2.2f;
    self.flatRoundedButton.tintColor = [UIColor whiteColor];
    [self.flatRoundedButton addTarget:self
                               action:@selector(popViewController)
                     forControlEvents:UIControlEventTouchUpInside];
    self.flatRoundedButton.bounds = CGRectOffset(self.flatRoundedButton.bounds, -4, -10);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:self.flatRoundedButton];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)imagePagerSetup {
    _imagePager = [[KIImagePager alloc] initWithFrame:self.view.frame];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.imageCounterDisabled = true;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    _imagePager.dataSource = self;
    _imagePager.delegate = self;
    [self.view addSubview:_imagePager];
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return _images;
}
- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFit;
}

- (void)popViewController {
    [self.flatRoundedButton animateToType:buttonBackType];

    // Tell the controller to go back
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
