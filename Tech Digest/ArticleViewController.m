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
#import "ArticleStoryQuoteTableViewCell.h"
#import "ArticleReferenceTableViewCell.h"

//pictures controller
//#import "ArticlePicturesViewController.h"

#import <ChameleonFramework/Chameleon.h>
//nav bar hide
#import "TLYShyNavBarManager.h"
//back button
#import "VBFPopFlatButton.h"
//sliding images
#import "KIImagePager.h"
//category colors
#import "CategoryColors.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface ArticleViewController () <UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UISearchBarDelegate, KIImagePagerDelegate, KIImagePagerDataSource, JTSImageViewControllerOptionsDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VBFPopFlatButton *flatRoundedButton;

@property (nonatomic,strong) KIImagePager *imagePager;
@property (nonatomic,strong) NSArray *images;
//@property (nonatomic,strong) NSArray *cellContent;
//@property (nonatomic,strong) NSURL *imgURL;

@end

@implementation ArticleViewController

static NSString* cellIdentifierArticleCategoryAndTitle = @"cellIdentifierArticleCategoryAndTitle";
static NSString* cellIdentifierArticleStory = @"cellIdentifierArticleStory";
static NSString* cellIdentifierArticleStoryQuote = @"cellIdentifierArticleStoryQuote";
static NSString* cellIdentifierArticleReference = @"cellIdentifierArticleReference";


#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    if (!_images){
//        _images = [[NSMutableArray alloc] initWithObjects:
//                   @"http://rack.1.mshcdn.com/media/ZgkyMDE1LzA4LzI0L2IxL3RpbWNvb2suZDFiYjEuanBnCnAJdGh1bWIJOTUweDUzNCMKZQlqcGc/a904b975/aee/tim-cook.jpg",
//                   @"https://cdn0.vox-cdn.com/thumbor/2zXUVPwug-pH5lJ7NVBo_9nr_vw=/800x0/filters:no_upscale()/cdn0.vox-cdn.com/uploads/chorus_asset/file/4099446/alGVuoVYfFpuqK5o.0.jpeg",
//                   @"https://cdn1.vox-cdn.com/uploads/chorus_asset/file/4093926/3D_Touch_Screenshot.0.png",
//                   nil
//                   ];
        _images = _articleObject.imagesUrls;
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
    [self navigationBarSetup];
    [self tableHeaderViewSetup];
    
NSLog(@"%@",self.articleObject.category.title);
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
    self.tableView.backgroundColor = [UIColor blackColor];

    self.tableView.estimatedRowHeight = 500.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //nibs and cell identifiers
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCategoryAndTitle" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleCategoryAndTitle];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleStoryTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleStory];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleStoryQuoteTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleStoryQuote];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleReferenceTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleReference];
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
    [self backButonSetup];
}

- (void)backButonSetup {
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    UIColor *articleTypeColor = [CategoryColors getCategoryColor: _articleObject.category.title ];


     if (indexPath.row == 0) {
         
         ArticleCategoryAndTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleCategoryAndTitle   forIndexPath:indexPath];
         if (cell == nil) {
             cell = [[ArticleCategoryAndTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
         }
         
         // ###Content
         
         //title
         cell.title.text = _articleObject.title;
         //row number and category
         cell.rowNumber.text = _articleOrder;
         cell.category.text = [_articleObject.category.title uppercaseString];
         
         [cell setCategoryColor: articleTypeColor];

        
         return cell;

     } else if (indexPath.row == 1 || indexPath.row == 3 ) {
         
         ArticleStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleStory   forIndexPath:indexPath];
         if (cell == nil) {
             cell = [[ArticleStoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
         }
         
         // ###Content
         
         cell.story.text = _articleObject.descriptions[0];
   
         
         return cell;

     } else if (indexPath.row == 2 ) {
         ArticleStoryQuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleStoryQuote   forIndexPath:indexPath];
         if (cell == nil) {
             cell = [[ArticleStoryQuoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
         }
         
         
         // ###Content

         [cell setQuote:_articleObject.quotes[0][@"quote"]
              forAuthor:_articleObject.quotes[0][@"author"]];
         
         [cell setCategoryColor: articleTypeColor];

         return cell;
         
     } else {
         ArticleReferenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleReference forIndexPath:indexPath];
         if (cell == nil) {
             cell = [[ArticleReferenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
         }
         
         
         // ###Content
         
         [cell setReference:_articleObject.source[@"title"]];
         [cell setCategoryColor: articleTypeColor];
         

         
         return cell;
     }


     
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ArticleReferenceTableViewCell class]])
    {
        [[UIApplication sharedApplication] openURL:_articleObject.source[@"url"]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    //open header image full-screen
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
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];

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
    [self backButonSetup];
//    [self navigationBarSetup];
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
