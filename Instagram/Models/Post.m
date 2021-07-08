//
//  Post.m
//  Instagram
//
//  Created by mattpdl on 7/7/21.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic description;
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

@end
