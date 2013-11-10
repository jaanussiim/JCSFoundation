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

@class JCSNumericInputAccessoryView;
@class JCSTextEntryCell;

typedef void (^JCSTextEntryCellActionBlock)(JCSTextEntryCell *cell);

@interface JCSTextEntryCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UITextField *entryField;
@property (nonatomic, copy) JCSTextEntryCellActionBlock finishedEditingHandler;
@property (nonatomic, assign, getter=isEnabled) BOOL editable;

- (void)setTitle:(NSString *)title value:(NSString *)value;
- (NSString *)value;
- (void)setValue:(NSString *)value;
- (void)useNumbersKeyboard;
- (void)useNumbersAndPunctuationKeyboard;
- (void)useDecimalPadKeyboard;
- (void)setNumericInputAccessoryView:(JCSNumericInputAccessoryView *)view;
- (void)setAutocapitalizationType:(UITextAutocapitalizationType)type;
- (void)setReturnKeyType:(UIReturnKeyType)type;

@end
