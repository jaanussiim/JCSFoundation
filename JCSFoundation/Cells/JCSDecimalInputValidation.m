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

#import <UIKit/UIKit.h>
#import "JCSDecimalInputValidation.h"

@implementation JCSDecimalInputValidation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string length] > 1) {
        return NO;
    }

    NSString *existingInput = textField.text;
    if (([string isEqualToString:@"."] || [string isEqualToString:@","]) && [existingInput rangeOfString:@"."].location != NSNotFound) {
        return NO;
    }

    if ([string isEqualToString:@","]) {
        [textField setText:[existingInput stringByAppendingString:@"."]];
        return NO;
    }

    return YES;
}

@end
