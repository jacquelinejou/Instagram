//
//  TableCell.h
//  Instagram
//
//  Created by jacquelinejou on 6/29/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableCell : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

NS_ASSUME_NONNULL_END
