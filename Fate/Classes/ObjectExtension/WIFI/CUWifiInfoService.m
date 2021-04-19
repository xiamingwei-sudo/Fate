//
//  CUWifiInfoService.m
//  CUExChangeGW
//
//  Created by mile on 2021/2/3.
//

#import "CUWifiInfoService.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation CUWifiInfoService

+ (CUWifiInfoService *)shared
{
    static CUWifiInfoService *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[CUWifiInfoService alloc] init];
    });
    return _sharedInstance;
}

- (NSString *)getSSID
{
    NSDictionary *ifs = [self fetchSSIDInfo];
    NSString *ssid = [ifs objectForKey:@"SSID"];
    NSString *ssidValue;
    if([[ssid uppercaseString] isEqualToString:@"UNSUPPORTED"]){
        NSLog(@"Simulator doesn't detect wifi, please connect your iPhone!");
        ssidValue = @"";
    }else {
        ssidValue = ssid;
    }
    
    return ssidValue;
}

- (id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info;
    if (!ifs) {
        info = [NSDictionary dictionaryWithObjectsAndKeys:
                @"UNSUPPORTED", @"SSID",
                @"UNSUPPORTED", @"BSSID", nil];
    } else{
        for (NSString *ifnam in ifs) {
            info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            NSLog(@"%@ => %@", ifnam, info);
            if (info && [info count]) { break; }
        }
    }
    return info;
}

@end
