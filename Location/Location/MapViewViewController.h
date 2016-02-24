//
//  MapViewViewController.h
//  Location
//
//  Created by Nway Yu Hlaing on 21/2/16.
//
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <MapKit/MapKit.h>
#import "LMDropdownView.h"
#import "MenuCell.h"
@interface MapViewViewController : UIViewController<FBSDKLoginButtonDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate, LMDropdownViewDelegate>

@property (nonatomic,retain) id result;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *logout;
@property IBOutlet UILabel *firstname;
@property IBOutlet UILabel *lastname;
@property IBOutlet UILabel *email;
@property IBOutlet UILabel *birthday;
@property IBOutlet UILabel *interestedin;
@property IBOutlet UILabel *gender;
@property(strong, nonatomic)IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSArray *mapTypes;
@property (assign, nonatomic) NSIndexPath* currentMapTypeIndex;
@property (strong, nonatomic) LMDropdownView *dropdownView;
@property NSUserDefaults *Existingrecord;
@end
