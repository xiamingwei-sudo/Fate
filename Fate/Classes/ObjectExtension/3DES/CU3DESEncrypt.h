//
//  CU3DESEncrypt.h
//  CUExChangeGW
//
//  Created by mile on 2021/2/2.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

@interface CU3DESEncrypt : NSObject

+ (NSString *)tripleTodes:(NSString *)text cryptType:(CCOperation )type byDefault:(BOOL)defaultB;

+ (NSString*)tripleTo3DES:(NSString*)plainText key:(NSString *)key encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
@end

NS_ASSUME_NONNULL_END
