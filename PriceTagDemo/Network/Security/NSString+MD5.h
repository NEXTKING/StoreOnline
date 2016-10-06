//
//  NSString+MD5.h
//  Checklines
//
//  Created by Denis Kurochkin on 12.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
- (NSString *)MD5String;
- (NSString *)sha256;
@end
