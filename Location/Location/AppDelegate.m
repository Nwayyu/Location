//
//  AppDelegate.m
//  Location
//
//  Created by Nway Yu Hlaing on 21/2/16.
//
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
 #import <bolts/bolts.h>
#import "MapViewViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FBSDKLoginButton class];
       [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
        _Existingrecord=[[NSUserDefaults alloc] init];
    if ([FBSDKAccessToken currentAccessToken])
    {
        
        NSLog(@"Token is available");
       
        
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                          bundle: nil];
                 UINavigationController *navController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"NavigationMap"];
                 
                 MapViewViewController *viewcontroller = [[navController viewControllers]objectAtIndex:0];
        viewcontroller.result = [_Existingrecord objectForKey:@"result"];
        NSLog(@"result %@", [_Existingrecord objectForKey:@"result"]);
                 self.window.rootViewController = navController;
                 
                 
      
    }
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}


-(void)fetchUserInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"Token is available");
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"first_name,last_name,email,gender,birthday,interested_in" forKey:@"fields"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                          bundle: nil];
                 UINavigationController *navController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"NavigationMap"];
            
                 MapViewViewController *viewcontroller = [[navController viewControllers]objectAtIndex:0];
                 viewcontroller.result = result;
                 self.window.rootViewController = navController;
                
                 
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        
        NSLog(@"User is not Logged in");
    }
}

@end
