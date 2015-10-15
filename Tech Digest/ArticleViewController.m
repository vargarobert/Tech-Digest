//
//  ArticleViewController.m
//  Tech Digest
//
//  Created by Robert Varga on 24/09/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleViewController.h"

//cells
#import "ArticleCategoryAndTitleTableViewCell.h"
#import "ArticleStoryTableViewCell.h"

//pictures controller
//#import "ArticlePicturesViewController.h"

#import <ChameleonFramework/Chameleon.h>
//nav bar hide
#import "TLYShyNavBarManager.h"
//back button
#import "VBFPopFlatButton.h"
//sliding images
#import "KIImagePager.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface ArticleViewController () <UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UISearchBarDelegate, KIImagePagerDelegate, KIImagePagerDataSource, JTSImageViewControllerOptionsDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VBFPopFlatButton *flatRoundedButton;

@property (nonatomic,strong) KIImagePager *imagePager;
@property (nonatomic,strong) NSMutableArray *images;
//@property (nonatomic,strong) NSArray *cellContent;
//@property (nonatomic,strong) NSURL *imgURL;

@end

@implementation ArticleViewController

static NSString* cellIdentifierArticleCategoryAndTitle = @"cellIdentifierArticleCategoryAndTitle";
static NSString* cellIdentifierArticleStory = @"cellIdentifierArticleStory";

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    if (!_images){
        _images = [[NSMutableArray alloc] initWithObjects:
                   @"http://rack.1.mshcdn.com/media/ZgkyMDE1LzA4LzI0L2IxL3RpbWNvb2suZDFiYjEuanBnCnAJdGh1bWIJOTUweDUzNCMKZQlqcGc/a904b975/aee/tim-cook.jpg",
                   @"https://cdn0.vox-cdn.com/thumbor/2zXUVPwug-pH5lJ7NVBo_9nr_vw=/800x0/filters:no_upscale()/cdn0.vox-cdn.com/uploads/chorus_asset/file/4099446/alGVuoVYfFpuqK5o.0.jpeg",
                   @"https://cdn1.vox-cdn.com/uploads/chorus_asset/file/4093926/3D_Touch_Screenshot.0.png",
                   nil
                   ];
    }
    
    return _images;
}
- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self tableSetup];
//    [self navigationBarSetup];
    [self tableHeaderViewSetup];


    

//    [self.navigationController.interactivePopGestureRecognizer addTarget:self
//                                                                  action:@selector(handlePopGesture:)];
}





//- (void)handlePopGesture:(UIGestureRecognizer *)gesture
//{
//    if (gesture.state == UIGestureRecognizerStateBegan)
//    {
//        // respond to beginning of pop gesture
//        NSLog(@"DAS");
////        self.shyNavBarManager.disable = true;
////        [self.flatRoundedButton animateToType:buttonMenuType];
//
//    }
//
//    // handle other gesture states, if desired
//}


-(void)tableSetup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.shyNavBarManager.scrollView = self.tableView;

    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //nibs and cell identifiers
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCategoryAndTitle" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleCategoryAndTitle];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleStoryTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleStory];
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
                                                         buttonType:buttonBackType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:NO];
    self.flatRoundedButton.roundBackgroundColor = [UIColor blackColor];
    self.flatRoundedButton.lineThickness = 2.2f;
    self.flatRoundedButton.tintColor = [UIColor whiteColor];
    [self.flatRoundedButton addTarget:self
                               action:@selector(popViewController)
                     forControlEvents:UIControlEventTouchUpInside];
    self.flatRoundedButton.bounds = CGRectOffset(self.flatRoundedButton.bounds, -4, -10);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:self.flatRoundedButton];
    self.navigationItem.leftBarButtonItem = backButton;
//    self.bckgLayer.borderColor = self.tintColor.CGColor; self.bckgLayer.borderWidth = 0.7;
}

