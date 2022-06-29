//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "PostDelegate.h"
#import "Post.h"
#import "ComposeViewController.h"
#import "InfiniteScrollViewController.h"
#import "PostDetailsViewController.h"
#import "TableCell.h"

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, PostDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfPosts;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (nonatomic, strong) InfiniteScrollActivityView* loadingMoreView;
@end

@implementation HomeFeedViewController
NSArray *data;
NSString *CellIdentifier = @"TableViewCell";
NSString *HeaderViewIdentifier = @"TableViewHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.arrayOfPosts = [[NSMutableArray alloc] init];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
    
    self.navigationController.navigationBar.topItem.title = @"Home Feed";
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // load posts
    [self loadMoreData:20];
    
    // Set up Infinite Scroll loading indicator
    self.isMoreDataLoading = false;
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TableCell"];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        mySceneDelegate.window.rootViewController = loginViewController;
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.section];
    [post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.postImage.image = [UIImage imageNamed:@"placeholder.png"]; // placeholder image
        cell.postImage.image = [UIImage imageWithData:data];
        cell.userInteractionEnabled = YES;
    }];
    cell.captionLabel.text = post.caption;
    cell.post = post;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    // load posts
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = (NSMutableArray *)posts;
            [self.tableView reloadData];
        }
        // Tell the refreshControl to stop spinning
        [refreshControl endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            [self loadMoreData:[self.arrayOfPosts count] + 20];
        }
    }
}

-(void)loadMoreData:(NSInteger)numReloadCells {
    // load posts
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = numReloadCells;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = (NSMutableArray *)posts;
            [self.tableView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.arrayOfPosts count]){
        [self loadMoreData:[self.arrayOfPosts count] + 20];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayOfPosts.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableCell *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableCell"];
    Post *post = self.arrayOfPosts[section];
    header.usernameLabel.text = post.author.username;
    NSDate *postTime = post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Configure the input format to parse the date string
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    header.timeLabel.text = [formatter stringFromDate:postTime];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ComposeView"]) {
        UINavigationController *navController = [segue destinationViewController];
        ComposeViewController *composeViewController = (ComposeViewController *)navController.topViewController;
        // Third step, set the delegate property
        composeViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"PostDetails"]) {
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        Post *dataToPass = self.arrayOfPosts[myIndexPath.row];
        PostDetailsViewController *detailVC = [segue destinationViewController];
        detailVC.detailPost = dataToPass;
    }
}

@end
