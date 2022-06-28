//
//  Post.m
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    // initialize properties
    if (self) {
        self.username = dictionary[@"username"];
        self.caption = dictionary[@"screen_name"];
        self.picture = dictionary[@"profile_image_url_https"];
    }
    return self;
}

@end
