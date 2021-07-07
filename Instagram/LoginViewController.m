//
//  LoginViewController.m
//  Instagram
//
//  Created by mattpdl on 7/6/21.
//

#import "LoginViewController.h"
#import "FeedViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (nonatomic, strong) PFUser *user;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)loginUser {
    // Get entered user credentials
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // Call login function with given credentials
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self displayAlert:@"Login Error" withMessage:@"Please check your user credentials and internet connection and try again."];
        } else {
            NSLog(@"User logged in successfully");
            
            // Display home feed after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)registerUser {
    // Initialize a user object
    PFUser *newUser = [PFUser user];
    [self setUserCredentials:newUser];
    
    // Call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self displayAlert:@"User Registration Error"
                withMessage:@"Your user credentials could not be registered. This likely means your selected username is taken, or you do not have an internet connnection."];
        } else {
            NSLog(@"User registered successfully");
            
            // Manually segue to logged in view
            self.user = newUser;
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)setUserCredentials:(PFUser *)newUser {
    if ([self.usernameField.text isEqualToString:@""]) {
        [self displayAlert:@"Empty Username" withMessage:@"Your username cannot be empty."];
        return;
    } else if ([self.passwordField.text isEqualToString:@""]) {
        [self displayAlert:@"Empty Password" withMessage:@"Your password cannot be empty."];
        return;
    }
    
    // Set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
}

- (void)displayAlert:(NSString *)title withMessage:(NSString *)msg {
    // Create a UIAlertController object
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                               message:msg
                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Create a dismiss action
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:dismissAction];
    
    // Display alert
    [self presentViewController:alert animated:YES completion:^{}];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Pass the logged in user to the home feed view controller
    FeedViewController *feed = [segue destinationViewController];
    feed.user = self.user;
}


@end
