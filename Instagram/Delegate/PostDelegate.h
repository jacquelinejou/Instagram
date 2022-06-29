//
//  PostDelegate.h
//  Instagram
//
//  Created by jacquelinejou on 6/28/22.
//

#import "Post.h"

#ifndef PostDelegate_h
#define PostDelegate_h

@protocol PostDelegate <NSObject>

- (void)didPost:(Post *)post;

@end

#endif /* PostDelegate_h */
