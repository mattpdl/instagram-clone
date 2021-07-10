//
//  ComposeViewController.m
//  Instagram
//
//  Created by mattpdl on 7/7/21.
//

#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "Post.h"
@import Shimmer;

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (strong, nonatomic) UIImage *userImage;
@property (strong, nonatomic) Post *post;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captionTextView.delegate = self;
}

- (IBAction)didTapCancel:(id)sender {
    // Dismiss modal compose view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    // Add shimmering view to user image
    FBShimmeringView *imageShimmeringView = [[FBShimmeringView alloc] initWithFrame:self.postImageView.frame];
    [self.view addSubview:imageShimmeringView];
    imageShimmeringView.contentView = self.postImageView;
    imageShimmeringView.shimmering = YES;
    
    // Add shimmering view to caption
    FBShimmeringView *captionShimmeringView = [[FBShimmeringView alloc] initWithFrame:self.captionTextView.frame];
    [self.view addSubview:captionShimmeringView];
    captionShimmeringView.contentView = self.captionTextView;
    captionShimmeringView.shimmering = YES;
    
    // Create new post in the backend
    [Post postUserImage:self.userImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        imageShimmeringView.shimmering = NO;
        captionShimmeringView.shimmering = NO;
        
        if (succeeded) {
            NSLog(@"Posted image with caption: %@", self.captionTextView.text);
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
            [self displayAlert:@"Post Submission Failed" withMessage:@"Please check your internet connection and try again later."];
        }
    }];
}

- (IBAction)didTapAdd:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Display image picker
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    // Show placeholder text when no caption has been entered
    if ([self.captionTextView hasText]) {
        [self.placeholderLabel setHidden:YES];
    } else {
        [self.placeholderLabel setHidden:NO];
    }
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *userImage = editedImage ? editedImage : originalImage;
    
    // Resize selected image
    CGFloat height = MIN(userImage.size.height, 2160);
    CGFloat width = MIN(userImage.size.width, 2160);
    self.userImage = [self resizeImage:userImage withSize:CGSizeMake(width, height)];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        // Set image preview in compose view controller
        [self.postImageView setImage:self.userImage];
    }];
}

- (void)displayAlert:(NSString *)title withMessage:(NSString *)msg{
    // Create a UIAlertController object
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                               message:msg
                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Create a dismiss action
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:dismissAction];
    
    // Display alert
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
