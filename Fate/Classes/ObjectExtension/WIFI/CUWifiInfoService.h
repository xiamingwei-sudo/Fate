//
//  CUWifiInfoService.h
//  CUExChangeGW
//
//  Created by mile on 2021/2/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUWifiInfoService : NSObject
+ (CUWifiInfoService *)shared;

- (NSString *)getSSID;
@end

NS_ASSUME_NONNULL_END
