//
//  PostDelegate.h
//  Instagram
//
//  Created by jacquelinejou on 6/28/22.
//

#ifndef PostDelegate_h
#define PostDelegate_h

@protocol PostDelegate <NSObject>

-(void)loadMoreData:(NSInteger)numReloadCells;

@end

#endif /* PostDelegate_h */
