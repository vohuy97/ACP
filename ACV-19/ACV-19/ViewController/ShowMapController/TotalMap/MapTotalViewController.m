//
//  MapTotalViewController.m
//  MapCao
//
//  Created by VoHuy on 2020/01/13.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "MapTotalViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MDScratchImageView.h"
#import "AppDelegate.h"
#import "NavigationTop.h"
#import "NavigationBottom.h"
#import "Constains.h"
#import "DiscoverViewController.h"
#import "MyCardViewController.h"
#import "DrawerMenu.h"
#import "Utils.h"
#import "APIClients.h"

@interface MapTotalViewController () <MDScratchImageViewDelegate, GMSMapViewDelegate> {
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
    MDScratchImageView *scratchImageView;
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
    [NavigationTop initNavigationItemsTopWithTitle:@"CPA-19" leftImageName:@"Icon.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
//    [NavigationBottom initNavigationBottom:navCustom positonY:positionYOfNAVBottom actionHome:nil actionDiscover:@selector(discoverBtn) actionMyCard:@selector(myCardBtn) view:self];
//    [self initBtnCheckin];
    [DrawerMenu initDrawerMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [NavigationTop initNavigationItemsTopWithTitle:@"CPA-19" leftImageName:@"Icon.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];

    [[AppDelegate sharedInstance] startUpdatingLocation];
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
    mapView.myLocationEnabled = NO;
    mapView.settings.myLocationButton = NO;
    [mapView setMinZoom:3 maxZoom:15];
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

- (void)initBtnCheckin {
    checkinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkinBtn addTarget:self
               action:@selector(checkin)
     forControlEvents:UIControlEventTouchUpInside];
    [checkinBtn setTitle:@"Check in" forState:UIControlStateNormal];
    [checkinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    float positionX = SCREEN_WIDTH/2 - (SCREEN_WIDTH -40)/2;
    float positionY = positionYOfNAVBottom - 60;
    checkinBtn.layer.cornerRadius = 20;
    checkinBtn.frame = CGRectMake(positionX, positionY, SCREEN_WIDTH - 40, 45);
    [checkinBtn setBackgroundColor:[UIColor redColor]];
    [window addSubview:checkinBtn];
}

- (void)initBtnGoAndShare {
    float sizeWidthBtn = checkinBtn.frame.size.width*2/5;
    // go btn
    goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBtn addTarget:self
               action:@selector(imageZoomOut)
     forControlEvents:UIControlEventTouchUpInside];
    [goBtn setTitle:@"GO" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    float positionX = checkinBtn.frame.origin.x + checkinBtn.frame.size.width - sizeWidthBtn - 10;
    float positionY = checkinBtn.frame.origin.y - 80;
    goBtn.layer.cornerRadius = 20;
    goBtn.frame = CGRectMake(positionX, positionY, sizeWidthBtn , 40.0);
    [goBtn setBackgroundColor:[UIColor redColor]];
    [window addSubview:goBtn];

    //share btn
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn addTarget:self
              action:@selector(shareBtn)
    forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"SHARE" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    positionX = checkinBtn.frame.origin.x + 10;
    positionY = checkinBtn.frame.origin.y - 80;
    shareBtn.layer.cornerRadius = 20;
    shareBtn.frame = CGRectMake(positionX, positionY, sizeWidthBtn, 40.0);
    [shareBtn setBackgroundColor:[UIColor whiteColor]];
    [window addSubview:shareBtn];
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

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    NSLog(@"%s %p progress == %f", __PRETTY_FUNCTION__, scratchImageView, maskingProgress);
    if (maskingProgress == 0.937500) {
        scratchImageView.hidden = YES;
        [self animationUnderImage];
        [self initBtnGoAndShare];
    }
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

- (void)discoverBtn {
    [checkinBtn removeFromSuperview];
    [navCustom removeFromSuperview];
    DiscoverViewController *discoverVC = [[DiscoverViewController alloc]init];
    [self.navigationController pushViewController:discoverVC animated:NO];
}

- (void)myCardBtn {
    [checkinBtn removeFromSuperview];
    [navCustom removeFromSuperview];
    MyCardViewController *myCardVC = [[MyCardViewController alloc]init];
    [self.navigationController pushViewController:myCardVC animated:NO];
}

- (void)checkin {
    scretchImageView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scretchImageView.contentInset = UIEdgeInsetsMake([[UIApplication sharedApplication] statusBarFrame].size.height, 0.0f, 0.0f, 0.0f);
    scretchImageView.canCancelContentTouches = NO;
    scretchImageView.delaysContentTouches = NO;
    background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, window.frame.size.height)];
    [background setBackgroundColor:[UIColor grayColor]];
    background.alpha = 0.5;
    [window addSubview:background];
    [window addSubview:scretchImageView];

    NSArray *imagesDicts = @[ @{@"sharp" : @"welcome_da_nang.png", @"blured" : @"scratch_here.png"}];

    UIImage *image = [UIImage imageNamed:@"scratch_here.png"];
    CGFloat step = SCREEN_HEIGHT/2 - image.size.height/2;
    CGFloat currentY = step;
    for (NSDictionary *dictionary in imagesDicts) {
        UIImage *sharpImage = [UIImage imageNamed:[dictionary objectForKey:@"sharp"]];

        CGFloat width = MIN(floorf(scretchImageView.bounds.size.width * 0.6f), sharpImage.size.width);
        CGFloat height = sharpImage.size.height * (width / sharpImage.size.width);

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(scretchImageView.bounds.size.width * 0.5f - width * 0.5f), currentY, width, height)];
        imageView.image = sharpImage;
        [scretchImageView addSubview:imageView];

        UIImage *scratchImg = [UIImage imageNamed:[dictionary objectForKey:@"blured"]];
        NSString *radiusString = [dictionary objectForKey:@"radius"];
        scratchImageView = [[MDScratchImageView alloc] initWithFrame:imageView.frame];
        scratchImageView.delegate = self;
        if (nil == radiusString) {
            scratchImageView.image = scratchImg;
        } else {
            [scratchImageView setImage:scratchImg radius:[radiusString intValue]];
            scratchImageView.image = scratchImg;
        }
        [scretchImageView addSubview:scratchImageView];

        currentY = CGRectGetMaxY(imageView.frame) + step;
        [self imageUpZoomIn];
    }
    scretchImageView.contentSize = CGSizeMake(scretchImageView.bounds.size.width, currentY);
    [window bringSubviewToFront:scretchImageView];

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
            }
            NSString *content = [NSString stringWithFormat:@"Bạn đang ở gần bệnh nhân %@",patientName];
            [self showAlertWithContent:content];
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