- (void)tableHeaderViewSetup {
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 280)];
    self.tableView.tableHeaderView = ({
        _imagePager = [[KIImagePager alloc] initWithFrame:self.tableView.tableHeaderView.frame];
        _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _imagePager.imageCounterDisabled = true;
        _imagePager.slideshowShouldCallScrollToDelegate = YES;
        
        _imagePager.dataSource = self;
        _imagePager.delegate = self;
        _imagePager;
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     


     if (indexPath.row == 0) {
         
          ArticleCategoryAndTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleCategoryAndTitle forIndexPath:indexPath];
         
         // ###Content
         
         //title
         cell.title.text = @"Android Fans Bomb Apple’s ‘Move to iOS’ Android App With One-Star Reviews";
         //row number and category
         cell.rowNumber.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
         cell.category.text = [NSString stringWithFormat:@"%@", @"MOBILE"];
         
         [cell setCategoryColor: [UIColor colorWithHexString:@"1486f9"]];

         // cell.title.text = @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions.";
         return cell;

     } else {
         
         ArticleStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleStory forIndexPath:indexPath];
         
         // ###Content
         
         cell.story.text = @"If there's one constant on the consumer tech calendar, it's iPhone reviews day. Happening sometime between the announcement and the release of the latest iPhone, it manifests itself with glowing accounts of the latess.t Apple smartphone at the top of the page, and irate accusations of Apple-favoring bias in the comments at the bottom. This is as reliable a phenomenon as today's autumnal equinox.\n\nThe funny thing is that everyone's right. Readers are right to claim that the iPhone is treated differently from other smartphones, and reviewers are correct in doing so. Apple makes more in quarterly profit than many of its mobile competitors are worth, and the success and failure of its smartphone plays a large role in shaping the fate of multiple related industries. The iPhone is reviewed like a transcendental entity that's more than just the sum of its metal, plastic, and silicon parts, because that's what it is.\n\nConsider the scale of Apple’s achievement every year. With iPhone hype reaching cosmic proportions every September — and the price never falling — Apple still manages to exceed expectations and maintain some of the highest user satisfaction ratings in the United States. That’s in spite of stringing people along without a large-screened phone until last year, and despite continuing to sell an inadequate 16GB entry-level model today. The only explanation for this pattern, short of a mass delusion on a religion-like global scale, is that Apple provides substantial value to its hundreds of millions of satisfied iPhone buyers. Tech consumers are biased in favor of Apple products.\n\nThe iPhone is ubiquitous and there are many benefits accruing to its users from this omnipresence. iPhone cases and accessories are an industry unto themselves, which has most recently and impressively been highlighted by the DxO One camera. 'Made for iPhone' (MFI) is a mark of pride for peripheral makers, who dive enthusiastically into any new initiative that Apple chooses to embrace. Just witness the ill-fated iPhone game controller movement of 2013: it never had any compelling games that required physical controls, but that didn’t deter eager Apple partners from producing a broad range of weird and wonderful MFI gamepads. They did so — and they’d do it again in a heartbeat — because riding the iPhone’s coattails to sales is now a proven business strategy. Accessory makers are biased in favor of Apple product\n";
         
         
         return cell;

     }


     
}


- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
//    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
    
//    [self performSegueWithIdentifier:@"showArticlePictures" sender:self];
    
//    UIView *blankView = [[UIView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
//    blankView.backgroundColor = [UIColor blackColor];
//    blankView.tag = 99;
//    [self.tableView addSubview:blankView];
    
    [self bigButtonTapped:index];
    
}

- (void)bigButtonTapped:(NSUInteger)index {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];

    imageInfo.imageURL = [NSURL URLWithString:[_images objectAtIndex:index]];

    imageInfo.referenceRect = _imagePager.frame;
    imageInfo.referenceView = _imagePager.superview;
    imageInfo.referenceContentMode = _imagePager.contentMode;
    imageInfo.referenceCornerRadius = _imagePager.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    
    // Present the view controller.
//    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    
    [UIView animateWithDuration:2.5f animations:^{
        [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    }];
    
    // modified in source ->
//    static CGFloat const JTSImageViewController_MaxScalingForExpandingOffscreenStyleTransition = 1.0f;
//    static CGFloat const JTSImageViewController_TransitionAnimationDuration = 0;
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showArticlePictures"]) {
//        UINavigationController *navigationController = segue.destinationViewController;
//        ArticlePicturesViewController *articlePicturesViewController =[[navigationController viewControllers]objectAtIndex:0];
//        // Pass data
//        articlePicturesViewController.images = _images;
//    }
//}

- (void)popViewController {    
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.flatRoundedButton animateToType:buttonMenuType];
    //remomve nav bar button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetup];
//    [self.flatRoundedButton animateToType:buttonBackType];
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
