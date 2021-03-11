//
//  CULocationManager.h
//  CUExChangeGW
//
//  Created by mile on 2021/2/1.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSNotificationName const CULocationManagerUpdatingLocationNotification;


@interface CULocationManager : NSObject <CLLocationManagerDelegate>



@property (nonatomic,strong)CLLocationManager *manager;

@property (copy, nonatomic)NSString *cityName; //城市
@property (copy, nonatomic)NSString *adminArea; //省份
@property (copy, nonatomic)NSString *locationInfo;//具体地址
@property (copy, nonatomic) NSString *strlatitude;
@property (copy, nonatomic) NSString *strlongitude;

+ (CULocationManager *)sharedGpsManager;

+ (BOOL)cdm_isLocationServiceOpen;

- (void)cdm_getGps;

- (void)startGpsWithCompletionHandler:(void(^)(BOOL sucess, NSDictionary *locationDic))callBack;
- (void)cdm_stop;
+ (NSDictionary *)locationInfo;
@end

NS_ASSUME_NONNULL_END
