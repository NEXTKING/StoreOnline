//
//  SecKeyWrapper.m
//  MobileBanking
//
//  Created by Sergey Sasin on 21.11.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import "SecKeyWrapper.h"
#import "Logger.h"

@implementation SecKeyWrapper

@synthesize publicTag, privateTag;

static SecKeyWrapper * __inst = nil;

+ (SecKeyWrapper *) instance
{
    @synchronized ( self )
    {
        if ( __inst == nil )
            __inst = [[self alloc] init];
    }
    return __inst;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized ( self )
    {
        if ( __inst == nil )
            __inst = [super allocWithZone:zone];
    }
    return __inst;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}



#if TARGET_IPHONE_SIMULATOR
//#error This sample is designed to run on a device, not in the simulator. To run this sample, \
choose Project > Set Active SDK > Device and connect a device. Then click Build and Go. 
- (void) generateKeyPair:(NSUInteger)keySize {}
- (void) deleteAsymmetricKeys {}
- (NSData *) getSignatureBytes:(NSData *)plainText
{
//    return nil;
    static const int _sig_len = 8;
    static const char _sig[_sig_len] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF};
    NSMutableData *sigBytes = [NSMutableData dataWithCapacity:_sig_len];
    [sigBytes appendBytes:_sig length:_sig_len];
    return sigBytes;
}
- (NSData *) getHashBytes:(NSData *)plainText
{
//    return nil;
    static const int _hash_len = 8;
    static const char _hash[_hash_len] = {0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10};
    NSMutableData *hashBytes = [NSMutableData dataWithCapacity:_hash_len];
    [hashBytes appendBytes:_hash length:_hash_len];
    return hashBytes;
}
- (BOOL) verifySignature:(NSData *)plainText secKeyRef:(SecKeyRef)publicKey signature:(NSData *)sig { return NO; }
- (SecKeyRef) getPublicKeyRef { return nil; }
- (NSData *) getPublicKeyBits
{
//    return nil;
    static const int _pubkey_len = 74;
    static const char _pubkey[] =
    {
        0x30, 0x48, 0x02, 0x41, 0x00, 0xc1, 0x2b, 0x34, 0x0a, 0x7a, 0xc8, 0x84, 0x1f, 0xf5, 0x7d, 0x10,
        0xf6, 0x3d, 0xb7, 0x3b, 0x12, 0x2a, 0x55, 0xf5, 0x95, 0xdb, 0x5a, 0x62, 0x6a, 0x5b, 0xdb, 0x5d,
        0x13, 0x30, 0x58, 0x41, 0xba, 0x0a, 0x3d, 0x9e, 0x4d, 0x39, 0xdf, 0x2b, 0xeb, 0xd2, 0x68, 0x24,
        0x67, 0xc5, 0x37, 0x44, 0xbc, 0xca, 0x31, 0x27, 0x38, 0xf6, 0x1c, 0x8f, 0x47, 0x69, 0x31, 0x0d,
        0x23, 0xb5, 0xe4, 0x4d, 0x47, 0x02, 0x03, 0x01, 0x00, 0x01
    };
    NSMutableData *keyBytes = [NSMutableData dataWithCapacity:_pubkey_len];
    [keyBytes appendBytes:_pubkey length:_pubkey_len];
    return keyBytes;
}
- (SecKeyRef) getPrivateKeyRef { return nil; }
#ifdef DEBUG
- (NSData *) getPrivateKeyBits { return nil; }
- (void) showKeys {}
#endif
#else

// identifiers used to find public and private key.
static const uint8_t publicKeyIdentifier[]		= kPublicKeyTag;
static const uint8_t privateKeyIdentifier[]		= kPrivateKeyTag;

-(id) init
{
	 if ( self = [super init] )
	 {
		 // Tag data to search for keys.
		 privateTag = [[NSData alloc] initWithBytes:privateKeyIdentifier length:sizeof(privateKeyIdentifier)];
		 publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
	 }
	
	return self;
}

- (void) dealloc
{
	if ( publicKeyRef )
        CFRelease(publicKeyRef);
	if ( privateKeyRef )
        CFRelease(privateKeyRef);
}

