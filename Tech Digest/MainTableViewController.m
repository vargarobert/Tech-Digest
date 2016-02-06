//
//  MainTableViewController.m
//
//
//  Created by Robert Varga on 12/09/2015.
//
//

#import "MainTableViewController.h"
//Article full view controller
#import "ArticleViewController.h"
#import "MMParallaxCell.h"
//navigation swipe
#import <SwipeBack/SwipeBack.h>
//userdefaults utils
#import "NSUserDefaultsUtils.h"

#import "CategoryColors.h"
//time circle view
#import "TimeIndicatorView.h"

//#import <Masonry/Masonry.h>
//load images async
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
//custom colors
#import <ChameleonFramework/Chameleon.h>
//pull to refresh
#import "UIScrollView+INSPullToRefresh.h"
//pull to refersh animation
#import "INSAnimatable.h"
#import "INSTwitterPullToRefresh.h"
//empty data set
#import "UIScrollView+EmptyDataSet.h"
//fonts awesome
#import "FontAwesomeKit/FAKFontAwesome.h"
//PARSE
//Article Model
#import "PFArticle.h"
//Parse utils
#import "ParseAPI.h"
//HTTP codes
#import "FTHTTPCodes.h"
//Date utils
#import "DateUtils.h"
//alert view
#import "RKDropdownAlert.h"


typedef void (^PFResultBlock)(int result);


@interface MainTableViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

//first load attempt done, to be used to display info when empty table
@property (nonatomic, assign) BOOL firstLoadDone;
//today's date for location of the user
@property (nonatomic,strong) NSDate *today;
//article data downloaded from Parse
@property (nonatomic,strong) NSArray *articleData;
//index of cell selected, to be used when swipe back from ArticleView
@property (nonatomic,strong) NSIndexPath *indexPathSelected;

@end


@implementation MainTableViewController
{
    TimeIndicatorView* _timeView;
}

static NSString* cellIdentifierFirst = @"cellIdentifierFirst";
static NSString* cellIdentifierStandard = @"cellIdentifierStandard";

- (id)init {
    if (self = [super init]) {
        //        self.firstLoadDone = NO;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup table
    [self tableSetup];
    
    //PULL to REFRESH setup
    [self pullToRefresh];
    
    //get today's DATE for current location with time 00:00:00
    self.today = [DateUtils resetTimeFromDateByLocation:[NSDate date]];
    
    //GET ARTICLES data
    [self getInitialDataOnViewDidLoad];
}


#pragma mark GET PARSE DATA

- (void)getInitialDataOnViewDidLoad {
    // 1. get data for today only from LOCALDATASTORE
    [ParseAPI _getArticlesFromDatastoreForDate:self.today completion:^(NSArray *array) {
        //in the case of local data store populate only if it exists for temporary purposes. Ultimately rely on network as a master source
        if (array.count) {
            self.articleData = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            //first load occured
            self.firstLoadDone = YES;
            //reload table background for an empty table case
            [self.tableView reloadEmptyDataSet];
//            NSLog(@"local data count: %lu",(unsigned long)array.count);
        } else {
            //no cache data for today
            // 2. start getting new data through pull to refresh from CLOUD
            [self.tableView ins_beginPullToRefresh];
        }
    }];
}

- (void)pullToRefresh {
    //get new data selector
    [self.tableView ins_addPullToRefreshWithHeight:70.0 handler:^(UIScrollView *scrollView) {
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //get data from PARSE
            [self getDataForDate:self.today];
        });
    }];
    
    //table Pull To Refresh
    CGRect defaultFrame = CGRectMake(0, 0, 50, 50);
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSTwitterPullToRefresh alloc] initWithFrame:defaultFrame];
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)getDataForDate:(NSDate*)today {
    //prepare yesterday date incase no data for today
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                 value:-1
                                                                toDate:today
                                                               options:0];
    
    [ParseAPI _getArticlesFromCloudForDate:today completion:^(int HTTPCode, NSArray *array) {
        if (HTTPCode==HTTPCode204NoContent) {
            //NO results
            //get date -1
            [self getDataForDate:yesterday];
        } else {
            //reload table data only if new data
            if (HTTPCode==HTTPCode200OK) {
                //YES results populate with new data
                self.articleData = array;
                //                NSLog(@"Retrieved %lu data.", (unsigned long)self.articleData.count);
                //save new data to localdatastore
                [PFObject pinAllInBackground:self.articleData];
                //reload table
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            }
            //stop refresh spinner
            [self.tableView ins_endPullToRefresh];
            //first load occured
            self.firstLoadDone = YES;
            //reload table background for an empty table case
            [self.tableView reloadEmptyDataSet];
        }
    }];
    
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.articleData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //first row cell height (full screen)
    if(indexPath.row==0)
    {
        return tableView.frame.size.height;
    }
    
    //standard cell height
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFArticle *articleObject = self.articleData[indexPath.row];
    UIColor *articleTypeColor = [CategoryColors getCategoryColor: articleObject.category.title];
    
    
    // ### TOP CELL ###
    if (indexPath.row == 0) {
        MMParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFirst];
        
        
        // ###Content
        //TIME label setup
        if( self.articleData.count ) {
            _timeView = [[TimeIndicatorView alloc] init:(NSDate*)articleObject.batchDate]; //today should be fetched from batchDate
            [cell addSubview:_timeView];
        }
        
        
        //title
        cell.title.text = articleObject.title;
        
        //row number and category
        cell.rowNumber.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
        cell.category.text = [articleObject.category.title uppercaseString];
        
        
        //image
        [cell.parallaxImage setImageWithURL:[NSURL URLWithString:articleObject.mainImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

        //color set based on article
        [cell setCategoryColor: articleTypeColor];
        _timeView.color = articleTypeColor;
        
        //mark as read
        if ([NSUserDefaultsUtils isObjectMarkedAsTrue:articleObject.objectId]) {
            [cell markAsRead];
        }
        
        
        return cell;
    }
    
    // ### STANDARD CELL ###
    else {
        MMParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStandard];
        
        
        //        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        //        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        
        // ###Content
        
        //title
        cell.title.text = articleObject.title;
        //row number and category
        cell.rowNumber.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
        cell.category.text = [articleObject.category.title uppercaseString];
        
        //image
        [cell.parallaxImage setImageWithURL:[NSURL URLWithString:articleObject.mainImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        
        //color set based on article
        [cell setCategoryColor: articleTypeColor];
        
        
        //mark as read
        if ([NSUserDefaultsUtils isObjectMarkedAsTrue:articleObject.objectId]) {
            [cell markAsRead];
        }
        
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showArticle" sender:self];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // SEPARATOR between cells
    static NSInteger const separatorTag = 123;
    UIView* separatorLineView = (UIView *)[cell.contentView viewWithTag:separatorTag];
    if(!separatorLineView && indexPath.row !=0 )
    {
        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0f)];
        separatorLineView.tag = separatorTag;
        separatorLineView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:separatorLineView];
    }
    
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showArticle"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ArticleViewController *articleViewController = (ArticleViewController *)segue.destinationViewController;
        articleViewController.articleObject = [self.articleData objectAtIndex:indexPath.row];
        articleViewController.articleOrder = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        
        //save index path for later when the view loads again to mark the cell as read
        _indexPathSelected = indexPath;
    }
}



