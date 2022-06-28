//
//  PhotoCell.h
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *rightPhoto;
@end

NS_ASSUME_NONNULL_END
