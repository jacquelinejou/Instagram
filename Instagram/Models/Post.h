//
//  Post.h
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *picture;

// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
