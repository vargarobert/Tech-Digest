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
//navigation swipe
#import <SwipeBack/SwipeBack.h>

//userdefaults utils
#import "NSUserDefaultsUtils.h"
//colors
#import <ChameleonFramework/Chameleon.h>
//nav bar hide
#import "TLYShyNavBarManager.h"
//back button
#import "VBFPopFlatButton.h"
//sliding images
#import "KIImagePager.h"
//category colors
#import "CategoryColors.h"
//SDWebImage with custom activity
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
//full screen photo browser
#import "MWPhotoBrowserCustom.h"

@interface ArticleViewController () <UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UISearchBarDelegate, KIImagePagerDelegate, KIImagePagerDataSource, MWPhotoBrowserDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VBFPopFlatButton *flatRoundedButton;
@property (nonatomic,strong) KIImagePager *imagePager;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSMutableArray *MWPhotos;

@end

@implementation ArticleViewController

static NSString* cellIdentifierArticleCategoryAndTitle = @"cellIdentifierArticleCategoryAndTitle";
static NSString* cellIdentifierArticleStory = @"cellIdentifierArticleStory";
static NSString* cellIdentifierArticleStoryQuote = @"cellIdentifierArticleStoryQuote";
static NSString* cellIdentifierArticleReference = @"cellIdentifierArticleReference";




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self tableSetup];
    [self navigationBarSetup];
    [self tableHeaderViewSetup];

}




#pragma mark - General SETUP

-(void)tableSetup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.shyNavBarManager.scrollView = self.tableView;
    self.tableView.backgroundColor = [UIColor blackColor];

    self.tableView.estimatedRowHeight = 50.0;
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
//    int sections = 2; // title + source
//    
//    sections += _articleObject.descriptions.count; //number of description sections
//    
//    return sections;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = 2; // title + source
    
    rows += _articleObject.descriptions.count;
    rows += _articleObject.quotes.count;

    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //ArticleCategoryAndTitleTableViewCell
    ArticleCategoryAndTitleTableViewCell *articleCategoryAndTitleTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleCategoryAndTitle   forIndexPath:indexPath];
    
    //ArticleStoryTableViewCell
    ArticleStoryTableViewCell *articleStoryTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleStory   forIndexPath:indexPath];
    
    //ArticleStoryQuoteTableViewCell
    ArticleStoryQuoteTableViewCell *articleStoryQuoteTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleStoryQuote   forIndexPath:indexPath];

    //ArticleReferenceTableViewCell
    ArticleReferenceTableViewCell *articleReferenceTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleReference forIndexPath:indexPath];

    
    UIColor *articleTypeColor = [CategoryColors getCategoryColor: _articleObject.category.title ];

    
     if (indexPath.row == 0) {
         
         // ###Content
         //title
         articleCategoryAndTitleTableViewCell.title.text = _articleObject.title;
         //row number and category
         articleCategoryAndTitleTableViewCell.rowNumber.text = _articleOrder;
         articleCategoryAndTitleTableViewCell.category.text = [_articleObject.category.title uppercaseString];
         
         [articleCategoryAndTitleTableViewCell setCategoryColor: articleTypeColor];

        
         return articleCategoryAndTitleTableViewCell;

     } else if (indexPath.row == 1 && _articleObject.descriptions.count >= 1) {
         
         // ###Content
         articleStoryTableViewCell.story.text = _articleObject.descriptions[0];
   
         
         return articleStoryTableViewCell;

     } else if (indexPath.row == 2 && _articleObject.quotes.count >= 1) {
         
         // ###Content
         [articleStoryQuoteTableViewCell setQuote:_articleObject.quotes[0][@"quote"]
              forAuthor:_articleObject.quotes[0][@"author"]];
         
         [articleStoryQuoteTableViewCell setCategoryColor: articleTypeColor];

         return articleStoryQuoteTableViewCell;
         
     } else if ( indexPath.row == 3 && _articleObject.descriptions.count >= 2 ) {
         
         // ###Content
         articleStoryTableViewCell.story.text = _articleObject.descriptions[1];
         
         
         return articleStoryTableViewCell;
         
     } else if (indexPath.row == 4 && _articleObject.quotes.count >= 2) {
         
         // ###Content
         [articleStoryQuoteTableViewCell setQuote:_articleObject.quotes[1][@"quote"]
                                        forAuthor:_articleObject.quotes[1][@"author"]];
         
         [articleStoryQuoteTableViewCell setCategoryColor: articleTypeColor];
         
         return articleStoryQuoteTableViewCell;
         
     } else {

         // ###Content
         [articleReferenceTableViewCell setReference:_articleObject.source[@"title"]];
         [articleReferenceTableViewCell setCategoryColor: articleTypeColor];
         
         return articleReferenceTableViewCell;
     }
    

     
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ArticleReferenceTableViewCell class]])
    {
        //alert view
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Open this in Safari?"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //open in Safari
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_articleObject.source[@"url"]]];
                                                              }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        //deselect cell
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - IMAGES pager + fullscreen (table header)

- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    if (!_images){
        _images = _articleObject.imagesUrls;
    }
    return _images;
}
- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
}
- (void)imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    //open header image full-screen
    
    // Create array of MWPhoto objects
    self.MWPhotos = [NSMutableArray array];
    
    // Add photos
    for(int i=0; i < _images.count; i++) {
        [self.MWPhotos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[_images objectAtIndex:i]]]];
    }

    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowserCustom *browser = [[MWPhotoBrowserCustom alloc] initWithDelegate:self];
    // Set options
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    
    // Present
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowserCustom *)photoBrowser {
    return self.MWPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowserCustom *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.MWPhotos.count) {
        return [self.MWPhotos objectAtIndex:index];
    }
    return nil;
}

//
//- (void)bigButtonTapped:(NSUInteger)index {
//    
////    // Create image info
////    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
////
////    imageInfo.imageURL = [NSURL URLWithString:[_images objectAtIndex:index]];
////
////    imageInfo.referenceRect = _imagePager.frame;
////    imageInfo.referenceView = _imagePager.superview;
////    imageInfo.referenceContentMode = _imagePager.contentMode;
////    imageInfo.referenceCornerRadius = _imagePager.layer.cornerRadius;
////    
////    // Setup view controller
////    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
////                                           initWithImageInfo:imageInfo
////                                           mode:JTSImageViewControllerMode_Image
////                                           backgroundStyle:JTSImageViewControllerBackgroundOption_None];
////    
////    // Present the view controller.
////    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
//
//    
//    
//    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:_images.count];
//    for(int i=0; i < _images.count; i++) {
//        NYTExamplePhoto *tempImage = [[NYTExamplePhoto alloc] init];
//        tempImage.image = nil;
//        [photos addObject:tempImage];
//    }
//
////    for (NSString *url in self.images) {
////        UIImageView *imageView = [[UIImageView alloc] init];
////        [imageView setImageWithURL:[NSURL URLWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
////        
////        NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
////        photo.image = imageView.image;
////
////        [photos addObject:photo];
////    }
//
//    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:[photos objectAtIndex:index]];
//    photosViewController.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    [self presentViewController:photosViewController animated:YES completion:nil];
//    photosViewController.delegate = self;
//
//    [self updateImagesOnPhotosViewController:photosViewController afterDelayWithPhotos:photos];
//
//
//}

// This method simulates previously blank photos loading their images after some time.
//- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        for (NYTExamplePhoto *photo in photos) {
//            if (!photo.image) {
//                NSString *photoUrl = [_images objectAtIndex:[photos indexOfObject:photo]];
//                UIImageView *imageView = [[UIImageView alloc] init];
//            
//                [imageView setImageWithURL:[NSURL URLWithString:photoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    photo.image = image;
//                    [photosViewController updateImageForPhoto:photo];
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//                
//
//            }
//        }
//    });
//}



#pragma mark - View settings

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
    self.navigationController.swipeBackEnabled = YES;

    [self backButonSetup];
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
