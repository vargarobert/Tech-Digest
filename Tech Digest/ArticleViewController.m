//
//  ArticleViewController.m
//  Tech Digest
//
//  Created by Robert Varga on 24/09/2015.
//  Copyright © 2015 Robert Varga. All rights reserved.
//

#import "ArticleViewController.h"

#import "ArticleCategoryAndTitleTableViewCell.h"
#import "ArticleStoryTableViewCell.h"

#import "HexColors.h"

@interface ArticleViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ArticleViewController

static NSString* cellIdentifierArticleCategoryAndTitle = @"cellIdentifierArticleCategoryAndTitle";
static NSString* cellIdentifierArticleStory = @"cellIdentifierArticleStory";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self tableSetup];
    [self navigationBarSetup];
}

-(void)tableSetup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    self.navigationController.hidesBarsOnSwipe = true;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.hidesBarsOnSwipe = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
         
         cell.story.text = @"If there's one constant on the consumer tech calendar, it's iPhone reviews day. Happening sometime between the announcement and the release of the latest iPhone, it manifests itself with glowing accounts of the latest Apple smartphone at the top of the page, and irate accusations of Apple-favoring bias in the comments at the bottom. This is as reliable a phenomenon as today's autumnal equinox.\n\nThe funny thing is that everyone's right. Readers are right to claim that the iPhone is treated differently from other smartphones, and reviewers are correct in doing so. Apple makes more in quarterly profit than many of its mobile competitors are worth, and the success and failure of its smartphone plays a large role in shaping the fate of multiple related industries. The iPhone is reviewed like a transcendental entity that's more than just the sum of its metal, plastic, and silicon parts, because that's what it is.\n\nConsider the scale of Apple’s achievement every year. With iPhone hype reaching cosmic proportions every September — and the price never falling — Apple still manages to exceed expectations and maintain some of the highest user satisfaction ratings in the United States. That’s in spite of stringing people along without a large-screened phone until last year, and despite continuing to sell an inadequate 16GB entry-level model today. The only explanation for this pattern, short of a mass delusion on a religion-like global scale, is that Apple provides substantial value to its hundreds of millions of satisfied iPhone buyers. Tech consumers are biased in favor of Apple products.\n\nThe iPhone is ubiquitous and there are many benefits accruing to its users from this omnipresence. iPhone cases and accessories are an industry unto themselves, which has most recently and impressively been highlighted by the DxO One camera. 'Made for iPhone' (MFI) is a mark of pride for peripheral makers, who dive enthusiastically into any new initiative that Apple chooses to embrace. Just witness the ill-fated iPhone game controller movement of 2013: it never had any compelling games that required physical controls, but that didn’t deter eager Apple partners from producing a broad range of weird and wonderful MFI gamepads. They did so — and they’d do it again in a heartbeat — because riding the iPhone’s coattails to sales is now a proven business strategy. Accessory makers are biased in favor of Apple products.\n";
         
         
         return cell;

     }


     
 }


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
