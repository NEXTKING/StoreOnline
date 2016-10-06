//
//  BlankInformation.h
//  Checklines
//
//  Created by Denis Kurochkin on 5/8/15.
//  Copyright (c) 2015 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlankInformation : NSObject

@property (nonatomic, copy) NSString* formId;
@property (nonatomic, copy) NSString* title;

@property (nonatomic, copy) NSString* explanatoryImagePath;

- (void) clearAnswers;

@end
