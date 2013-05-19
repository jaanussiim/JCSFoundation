/*
 * Copyright 2013 JaanusSiim
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "NSString+JCSValidations.h"

@implementation NSString (JCSValidations)

- (BOOL)hasValue {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0;
}

- (BOOL)isDecimalNumber {
    if (![self hasValue]) {
        return NO;
    }

    NSString *value = [NSString stringWithString:self];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];

    return ![value hasValue];
}

- (BOOL)isNumber {
    if (![self hasValue]) {
        return NO;
    }

    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self locale:[NSLocale currentLocale]];
    //TODO jaanus: check this. ',' may have been replaced with '.', but should have same length
    return [self length] == [[number stringValue] length];
}

@end