#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    //first load
    if( !self.firstLoadDone ) return NULL;
    
    //any load
    FAKFontAwesome *icon = [FAKFontAwesome exclamationIconWithSize:40];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    return [icon imageWithSize:CGSizeMake(50, 50)];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    
    if( !self.firstLoadDone ) {
        text = @"Loading";
    } else {
        //any load
        text = @"No Data Is Currently Available";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    //first load
    if( !self.firstLoadDone ) return NULL;
    
    //any load
    NSString *text = @"Please pull down to refresh.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -self.tableView.tableHeaderView.frame.size.height/2.0f;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor blackColor];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    //if empty table return YES, otherwise return NO
    if (self.articleData.count) {
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}



#pragma mark - VIEW settings

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    self.navigationController.swipeBackEnabled = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    //marking cell ARTICLE as READ with ANIMATION
    if(_indexPathSelected) {
        NSString *objectId = [[self.articleData objectAtIndex:_indexPathSelected.row] objectId];
        //object was never marked, do ANIMATION mark
        if(! [NSUserDefaultsUtils isObjectMarkedAsTrue:objectId] ) {
            [NSUserDefaultsUtils markObjectAsTrue:objectId];
            MMParallaxCell *cell = [self.tableView cellForRowAtIndexPath:_indexPathSelected];
            [cell markAsReadAnimated];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc {
    [self.tableView ins_removeInfinityScroll];
    [self.tableView ins_removePullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self updateTimeIndicatorFrame];
}


#pragma mark - General settings

-(void)tableSetup {
    //tableView setup
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //nibs and cell identifiers
    [self.tableView registerNib:[UINib nibWithNibName:@"ParallaxCell" bundle:nil] forCellReuseIdentifier:cellIdentifierFirst];
    [self.tableView registerNib:[UINib nibWithNibName:@"ParallaxCell" bundle:nil] forCellReuseIdentifier:cellIdentifierStandard];
}

- (void)updateTimeIndicatorFrame {
    [_timeView updateSize];
    _timeView.frame = CGRectOffset(_timeView.frame, self.view.frame.size.width - _timeView.frame.size.width, 10);
}



@end
