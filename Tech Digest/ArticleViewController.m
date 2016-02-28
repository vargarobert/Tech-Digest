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
#import "ArticleTwitterTableViewCell.h"
//#import "TwitterCollectionViewCell.h"

//navigation swipe
#import <SwipeBack/SwipeBack.h>
//userdefaults utils
#import "NSUserDefaultsUtils.h"
//social media utils
#import "ShareUtils.h"
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
//web browser
#import "TOWebViewControllerCustom.h"
//paralax header
#import "UIScrollView+VGParallaxHeader.h"



#define HEADER_HEIGHT 280.0f
#define HEADER_INIT_FRAME CGRectMake(0, 0, self.tableView.frame.size.width, HEADER_HEIGHT)

@interface ArticleViewController () <UITableViewDataSource, UITableViewDelegate, KIImagePagerDelegate, KIImagePagerDataSource, MWPhotoBrowserDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) VBFPopFlatButton *flatRoundedBackButton;

@property (nonatomic,strong) KIImagePager *imagePager;
@property (readwrite, assign) NSUInteger imagePagerIndex;


@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSMutableArray *MWPhotos;

//twitter objects
@property (nonatomic,strong) NSArray *twitterArticleRelatedObjects;


@end

@implementation ArticleViewController

static NSString* cellIdentifierArticleCategoryAndTitle = @"cellIdentifierArticleCategoryAndTitle";
static NSString* cellIdentifierArticleStory = @"cellIdentifierArticleStory";
static NSString* cellIdentifierArticleStoryQuote = @"cellIdentifierArticleStoryQuote";
static NSString* cellIdentifierArticleReference = @"cellIdentifierArticleReference";
static NSString* cellIdentifierArticleTwitter = @"cellIdentifierArticleTwitter";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self tableSetup];
    [self navigationBarSetup];
    [self tableHeaderViewSetup];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //update header position and size
    [scrollView shouldPositionParallaxHeader];
    //update image index of header slide
    _imagePager.imagePagerIndex = _imagePagerIndex;
}

#pragma mark - General SETUP

-(void)tableSetup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.shyNavBarManager.scrollView = self.tableView;
    self.tableView.backgroundColor = [UIColor whiteColor];

    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //nibs and cell identifiers
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCategoryAndTitle" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleCategoryAndTitle];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleStoryTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleStory];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleStoryQuoteTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleStoryQuote];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleReferenceTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleReference];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTwitterTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifierArticleTwitter];
}


-(void)navigationBarSetup {
//    //transparet NAV BAR
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

    //SETUP BACK BUTTON
    [self navButonSetup];
}

