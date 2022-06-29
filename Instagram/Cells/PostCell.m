//
//  PostCell.m
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.postImage.image = nil;
}

@end
