//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by jacquelinejou on 6/29/22.
//

#import "PostDetailsViewController.h"
#import "UIKit/UIKit.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *numLikes;
@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.detailPost.author.username;
    self.captionLabel.text = self.detailPost.caption;
    NSData *data = self.detailPost.image.getData;
    self.postImage.image = [UIImage imageWithData:data];
    self.numLikes.text = self.detailPost.likeCount.stringValue;
    NSDate *postTime = self.detailPost.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Configure the input format to parse the date string
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.time.text = [formatter stringFromDate:postTime];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
