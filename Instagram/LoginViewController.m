//
//  LoginViewController.m
//  Instagram
//
//  Created by mattpdl on 7/6/21.
//

#import "LoginViewController.h"
#import "FeedViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (void)loginUser {
    // Get entered user credentials
    PFUser *userToLogin = [PFUser user];
    if ([self setUserCredentials:userToLogin]) {
        
        // Call login function with given credentials
        [PFUser logInWithUsernameInBackground:userToLogin.username password:userToLogin.password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self displayAlert:@"Login Failure" withMessage:@"Please check your user credentials and internet connection and try again."];
            } else {
                NSLog(@"User logged in successfully");
                
                // Display home feed after successful login
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            }
        }];
    }
}

- (void)registerUser {
    // Set new user credentials
    PFUser *newUser = [PFUser user];
    if ([self setUserCredentials:newUser]) {
    
        // Call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self displayAlert:@"User Registration Failure"
                    withMessage:@"This likely means your selected username is taken, or you are not connected to the internet."];
            } else {
                NSLog(@"User registered successfully");
                
                // Manually segue to logged in view
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

- (BOOL)setUserCredentials:(PFUser *)user {
    // Empty credentials given
    if ([self.usernameField.text isEqualToString:@""]) {
        [self displayAlert:@"Empty Username" withMessage:@"Your username cannot be empty."];
        return NO;
    } else if ([self.passwordField.text isEqualToString:@""]) {
        [self displayAlert:@"Empty Password" withMessage:@"Your password cannot be empty."];
        return NO;
    }
    
    else {
        // Set user properties
        user.username = self.usernameField.text;
        user.password = self.passwordField.text;
        return YES;
    }
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
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
} */


@end
