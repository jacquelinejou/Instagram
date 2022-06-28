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
#import "Post.h"
#import "ComposeViewController.h"

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
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
    NSURL *url = [NSURL URLWithString:post.picture];
    NSString *newImage = [[NSString alloc] initWithContentsOfURL:url
                                           encoding:NSUTF8StringEncoding error:nil];
    cell.postImage.image = [UIImage imageNamed:newImage];
    cell.captionLabel.text = post.caption;
    cell.post = post;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (void)didPost:(nonnull Post *)post {
    [self.arrayOfPosts insertObject:post atIndex:0];
    [self.tableView reloadData];
}

@end
