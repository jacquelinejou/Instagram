//
//  PostCell.h
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) Post *post;
@end

NS_ASSUME_NONNULL_END
