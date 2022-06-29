//
//  TableCell.m
//  Instagram
//
//  Created by jacquelinejou on 6/29/22.
//

#import "TableCell.h"

@implementation TableCell
-(instancetype) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self customInit];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    return self;
}

-(void) customInit {
    [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

@end
