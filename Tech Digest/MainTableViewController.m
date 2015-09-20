//
//  MainTableViewController.m
//  
//
//  Created by Robert Varga on 12/09/2015.
//
//

#import "MainTableViewController.h"
#import "MMParallaxCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"

@interface MainTableViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@end


@implementation MainTableViewController

const CGFloat kTableHeaderHeight = 40.0;

static NSString* cellIdentifierFirst = @"cellIdentifierFirst";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView = [UITableView new];
//    [self.view addSubview:self.tableView];

//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


    //setup table
    [self tableSetup];
    
    //set view bg colour
    [[UIScrollView appearance] setBackgroundColor:[UIColor colorWithHexString:@"000000"]]; //DE5149

    //table header substitute
//    self.headerView = self.tableView.tableHeaderView;
//    self.tableView.tableHeaderView = nil;
//    [self.tableView addSubview:self.headerView];
//    self.tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
//    self.tableView.contentOffset = CGPointMake(0, -kTableHeaderHeight);
    
    //header separator
//    CGRect sepFrame = CGRectMake(0, self.headerView.frame.size.height-1, self.tableView.frame.size.width, 3);
//    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
//    seperatorView.backgroundColor = [UIColor colorWithHexString:@"3E2D3C"];;
//    [self.headerView addSubview:seperatorView];

}

-(void)tableSetup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"ParallaxCell" bundle:nil] forCellReuseIdentifier:cellIdentifierFirst];
    
}

//- (void)updateHeaderView {
//    CGRect headerRect = CGRectMake(0, -kTableHeaderHeight, self.tableView.bounds.size.width, kTableHeaderHeight);
//    if (self.tableView.contentOffset.y < -kTableHeaderHeight) {
//        headerRect.origin.y = self.tableView.contentOffset.y;
//        headerRect.size.height = -self.tableView.contentOffset.y;
//    }
//    self.headerView.frame = headerRect;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self updateHeaderView];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
//    if(indexPath.row==0)
//    {
//        return tableView.frame.size.height;
//    }
    return 300;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString* cellIdentifierFirst = @"CellIdentifier";
    MMParallaxCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFirst];

    if (cell == nil)
    {
//        cell = [[MMParallaxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierFirst];
        [tableView registerNib:[UINib nibWithNibName:@"ParallaxCell" bundle:nil] forCellReuseIdentifier:cellIdentifierFirst];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFirst];
        cell.parallaxRatio = 1.2f;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //title
    cell.title.text = @"Android Fans Bomb Apple’s ‘Move to iOS’ Android App With One-Star Reviews";
    //row number and category
    cell.rowNumber.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    cell.category.text = @"Security";


    
    //image
    [cell.parallaxImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://lorempixel.com/400/400/technics/%ld/",indexPath.row]]];
    // +  add temp placeholder image

    UIColor *articleTypeColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
            articleTypeColor = [UIColor colorWithHexString:@"5D9CEC"];
            break;
        case 1:
            articleTypeColor = [UIColor colorWithHexString:@"3BAFDA"];
            break;
        case 2:
            articleTypeColor = [UIColor colorWithHexString:@"37BC9B"];
            break;
        case 3:
            articleTypeColor = [UIColor colorWithHexString:@"8CC152"];
            break;
        case 4:
            articleTypeColor = [UIColor colorWithHexString:@"F6BB42"];
            break;
        case 5:
            articleTypeColor = [UIColor colorWithHexString:@"E9573F"];
            break;
        case 6:
            articleTypeColor = [UIColor colorWithHexString:@"DA4453"];
            break;
        case 7:
            articleTypeColor = [UIColor colorWithHexString:@"967ADC"];
            break;
        case 8:
            articleTypeColor = [UIColor colorWithHexString:@"DA4453"];
            break;
    }
    
    //color set based on article
    cell.rowNumber.textColor = articleTypeColor;
    cell.category.textColor = articleTypeColor;
    cell.circleLayer.strokeColor = articleTypeColor.CGColor;
    


    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showArticle" sender:self];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSInteger const separatorTag = 123;
//    UIView* separatorLineView = (UIView *)[cell.contentView viewWithTag:separatorTag];
//    if(!separatorLineView && indexPath.row !=0 )
//    {
//        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];/// change size as you need.
//        separatorLineView.tag = separatorTag;
//        separatorLineView.backgroundColor = [UIColor redColor];
//        [cell.contentView addSubview:separatorLineView];
//    }

    
//    else
//        cell.frame = CGRectMake(0,0,320.0f,250.0f);
//    
//    if (indexPath.row == 2 ) {
//        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];/// change size as you need.
//        separatorLineView.backgroundColor = [UIColor whiteColor];
//        [cell.contentView addSubview:separatorLineView];
//        NSLog(@"%ld",(long)indexPath.row);
//
//    }




//    [self.tableView setSeparatorColor:[UIColor whiteColor]];
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
        //if you need to pass data to the next controller do it here
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
