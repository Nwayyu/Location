//
//  ViewController.h
//  Location
//
//  Created by Nway Yu Hlaing on 21/2/16.
//
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Bolts/Bolts.h>
#import "MapViewViewController.h"
@interface ViewController : UIViewController<FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property NSUserDefaults *Existingrecord;
@end

