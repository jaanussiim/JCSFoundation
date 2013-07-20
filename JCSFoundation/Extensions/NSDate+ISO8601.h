//
//  NSDate+ISO8601.h
//  JCSFoundation
//
//  Created by Jaanus Siim on 7/20/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)

- (NSString *)iso8601String;
+ (NSDate *)dateFromISO8601String:(NSString *)dateString;

@end
