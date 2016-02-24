//
//  ViewController.m
//  Location
//
//  Created by Nway Yu Hlaing on 21/2/16.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:11.0/255 green:150.0/255 blue:246.0/255 alpha:1]];
    if ([FBSDKAccessToken currentAccessToken])
    {
        [self fetchUserInfo];
    }
    _loginButton.delegate = self;
    
    _loginButton.readPermissions =
    @[@"public_profile", @"email",@"user_birthday",@"user_relationship_details"];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchUserInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
            _Existingrecord=[[NSUserDefaults alloc] init];
        NSLog(@"Token is available");
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"first_name,last_name,email,gender,birthday,interested_in" forKey:@"fields"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
                 
                 [_Existingrecord setValue:result forKey:@"result"];
                 [_Existingrecord synchronize];
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                          bundle: nil];
                 MapViewViewController *mapview = [mainStoryboard instantiateViewControllerWithIdentifier:@"Detail"];
                 mapview.result = result;
                 [self.navigationController pushViewController:mapview animated:YES];
                 
                 
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        
        NSLog(@"User is not Logged in");
    }
}
- (void)loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
error:	(NSError *)error;
{
    if (!error) {
        [self fetchUserInfo];
        NSLog(@"Fetched User Information:%@", result);
    }
    else{
        NSLog(@"Fetched User Information:%@", error);

    }
}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}
@end
