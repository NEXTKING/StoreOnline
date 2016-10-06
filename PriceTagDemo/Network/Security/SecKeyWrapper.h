//
//  SecKeyWrapper.h
//  MobileBanking
//
//  Created by Sergey Sasin on 21.11.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import "SecKeyCommon.h"

@interface SecKeyWrapper : NSObject
{
	NSData * publicTag;
	NSData * privateTag;
	SecKeyRef publicKeyRef;
	SecKeyRef privateKeyRef;
}

@property (nonatomic, retain) NSData * publicTag;
@property (nonatomic, retain) NSData * privateTag;

+ (SecKeyWrapper *) instance;
- (void) generateKeyPair:(NSUInteger)keySize;
- (void) deleteAsymmetricKeys;
- (NSData *) getSignatureBytes:(NSData *)plainText;
- (NSData *) getHashBytes:(NSData *)plainText;
- (BOOL) verifySignature:(NSData *)plainText secKeyRef:(SecKeyRef)publicKey signature:(NSData *)sig;
- (SecKeyRef) getPublicKeyRef;
- (NSData *) getPublicKeyBits;
- (SecKeyRef) getPrivateKeyRef;
#ifdef DEBUG
- (NSData *) getPrivateKeyBits;
- (void) showKeys;
#endif

@end
