//
//  MapTotalViewController.m
//  MapCao
//
//  Created by VoHuy on 2020/01/13.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "MapTotalViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "NavigationTop.h"
#import "NavigationBottom.h"
#import "Constains.h"
#import "DrawerMenu.h"
#import "Utils.h"
#import "APIClients.h"

@interface MapTotalViewController () <GMSMapViewDelegate> {
    UIWindow *window;
    UIScrollView *scretchImageView;
    UIButton *checkinBtn;
    GMSMapView *mapView;
    UIView *background;
    UIButton *goBtn;
    UIButton *shareBtn;
    UIImageView *animationView;
    GMSGroundOverlay *anGiang , *baRiaVungTau , *bacKan , *bacLieu , *bacNinh , *benTre , *binhDinh , *binhDuong , *binhPhuoc , *binhthuan , *bacGiang , *caMau , *caoBang , *dakLak , *dakNong , *dienBien , *dongNai , *dongThap , *giaLai , *haGiang , *haNam , *haTinh , *haiDuong , *hauGiang , *hoaBinh , *hungYen , *khanhHoa , *kienGiang , *konTum , *laiChau , *lamDong , *langSon , *laoCai , *longAn , *namDinh , *ngheAn , *ninhBinh , *ninhThuan , *binhThuan , *phuTho , *quangBinh , *quangNam , *quangNgai , *quangTri , *quangNinh , *socTrang , *sonLa , *tayNinh , *thaiBinh , *thaiNguyen , *thanhHoa , *thuaThienHue , *tienGiang , *traVinh , *tuyenGiang , *vinhLong , *vinhPhuc , *yenBai , *phuYen , *canTho , *daNang , *haiPhong , *haNoi , *tpHCM , *daoPhuQuoc , *daoHoangSa , *daoTruongSa , *conDao;
    NSMutableArray *overlayArr;
    int positionDaNangInArr;
    NavigationBottom *navCustom;
    float positionYOfNAVBottom;
    int curentZoom;
    NSArray *data;
}

@end

@implementation MapTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    overlayArr = [[NSMutableArray alloc]init];
    positionDaNangInArr = 0;
    positionYOfNAVBottom = SCREEN_HEIGHT - 45;
    window = [[UIApplication sharedApplication] keyWindow];
    [self loadMap];
    navCustom = [NavigationBottom customView];
    [NavigationTop initNavigationItemsTopWithTitle:@"CPA" leftImageName:@"Icon.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
//    [NavigationBottom initNavigationBottom:navCustom positonY:positionYOfNAVBottom actionHome:nil actionDiscover:@selector(discoverBtn) actionMyCard:@selector(myCardBtn) view:self];
//    [self initBtnCheckin];
    [DrawerMenu initDrawerMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [NavigationTop initNavigationItemsTopWithTitle:@"CPA" leftImageName:@"Icon.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];

    [self configureLocalNotification];
}

- (void)configureLocalNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;

    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate sharedInstance] startUpdatingLocation];
        });
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [checkinBtn removeFromSuperview];
    [navCustom removeFromSuperview];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window viewWithTag:TAG_VIEW_BACKGROUND_BOTTOM]) {
        [[window viewWithTag:TAG_VIEW_BACKGROUND_BOTTOM] removeFromSuperview];
    }
}

#pragma mark -init-

- (void)loadMap {
    [Utils startSpinnerLoading];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:16.033524
                                                            longitude:108.204839
                                                                 zoom:5.5];
    mapView = [GMSMapView mapWithFrame:_viewTotal.bounds camera:camera];
    mapView.myLocationEnabled = YES;
    float latitude = [[AppDelegate sharedInstance]getLatitude];
    float longtitude= [[AppDelegate sharedInstance]getLongitude];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longtitude);
    mapView.settings.myLocationButton = NO;
    [mapView setMinZoom:3 maxZoom:20];
    curentZoom = 5.5;
    mapView.delegate = self;
    [_viewTotal addSubview:mapView];
    [APIClients getListPatient:^(id  _Nullable responseObject) {
        [Utils stopSpinnerLoading];
        NSLog(@"sucessfully");
        self->data = [responseObject objectForKey:@"data"];
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->data];
        [currentDefaults setObject:data forKey:PATIENT_INFO];
        for (int i = 0; i < self->data.count ; i++) {
            float lat = [[self->data[i] objectForKey:@"lat"] floatValue];
            float lng = [[self->data[i] objectForKey:@"lng"] floatValue];
            NSString *name = [self getInfoPatient:self->data[i]];
            [self addMarkerWithLat:lat lng:lng title:name];
        }
    } failure:^(NSError * _Nullable error) {
        [Utils stopSpinnerLoading];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PATIENT_INFO];
        NSLog(@"fail");
    }];
}

- (NSString *)getInfoPatient:(NSDictionary *)data {
    NSString *info;
    info = [NSString stringWithFormat:@"Tên: %@ \n Địa chỉ: %@ \n Thời gian: %@ \n Ghi chú: %@",[data objectForKey:@"name"],[data objectForKey:@"address"],[data objectForKey:@"verifyDate"],[data objectForKey:@"note"]];
    return  info;
}