- (void)navButonSetup {
    //BACK button
    self.flatRoundedBackButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)
                                                         buttonType:buttonBackType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:NO];
    self.flatRoundedBackButton.roundBackgroundColor = [UIColor blackColor];
    self.flatRoundedBackButton.lineThickness = 2.2f;
    self.flatRoundedBackButton.tintColor = [UIColor whiteColor];
    [self.flatRoundedBackButton addTarget:self
                               action:@selector(popViewController)
                     forControlEvents:UIControlEventTouchUpInside];
    self.flatRoundedBackButton.bounds = CGRectOffset(self.flatRoundedBackButton.bounds, -4, -10);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:self.flatRoundedBackButton];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)tableHeaderViewSetup {

    //setup KIImagePager
    _imagePager = [[KIImagePager alloc] initWithFrame:HEADER_INIT_FRAME];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.backgroundColor = [UIColor blackColor];
    _imagePager.imageCounterDisabled = true;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    _imagePager.dataSource = self;
    _imagePager.delegate = self;

    //add KIImagePager to paralax header
    [self.tableView setParallaxHeaderView:_imagePager
                                      mode:VGParallaxHeaderModeFill
                                    height:HEADER_HEIGHT];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return rows;
    if (section == 0) {
        return 1; //title
    } else if (section == 1) {
        int rows = 0;
        rows += _articleObject.descriptions.count;
        rows += _articleObject.quotes.count;
        return rows;
    } else {
//        if (_twitterArticleRelatedObjects.count) {
            return 2; //twitter + source
//        }
//        return 1; //source
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIColor *articleTypeColor = [CategoryColors getCategoryColor: _articleObject.category.title ];

    
    //###Title
    if (indexPath.section == 0)
    {
        //ArticleCategoryAndTitleTableViewCell
        ArticleCategoryAndTitleTableViewCell *articleCategoryAndTitleTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleCategoryAndTitle   forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            // ###Content
            //title
            articleCategoryAndTitleTableViewCell.title.text = _articleObject.title;
            //row number and category
            articleCategoryAndTitleTableViewCell.rowNumber.text = _articleOrder;
            articleCategoryAndTitleTableViewCell.category.text = [_articleObject.category.title uppercaseString];
            
            [articleCategoryAndTitleTableViewCell setCategoryColor: articleTypeColor];
            
            //share button target
            [articleCategoryAndTitleTableViewCell.shareButton addTarget:self action:@selector(shareArticleAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return articleCategoryAndTitleTableViewCell;
            
        }
    }
    //###Main body
    else if (indexPath.section == 1)
    {
        //ArticleStoryTableViewCell
        ArticleStoryTableViewCell *articleStoryTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleStory   forIndexPath:indexPath];
        
        //ArticleStoryQuoteTableViewCell
        ArticleStoryQuoteTableViewCell *articleStoryQuoteTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleStoryQuote   forIndexPath:indexPath];
        
        if (indexPath.row == 0 && _articleObject.descriptions.count >= 1) {
            
            // ###Content
            articleStoryTableViewCell.story.text = _articleObject.descriptions[0];
            
            
            return articleStoryTableViewCell;
            
        } else if (indexPath.row == 1 && _articleObject.quotes.count >= 1) {
            
            // ###Content
            [articleStoryQuoteTableViewCell setQuote:_articleObject.quotes[0][@"quote"]
                                           forAuthor:_articleObject.quotes[0][@"author"]];
            
            [articleStoryQuoteTableViewCell setCategoryColor: articleTypeColor];
            
            return articleStoryQuoteTableViewCell;
            
        } else if ( indexPath.row == 2 && _articleObject.descriptions.count >= 2 ) {
            
            // ###Content
            articleStoryTableViewCell.story.text = _articleObject.descriptions[1];
            
            
            return articleStoryTableViewCell;
            
        } else if (indexPath.row == 3 && _articleObject.quotes.count >= 2) {
            
            // ###Content
            [articleStoryQuoteTableViewCell setQuote:_articleObject.quotes[1][@"quote"]
                                           forAuthor:_articleObject.quotes[1][@"author"]];
            
            [articleStoryQuoteTableViewCell setCategoryColor: articleTypeColor];
            
            return articleStoryQuoteTableViewCell;
            
        }
    }
    //###Twitter + Source
    else if (indexPath.section == 2)
    {
        //ArticleReferenceTableViewCell
        ArticleReferenceTableViewCell *articleReferenceTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleReference forIndexPath:indexPath];
        
        //ArticleTwitterTableViewCell
        ArticleTwitterTableViewCell *articleTwitterTableViewCell = (ArticleTwitterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierArticleTwitter forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            // ###Content
            articleTwitterTableViewCell.twitterKeywords = _articleObject.twitterKeywords;

            return articleTwitterTableViewCell;
            
        } else {
            
            // ###Content
             [articleReferenceTableViewCell setReference:_articleObject.source[@"title"]];
             [articleReferenceTableViewCell setCategoryColor: articleTypeColor];

             return articleReferenceTableViewCell;
        }
        
    }

    
    return nil;
\
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ArticleReferenceTableViewCell class]])
    {
        //open in internal web browser
        [TOWebViewControllerCustom openModalWebBrowserWithURL:[NSURL URLWithString:_articleObject.source[@"url"]]];
 
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
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    _imagePagerIndex = index;
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


#pragma mark - Share settings

-(void)shareArticleAction:(UIButton *)sender {
    //build share vc
    UIActivityViewController *activityController = [ShareUtils shareText:_articleObject.title withUrl:_articleObject.source[@"url"]];
    //present vc with share data
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - View settings

- (void)popViewController {    
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //remomve nav bar button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.swipeBackEnabled = YES;
    [self navButonSetup];
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
