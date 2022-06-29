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

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, PostDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfPosts;
@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.arrayOfPosts = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.topItem.title = @"Home Feed";
    
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
    }];
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
    Post *post = self.arrayOfPosts[indexPath.row];
    [post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.postImage.image = [UIImage imageNamed:@"placeholder.png"]; // placeholder image
        cell.postImage.image = [UIImage imageWithData:data];
        cell.userInteractionEnabled = YES;
    }];
    cell.captionLabel.text = post.caption;
    cell.post = post;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (void)didPost:(Post *)post {
    // construct query
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
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navController = [segue destinationViewController];
    ComposeViewController *composeViewController = (ComposeViewController *)navController.topViewController;
    // Third step, set the delegate property
    composeViewController.delegate = self;
}

@end