- (void)addMarkerWithLat:(float)lat lng:(float)lng title:(NSString *)name {
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = name;
    marker.icon = [UIImage imageNamed:@"icons8-octagon-24.png"];
    marker.map = mapView;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{

}


#pragma mark -handle-

- (float)getZoomLevelWithImageName:(NSString *)imageName {
    float zoomLevel;
    if ([imageName isEqualToString:@"thua_thien_hue.png"]) {
        zoomLevel = 5.65;
    } else if ([imageName isEqualToString:@"quang_binh.png"]) {
        zoomLevel = 5.78;
    } else if ([imageName isEqualToString:@"quang_tri.png"]
               || [imageName isEqualToString:@"hai_duong.png"]
               || [imageName isEqualToString:@"hung_yen.png"]
               || [imageName isEqualToString:@"bac_ninh.png"]
               || [imageName isEqualToString:@"hai_phong.png"]) {
        zoomLevel = 5.6;
    } else if ([imageName isEqualToString:@"bac_giang.png"] || [imageName isEqualToString:@"bac_lieu.png"]) {
        zoomLevel = 5.5;
    } else {
        zoomLevel = 5.68;
    }
    return zoomLevel;
}

- (void)animationUnderImage {
    UIImage *imageAnimation = [UIImage imageNamed:@"image_animation.png"];
    float positionXOfanimationView = SCREEN_WIDTH/2 - SCREEN_HEIGHT*3/8;
    float positionYOfanimationView = SCREEN_HEIGHT/2 - SCREEN_HEIGHT*3/8;
    animationView = [[UIImageView alloc]initWithFrame:CGRectMake(positionXOfanimationView, positionYOfanimationView,SCREEN_HEIGHT*3/4, SCREEN_HEIGHT*3/4)];
    animationView.image = imageAnimation;
    [window addSubview:animationView];
    [window bringSubviewToFront:scretchImageView];
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [animationView.layer addAnimation:animation forKey:@"SpinAnimation"];
}

- (void)getLocationCurrent {
    [background removeFromSuperview];
    [scretchImageView removeFromSuperview];
    [shareBtn removeFromSuperview];
    [goBtn removeFromSuperview];
    float latitude = [[AppDelegate sharedInstance]getLatitude];
    float longtitude= [[AppDelegate sharedInstance]getLongitude];
    NSLog(@"location current lat %f , long %f",latitude,longtitude);
    NSLog(@"da nang icon %@",daNang.icon);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longtitude
                                                                 zoom:10];
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    [mapView animateToCameraPosition:camera];
    [CATransaction commit];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Do some work");
        [self->checkinBtn removeFromSuperview];
        [self->navCustom removeFromSuperview];
    });
    
}

#pragma mark -action-

- (void)shareBtn {
    [UIView animateWithDuration:1
    animations:^{
        self->animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        self->scretchImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished) {
        [self->background removeFromSuperview];
        [self->scretchImageView removeFromSuperview];
        [self->shareBtn removeFromSuperview];
        [self->goBtn removeFromSuperview];
        [self->animationView removeFromSuperview];
        self->scretchImageView.hidden = TRUE;
        [Utils shareFacebook];
    }];

}

- (void)navigationActionLeft {
    [DrawerMenu showDrawerMenu];
}

- (void)imageZoomOut {
    [UIView animateWithDuration:1
                     animations:^{
                         self->animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                         self->scretchImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                     } completion:^(BOOL finished) {
                         [self->animationView removeFromSuperview];
                         self->scretchImageView.hidden = TRUE;
                         [self getLocationCurrent];
                     }];
}

- (void)imageUpZoomIn {
    scretchImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:1
                     animations:^{
                         self->scretchImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (CLLocation *)deskLocationWithlat:(NSString *)lat lng:(NSString *)lng {
    CLLocation *deskLocation = [[CLLocation alloc]initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
    return deskLocation;
}

- (NSString *)formatFloatToStr:(float)fl {
    return [NSString stringWithFormat:@"%f",fl];
}


- (IBAction)getCurrentLocation:(id)sender {
    float latitude = [[AppDelegate sharedInstance]getLatitude];
    float longtitude= [[AppDelegate sharedInstance]getLongitude];
    NSLog(@"location current lat %f , long %f",latitude,longtitude);
    NSLog(@"da nang icon %@",daNang.icon);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longtitude
                                                                 zoom:15];
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    [mapView animateToCameraPosition:camera];
    [CATransaction commit];
    
    float distant = 100;
    CLLocation *currentLocation = [self deskLocationWithlat:[self formatFloatToStr:latitude]  lng:[self formatFloatToStr:longtitude]];
    NSMutableArray *positionArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < data.count; i++) {
        NSString *lat = [self->data[i] objectForKey:@"lat"];
        NSString *lng = [self->data[i] objectForKey:@"lng"];
        CLLocation *patientLocation = [self deskLocationWithlat:lat lng:lng];
        CLLocationDistance distanceBetweenCurrentAndPatient = [currentLocation distanceFromLocation:patientLocation];
        if (distanceBetweenCurrentAndPatient <= distant) {
            [positionArr addObject:[NSString stringWithFormat:@"%i",i]];
        }
    }
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (positionArr.count > 0) {
            NSString *patientName;
            for (int i = 0; i < positionArr.count; i ++) {
                int position = [positionArr[i] intValue];
                patientName = [NSString stringWithFormat:@"%@ ",[self->data[position] objectForKey:@"name"]];
                if (![patientName isEqualToString:@"BN-425 "]) {
                    NSString *content = [NSString stringWithFormat:@"Bạn đang ở gần bệnh nhân %@",patientName];
                    [self showAlertWithContent:content];
                }
            }
        }
      NSLog(@"Do some work");
    });
}

- (void)showAlertWithContent:(NSString *)content {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cảnh báo"
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (IBAction)zoomOut:(id)sender {
    curentZoom = curentZoom + 1;
    [mapView animateToZoom:curentZoom];
}
- (IBAction)zoomIn:(id)sender {
    curentZoom = curentZoom - 1;
    [mapView animateToZoom:curentZoom];
}
@end