- (void) deleteAsymmetricKeys
{
	OSStatus sanityCheck = noErr;
	NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
	NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
	
	// Set the public key query dictionary.
	[queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	[queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
	[queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	
	// Set the private key query dictionary.
	[queryPrivateKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	[queryPrivateKey setObject:privateTag forKey:(id)kSecAttrApplicationTag];
	[queryPrivateKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	
	// Delete the private key.
	sanityCheck = SecItemDelete((CFDictionaryRef)queryPrivateKey);
    if ( sanityCheck != noErr && sanityCheck != errSecItemNotFound )
        [Logger log:self method:@"deleteAsymmetricKeys" format:@"Error removing private key, OSStatus == %d.", (int)sanityCheck];
	
	// Delete the public key.
	sanityCheck = SecItemDelete((CFDictionaryRef)queryPublicKey);
    if ( sanityCheck != noErr && sanityCheck != errSecItemNotFound )
        [Logger log:self method:@"deleteAsymmetricKeys" format:@"Error removing public key, OSStatus == %d.", (int)sanityCheck];
	
	if (publicKeyRef) CFRelease(publicKeyRef);
	if (privateKeyRef) CFRelease(privateKeyRef);
}

- (void) generateKeyPair:(NSUInteger)keySize
{
	OSStatus sanityCheck = noErr;
	publicKeyRef = NULL;
	privateKeyRef = NULL;
	
    if ( !(keySize == 512 || keySize == 1024 || keySize == 2048) )
        [Logger log:self method:@"generateKeyPair" format:@"%d is an invalid and unsupported key size.", keySize];
	
	// First delete current keys.
	[self deleteAsymmetricKeys];
	
	// Container dictionaries.
	NSMutableDictionary * privateKeyAttr = [[NSMutableDictionary alloc] init];
	NSMutableDictionary * publicKeyAttr = [[NSMutableDictionary alloc] init];
	NSMutableDictionary * keyPairAttr = [[NSMutableDictionary alloc] init];
	
	// Set top level dictionary for the keypair.
	[keyPairAttr setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	[keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(id)kSecAttrKeySizeInBits];
	
	// Set the private key dictionary.
	[privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
	[privateKeyAttr setObject:privateTag forKey:(id)kSecAttrApplicationTag];
	// See SecKey.h to set other flag values.
	
	// Set the public key dictionary.
	[publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
	[publicKeyAttr setObject:publicTag forKey:(id)kSecAttrApplicationTag];
	// See SecKey.h to set other flag values.
	
	// Set attributes to top level dictionary.
	[keyPairAttr setObject:privateKeyAttr forKey:(id)kSecPrivateKeyAttrs];
	[keyPairAttr setObject:publicKeyAttr forKey:(id)kSecPublicKeyAttrs];
	
	// SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
	sanityCheck = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr, &publicKeyRef, &privateKeyRef);
    if ( !(sanityCheck == noErr && publicKeyRef != NULL && privateKeyRef != NULL) )
        [Logger log:self method:@"generateKeyPair" format:@"Something really bad went wrong with generating the key pair."];
}

- (NSData *) getHashBytes:(NSData *)plainText
{
	CC_SHA1_CTX ctx;
	uint8_t * hashBytes = NULL;
	NSData * hash = nil;
	
	// Malloc a buffer to hold hash.
	hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
	memset((void *)hashBytes, 0x0, kChosenDigestLength);
	
	// Initialize the context.
	CC_SHA1_Init(&ctx);
	// Perform the hash.
	CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
	// Finalize the output.
	CC_SHA1_Final(hashBytes, &ctx);
	
	// Build up the SHA1 blob.
	hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
	
	if (hashBytes) free(hashBytes);
	
	return hash;
}

- (NSData *) getSignatureBytes:(NSData *)plainText
{
	OSStatus sanityCheck = noErr;
	NSData * signedHash = nil;
	
	uint8_t * signedHashBytes = NULL;
	size_t signedHashBytesSize = 0;
	
	SecKeyRef privateKey = NULL;
	
	privateKey = [self getPrivateKeyRef];
    if ( privateKey == Nil )
    {   // key not found, break signing procedure
        return Nil;
        // alternative way - to geterate new key pair automatically
        [self generateKeyPair:kDefaultKeyLength];
        privateKey = [self getPrivateKeyRef];
        if ( privateKey == Nil )
        {   // key not found again, some problem in key generation, break
            return Nil;
        }
    }
	signedHashBytesSize = SecKeyGetBlockSize(privateKey);
	
	// Malloc a buffer to hold signature.
	signedHashBytes = malloc( signedHashBytesSize * sizeof(uint8_t) );
	memset((void *)signedHashBytes, 0x0, signedHashBytesSize);
	
	// Sign the SHA1 hash.
	sanityCheck = SecKeyRawSign(	privateKey, 
									kTypeOfSigPadding, 
									(const uint8_t *)[[self getHashBytes:plainText] bytes],
									kChosenDigestLength, 
									(uint8_t *)signedHashBytes, 
									&signedHashBytesSize
								);
	
    if ( sanityCheck == noErr )
	{   // Build up signed SHA1 blob.
        signedHash = [NSData dataWithBytes:(const void *)signedHashBytes length:(NSUInteger)signedHashBytesSize];
    }
    else
    {
        [Logger log:self method:@"getSignatureBytes" format:@"Problem signing the SHA1 hash, OSStatus == %d.", sanityCheck];
    }
	
	if (signedHashBytes) free(signedHashBytes);
	
	return signedHash;
}

- (BOOL) verifySignature:(NSData *)plainText secKeyRef:(SecKeyRef)publicKey signature:(NSData *)sig
{
	size_t signedHashBytesSize = 0;
	OSStatus sanityCheck = noErr;
	
	// Get the size of the assymetric block.
	signedHashBytesSize = SecKeyGetBlockSize(publicKey);
	
	sanityCheck = SecKeyRawVerify(	publicKey, 
									kTypeOfSigPadding, 
									(const uint8_t *)[[self getHashBytes:plainText] bytes],
									kChosenDigestLength, 
									(const uint8_t *)[sig bytes],
									signedHashBytesSize
								  );
	
	return (sanityCheck == noErr) ? YES : NO;
}

- (SecKeyRef) getPublicKeyRef
{
	OSStatus sanityCheck = noErr;
	SecKeyRef publicKeyReference = NULL;
	
	if (publicKeyRef == NULL) {
		NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
		
		// Set the public key query dictionary.
		[queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
		[queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
		[queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
		[queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
		
		// Get the key.
		sanityCheck = SecItemCopyMatching((CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference);
		
		if (sanityCheck != noErr)
		{
			publicKeyReference = NULL;
		}
		
	} else {
		publicKeyReference = publicKeyRef;
	}
	
	return publicKeyReference;
}

- (NSData *) getPublicKeyBits
{
	OSStatus sanityCheck = noErr;
	NSData * publicKeyBits = nil;
	
	NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
		
	// Set the public key query dictionary.
	[queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	[queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
	[queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	[queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnData];
		
	// Get the key bits.
	sanityCheck = SecItemCopyMatching((CFDictionaryRef)queryPublicKey, (void*)&publicKeyBits);
		
	if (sanityCheck != noErr)
	{
		publicKeyBits = nil;
	}
	
	return publicKeyBits;
}

- (SecKeyRef) getPrivateKeyRef
{
	OSStatus sanityCheck = noErr;
	SecKeyRef privateKeyReference = NULL;
	
	if (privateKeyRef == NULL) {
		NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
		
		// Set the private key query dictionary.
		[queryPrivateKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
		[queryPrivateKey setObject:privateTag forKey:(id)kSecAttrApplicationTag];
		[queryPrivateKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
		[queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
		
		// Get the key.
		sanityCheck = SecItemCopyMatching((CFDictionaryRef)queryPrivateKey, (void *)&privateKeyReference);
		
		if (sanityCheck != noErr)
		{
			privateKeyReference = NULL;
		}
	} else {
		privateKeyReference = privateKeyRef;
	}
	
	return privateKeyReference;
}

#ifdef DEBUG
- (NSData *) getPrivateKeyBits
{
	OSStatus sanityCheck = noErr;
	NSData *privateKeyBits = NULL;
	
    NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
    
    // Set the private key query dictionary.
    [queryPrivateKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
    [queryPrivateKey setObject:privateTag forKey:(id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnData];
    
    // Get the key.
    sanityCheck = SecItemCopyMatching((CFDictionaryRef)queryPrivateKey, (void *)&privateKeyBits);
    
    if (sanityCheck != noErr)
    {
        privateKeyBits = NULL;
    }
    
	return privateKeyBits;
}

- (void) showKeys
{
    [Logger log:self method:@"showKeys" format:@"Public key: %@", [[self getPublicKeyBits] description]];
    [Logger log:self method:@"showKeys" format:@"Private key: %@", [[self getPrivateKeyBits] description]];
}
#endif

#endif

@end
