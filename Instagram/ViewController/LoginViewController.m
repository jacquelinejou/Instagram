//
//  LoginViewController.m
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        [self loginHelper];
    } else {
       [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
           if (error == nil) {
               [self performSegueWithIdentifier:@"loginSegue" sender:nil];
           }
       }];
    }
}

- (IBAction)registerUser:(id)sender {
    // Create user
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        [self loginHelper];
    } else {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
           if (error == nil) {
               [self performSegueWithIdentifier:@"loginSegue" sender:nil];
           }
       }];
    }
}

-(void)loginHelper {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Field" message:@"Please fill in this field." preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.usernameField.text = @"Username";
        self.passwordField.text = @"Password";
    }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

@end
