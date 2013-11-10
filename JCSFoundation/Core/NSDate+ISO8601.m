//
//  NSDate+ISO8601.m
//  JCSFoundation
//
//  Created by Jaanus Siim on 7/20/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)

- (NSString *)iso8601String {
    return [[NSDate iso8601Formatter] stringFromDate:self];
}

+ (NSDate *)dateFromISO8601String:(NSString *)dateString {
    return [[NSDate iso8601Formatter] dateFromString:dateString];
}

static NSDateFormatter *__iso8601Formatter;
+ (NSDateFormatter *)iso8601Formatter {
    if (!__iso8601Formatter) {
        __iso8601Formatter = [[NSDateFormatter alloc] init];
        [__iso8601Formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [__iso8601Formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }

    return __iso8601Formatter;
}

@end
