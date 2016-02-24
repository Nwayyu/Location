//
//  MapViewViewController.m
//  Location
//
//  Created by Nway Yu Hlaing on 21/2/16.
//
//

#import "MapViewViewController.h"
#import "ViewController.h"

@interface MapViewViewController (){
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placeMark;
    MKPointAnnotation *myAnnotation;
    CLLocation *currentlocation;
}

@end

@implementation MapViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logout.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:11.0/255 green:150.0/255 blue:246.0/255 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //populate fb data
    if (_result) {
        
        self.firstname.text = [_result objectForKey:@"first_name"] ? [_result objectForKey:@"first_name"] : @"-";
        self.lastname.text = [_result objectForKey:@"last_name"] ? [_result objectForKey:@"last_name"]: @"-" ;
        self.email.text = [_result objectForKey:@"email"] ? [_result objectForKey:@"email"] : @"-";
        self.birthday.text = [_result objectForKey:@"birthday"]? [_result objectForKey:@"birthday"] : @"-";
        self.gender.text = [_result objectForKey:@"gender"]? [_result objectForKey:@"gender"] : @"-";
        NSArray *array = [_result objectForKey:@"interested_in"];
                NSString *interest;
        NSLog(@"result %lu",(unsigned long)array.count);
        if (array.count > 0) {
            for (int i = 0; i < array.count; i++) {
                if (i == 0) {
                    interest = [array objectAtIndex:i];
                }else{
                    interest= [interest stringByAppendingFormat:@" %@ %@", @",", [array objectAtIndex:i]];
                }
            }
            self.interestedin.text = interest;
        }else{
            self.interestedin.text = @"-";
        }

    }

    locationManager = [[CLLocationManager alloc]init];
    myAnnotation = [[MKPointAnnotation alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager setDelegate:self];// whenever we move
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        [locationManager requestAlwaysAuthorization];
        
        }
    [locationManager startUpdatingLocation];
    self.mapView.showsUserLocation=YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    geocoder = [[CLGeocoder alloc] init];
    UIBackgroundTaskIdentifier BackGroundTask = 11111;
    UIApplication  *app = [UIApplication sharedApplication];
    BackGroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
    [app endBackgroundTask:BackGroundTask];}];
    self.mapTypes = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]];
    self.menuTableView.separatorColor = [UIColor clearColor];
}

#pragma mark FB delegate

- (void)loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
              error:	(NSError *)error;
{
    if (!error) {
        
        NSLog(@"Fetched User Information:%@", result);
    }
    else{
        NSLog(@"Fetched User Information:%@", error);
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    [_Existingrecord removeObjectForKey:@"result"];
    NSLog(@"result %@",[_Existingrecord objectForKey:@"result"]);
    UIViewController *vc = [[self.navigationController viewControllers] firstObject];
    
    if([[vc class] isEqual: [ViewController class]])
    {
         [self.navigationController popViewControllerAnimated:YES];
    
    }else{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        UINavigationController *navController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"Navigation"];
         [self presentViewController:navController animated:YES completion:nil];
        
    }
   currentlocation = nil;
}

#pragma mark location delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations lastObject];
    if (currentlocation == nil) {
        geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                placeMark = [placemarks lastObject];
                NSString *address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                     placeMark.subThoroughfare, placeMark.thoroughfare,
                                     placeMark.postalCode, placeMark.locality,
                                     placeMark.administrativeArea,
                                     placeMark.country];
                
                NSLog(@"%@", address);
                [myAnnotation setCoordinate:placeMark.location.coordinate];
                [myAnnotation setTitle:address];
                [self.mapView addAnnotation:myAnnotation];
                currentlocation = location;
           
                
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        }
         ];

    }
    else{
        
        currentlocation = location;

    }
    
    
    
   
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.menuTableView.frame = CGRectMake(CGRectGetMinX(self.menuTableView.frame),
                                          CGRectGetMinY(self.menuTableView.frame),
                                          CGRectGetWidth(self.view.bounds),
                                          MIN(CGRectGetHeight(self.view.bounds) - 48, self.mapTypes.count *44));
   
}

#pragma mark - DROPDOWN VIEW

- (void)showDropDownViewFromDirection:(LMDropdownViewDirection)direction
{
    // Init dropdown view
    if (!self.dropdownView) {
        self.dropdownView = [LMDropdownView dropdownView];
        self.dropdownView.delegate = self;
        
        // Customize Dropdown style
        self.dropdownView.closedScale = 0.85;
        self.dropdownView.blurRadius = 5;
        self.dropdownView.blackMaskAlpha = 0.5;
        self.dropdownView.animationDuration = 0.5;
        self.dropdownView.animationBounceHeight = 2;
    }
    self.dropdownView.direction = direction;
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen]) {
        [self.dropdownView hide];
    }
    else {
        switch (direction) {
            case LMDropdownViewDirectionTop: {
                self.dropdownView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
                
                [self.dropdownView showFromNavigationController:self.navigationController
                                                withContentView:self.menuTableView];
                break;
            }

            default:
                break;
        }
    }
}

- (void)dropdownViewWillShow:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view will show");
}

- (void)dropdownViewDidShow:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view did show");
}

- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view will hide");
}

- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view did hide %ld",(long)self.currentMapTypeIndex.row);
    if (self.currentMapTypeIndex == nil) {
        NSLog(@"Indexpath is nil");
    }else{
        NSString *postal_code = [[self.mapTypes objectAtIndex:self.currentMapTypeIndex.row]valueForKey:@"Postal Code"];
        [self gettinglocation:postal_code];
    }
  

}


#pragma mark - MENU TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mapTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (!cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    }
    
    cell.menuItemLabel.text = [[self.mapTypes objectAtIndex:indexPath.row]valueForKey:@"Name"];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.currentMapTypeIndex = indexPath;
    
    [self.dropdownView hide];
}

#pragma mark - Navigation title button tap
- (IBAction)titleButtonTapped:(id)sender
{
    [self.menuTableView reloadData];
    
    [self showDropDownViewFromDirection:LMDropdownViewDirectionTop];
}

#pragma mark - getting location by postal code

-(void)gettinglocation:(NSString*)postal_code{
    [geocoder geocodeAddressString:postal_code
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (error == nil && [placemarks count] > 0) {
                         placeMark = [placemarks lastObject];
                         NSString *address = [NSString stringWithFormat:@"%@ %@\n%@",
                                              placeMark.postalCode,
                                              placeMark.administrativeArea,
                                              placeMark.country];
                   
                         NSLog(@"%@", address);
                         [myAnnotation setCoordinate:placeMark.location.coordinate];
                         [myAnnotation setTitle:address];
                         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placeMark.location.coordinate, 500, 500);
                         self.mapView.region = region;
                         [self.mapView addAnnotation:myAnnotation];
                         
                     } else {
                         NSLog(@"%@", error.debugDescription);
                     }
                 }];
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
