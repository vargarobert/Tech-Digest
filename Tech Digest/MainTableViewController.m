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

#import "CategoryColors.h"
//time circle view
#import "TimeIndicatorView.h"

#import <Masonry/Masonry.h>
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
#import <Parse/Parse.h>
//Article Model
#import "PFArticle.h"
//Parse utils
#import "PFUtils.h"
//HTTP codes
#import "FTHTTPCodes.h"




typedef void (^PFResultBlock)(int result);


@interface MainTableViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) BOOL firstLoadDone;
@property (nonatomic,strong) NSDate *today;
@property (nonatomic,strong) NSArray *articleData;

@end


@implementation MainTableViewController
{
    TimeIndicatorView* _timeView;
}

const CGFloat kTableHeaderHeight = 40.0;
static NSString* cellIdentifierFirst = @"cellIdentifierFirst";
static NSString* cellIdentifierStandard = @"cellIdentifierStandard";

- (id)init {
    if (self = [super init]) {
        self.firstLoadDone = NO;
        self.articleData = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup table
    [self tableSetup];
    
    //PULL to REFRESH
    [self pullToRefresh];
    
    //get articles and set today's date
    //get today's DATE for current location with time 00:00:00
    self.today = [self resetTimeFromDateByLocation:[NSDate date]];
    //start getting new data through pull to refresh
    [self.tableView ins_beginPullToRefresh];

}


#pragma mark TEST PARSE

- (void)getDataForDate:(NSDate*)today {
    //prepare yesterday date incase no data for today
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                 value:-1
                                                                toDate:today
                                                               options:0];


    //GET
    [self _getArticles:^(int result) {
        if (result==HTTPCode204NoContent) {
            //NO results
            //get date -1
            [self getDataForDate:yesterday];
        } else {
            //reload table data only if new data
            if (result==HTTPCode200OK) {
                //YES results
                NSLog(@"Retrieved %lu data.", (unsigned long)self.articleData.count);
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            }
            //stop refresh spinner
            [self.tableView ins_endPullToRefresh];
            //first load occured
            self.firstLoadDone = YES;
            //reload table background for an empty table case
            [self.tableView reloadEmptyDataSet];
        }
        
    } forDate:today];

}


- (void)_getArticles:(PFResultBlock)resultBlock forDate:(NSDate*)today {
    
    NSDate *tomorrow = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                value:1
                                                               toDate:today
                                                              options:0];
    
    //query parameters
    PFQuery *query = [PFArticle query];
    [query whereKey:@"batchDate" greaterThanOrEqualTo:today];
    [query whereKey:@"batchDate" lessThan:tomorrow];
    
    
    NSLog(@"%@", today);
    //    NSLog(@"%@", tomorrow);
    
    //begin query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFArticle *object in objects) {
                NSLog(@"%@", object.category.title);
            }
            
            //sucess
            //if there is no previous data or there are query results
            if ( !self.articleData.count || objects.count ) self.articleData = objects;
            
            if (resultBlock) {
                if ( objects.count ) {
                    resultBlock(HTTPCode200OK);
                } else {
                    resultBlock(HTTPCode204NoContent);
                }
            }
            //sucess end
        } else {
            //error
            if (resultBlock) { resultBlock(HTTPCode599NetworkConnectTimeoutErrorUnknown); }
            
            if ([error code] == kPFErrorObjectNotFound) {
                NSLog(@"Uh oh, we couldn't find the object!");
            } else if ([error code] == kPFErrorConnectionFailed) {
                NSLog(@"ROBERT - Uh oh, we couldn't even connect to the Parse Cloud!");
            } else if (error) {
                NSLog(@"Error: %@", [error userInfo][@"error"]);
            }
            //error end
        }
    }];
    
}

- (NSDate*)resetTimeFromDateByLocation:(NSDate*)date{
    //local time zone
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    NSString *tzName = [timeZone abbreviation];
    
    //remove abbreviation
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *clearedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return clearedDate;
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
//        return 9;
    return self.articleData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0)
    {
        return tableView.frame.size.height;
    }
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //dummy data
    NSString *articleCategory = @"";
    switch (indexPath.row) {
        case 0:
            articleCategory = @"mobile";
            break;
        case 1:
            articleCategory = @"gaming";
            break;
        case 2:
            articleCategory = @"security";
            break;
        case 3:
            articleCategory = @"internet";
            break;
        case 4:
            articleCategory = @"startups";
            break;
        case 5:
            articleCategory = @"gadgets";
            break;
        case 6:
            articleCategory = @"software";
            break;
        case 7:
            articleCategory = @"infrastructure";
            break;
        case 8:
            articleCategory = @"business it";
            break;
    }
    articleCategory = [articleCategory uppercaseString];
    //dummy data END
    
    PFArticle *articleObject = self.articleData[indexPath.row];
    UIColor *articleTypeColor = [CategoryColors getCategoryColor: articleObject.category.title ];
    
    
    // ### TOP CELL ###
    if (indexPath.row == 0) {
        MMParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFirst   forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[MMParallaxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        
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
        
        
        return cell;
    }
    
    // ### STANDARD CELL ###
    else {
        MMParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStandard   forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MMParallaxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
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
        if (indexPath.row % 2 == 0 && cell.rowNumber.layer.backgroundColor != articleTypeColor.CGColor) { //something else  in IF to verify if the article was read allready
            [cell markAsRead];
            
            //title longer REMOVE===
//            cell.title.text = @"Android Fans Bomb Apple’s ‘Move to iOS’ Android App With One-Star Reviews Android Fans Bomb Apple’s ‘Move to iOS’ Android App With One-Star ReviewsAndroid Fans Bomb Apple’s ‘Move to iOS’ Android App With One-Star Reviews";
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
    //    self.shyNavBarManager.disable=true;
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
    _timeView.frame = CGRectOffset(_timeView.frame, self.view.frame.size.width - _timeView.frame.size.width+3, 10.0);
}



@end
