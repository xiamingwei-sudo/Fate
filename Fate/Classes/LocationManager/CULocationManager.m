//
//  CULocationManager.m
//  CUExChangeGW
//
//  Created by mile on 2021/2/1.
//

#import "CULocationManager.h"

NSNotificationName const CULocationManagerUpdatingLocationNotification;

@interface CULocationManager()

@property(nonatomic, strong)CLGeocoder *geocoder;

@property (nonatomic, copy)void (^completionHandler)(BOOL sucess, NSDictionary *locationDic);

@end


@implementation CULocationManager


+ (BOOL)cdm_isLocationServiceOpen
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else{
        return YES;
    }
}

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

+ (CULocationManager *)sharedGpsManager
{
    static CULocationManager *instance = nil;
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        instance = [[CULocationManager alloc] init];
    });
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        // 打开定位 然后得到数据
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        //_manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _manager.distanceFilter = 1000;
        
        if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_manager requestWhenInUseAuthorization];
            //[_manager requestAlwaysAuthorization];
        }
        
    }
    return self;
}

- (void)cdm_getGps
{
    // 开始新的数据定位
    [_manager startUpdatingLocation];
}

- (void)startGpsWithCompletionHandler:(void(^)(BOOL sucess, NSDictionary *locationDic))callBack {
    [_manager startUpdatingLocation];
    
    self.completionHandler = callBack;
    
}

- (void)cdm_stop {
    
    [_manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
//    NSLog(@"%zd",location.coordinate);
    [CULocationManager sharedGpsManager].strlatitude = @(location.coordinate.latitude).stringValue;
    [CULocationManager sharedGpsManager].strlongitude = @(location.coordinate.longitude).stringValue;
    
    // 反向地理编译出地址信息
    __weak typeof(self) weakSelf = self;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error)
        {
            if ([placemarks count] > 0) {
                
                CLPlacemark *placemark = [placemarks firstObject];
                // 获取城市
                NSString *city = placemark.locality;
                //获取省份
                NSString *administrativeArea = placemark.administrativeArea;
                NSLog(@"定位的省分：%@ 城市：%@", administrativeArea , city);
                
                if (!city.length) {
                    weakSelf.cityName = @"北京市";
                }else {
                    weakSelf.cityName = city;
                }
                self.locationInfo = placemark.name;
                if (!administrativeArea.length) {
                    weakSelf.adminArea = weakSelf.cityName;
                }else{
                    weakSelf.adminArea = administrativeArea;
                }

            } else if ([placemarks count] == 0) {
                weakSelf.cityName = @"北京市";
                weakSelf.adminArea = @"北京市";
            }
        }
        else
        {
            weakSelf.cityName = @"北京市";
            weakSelf.adminArea = @"北京市";
        }
        
           [weakSelf cdm_stop];
//        //这种是在需要的时候用，和下面NSUserDefaults 看自己的需求来用.
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GPS" object:nil userInfo:@{@"cityName":[GpsManager sharedGpsManager].cityName}];
        [[NSNotificationCenter defaultCenter] postNotificationName:CULocationManagerUpdatingLocationNotification object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.completionHandler) {
                weakSelf.completionHandler(YES,@{
                    @"cityname": weakSelf.cityName,
                    @"adminarea": weakSelf.adminArea,
                    @"strlatitude": weakSelf.strlatitude,
                    @"strlatitude": weakSelf.strlongitude
                                       });
            }
        });

    }];
    
    [self.manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败了。。%@", error.localizedDescription);
    if(self.completionHandler) {
        self.completionHandler(NO, @{});
    }
    
}

+ (NSDictionary *)locationInfo {
    return @{
             @"source" : @"2",
             @"lng" : [CULocationManager sharedGpsManager].strlongitude?:@"-1",
             @"lat" : [CULocationManager sharedGpsManager].strlatitude?:@"-1",
//             @"wifimac" : [TuyaSmartActivator currentWifiBSSID]?:@"-1",
             @"mcc": @"-1",
             @"mnc": @"-1",
             @"lac": @"-1",
             @"cellid": @"-1",
             };
}


@end
