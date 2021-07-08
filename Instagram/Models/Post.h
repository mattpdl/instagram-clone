//
//  Post.h
//  Instagram
//
//  Created by mattpdl on 7/7/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
