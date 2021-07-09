//
//  PostCell.h
//  Instagram
//
//  Created by mattpdl on 7/9/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

// UI properties
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

// Methods
- (void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
