//
//  SecKeyCommon.h
//  MobileBanking
//
//  Created by Sergey Sasin on 21.11.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/* Begin global declarations */

// Global constants used for chosen digest.

// The digest algorithm chosen for this sample is SHA1.
// The reasoning behind this was due to the fact that the iPhone and iPod touch have
// hardware accelerators for this particular algorithm and therefore are energy efficient.

#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH
#define kDefaultKeyLength       512

// Global constants for padding schemes.
#define kTypeOfSigPadding		kSecPaddingPKCS1SHA1

// constants used to find public, private, and symmetric keys.
#define kPublicKeyTag			"com.bpcbt.rnd.mbank.publickey"
#define kPrivateKeyTag			"com.bpcbt.rnd.mbank.privatekey"
