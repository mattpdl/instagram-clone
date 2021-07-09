//
//  PostCell.m
//  Instagram
//
//  Created by mattpdl on 7/9/21.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    // Set username and caption labels
    self.usernameLabel.text = post.author.username;
    self.captionLabel.text = post.caption;
    
    // Display post image
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
}

@end
