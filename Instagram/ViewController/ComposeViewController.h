//
//  ComposeViewController.h
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "PostDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<PostDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
