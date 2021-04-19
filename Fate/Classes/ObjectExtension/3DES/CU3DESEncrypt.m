//
//  CU3DESEncrypt.m
//  CUExChangeGW
//
//  Created by mile on 2021/2/2.
//

#import "CU3DESEncrypt.h"
#import <GTMBase64/GTMBase64.h>


#define kChosenDigestLength        CC_SHA1_DIGEST_LENGTH
#define DESKEY @"138dk839DEK28321138dkF83"
@implementation CU3DESEncrypt



+ (NSString *)tripleTodes:(NSString *)text cryptType:(CCOperation )type byDefault:(BOOL)defaultB{
//    MARK: TODO 替换默认的DESKEY
    NSString *key = defaultB ? DESKEY: DESKEY;
    return [self tripleTo3DES:text key:key encryptOrDecrypt:type];
}

+ (NSString*)tripleTo3DES:(NSString*)plainText key:(NSString *)key encryptOrDecrypt:(CCOperation)encryptOrDecrypt{
    const void *vplainText;
    size_t plainTextBufferSize;
    if (encryptOrDecrypt == kCCDecrypt){//解密
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else{//加密
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    if (bufferPtr == NULL) {
        return @"-1";
    }
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSString *result;
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    if (encryptOrDecrypt == kCCDecrypt) {
        result = [[NSString alloc] initWithData:myData
                                       encoding:NSUTF8StringEncoding];
    }else{
        result = [GTMBase64 stringByEncodingData:myData];
    }
    free(bufferPtr);
    return result;
}

@end
