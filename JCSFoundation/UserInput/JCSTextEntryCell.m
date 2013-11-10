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

#import "JCSTextEntryCell.h"
#import "JCSNumericInputAccessoryView.h"
#import "JCSInputValidation.h"
#import "JCSDecimalInputValidation.h"
#import "JCSQuickNumericInputAccessoryView.h"

@interface JCSTextEntryCell () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *entryField;
@property (nonatomic, strong) JCSNumericInputAccessoryView *numberAccessoryView;
@property (nonatomic, strong) id <JCSInputValidation> inputValidation;

@end

@implementation JCSTextEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.editable = YES;

    [self.entryField setDelegate:self];
}


- (void)setTitle:(NSString *)title value:(NSString *)value {
    [self.titleLabel setText:title];
    [self.entryField setText:value];
}

- (NSString *)value {
    return [self.entryField text];
}

- (void)setValue:(NSString *)value {
    self.entryField.text = value;
}

- (void)useNumbersKeyboard {
    [self.entryField setKeyboardType:UIKeyboardTypeNumberPad];

    if (!self.entryField.inputAccessoryView) {
        [self setNumericInputAccessoryView:[[JCSQuickNumericInputAccessoryView alloc] init]];
    }
}

- (void)useNumbersAndPunctuationKeyboard {
    [self.entryField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self setInputValidation:[[JCSDecimalInputValidation alloc] init]];

    if (!self.entryField.inputAccessoryView) {
        [self setNumericInputAccessoryView:[[JCSQuickNumericInputAccessoryView alloc] init]];
    }
}

- (void)useDecimalPadKeyboard {
    [self.entryField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self setInputValidation:[[JCSDecimalInputValidation alloc] init]];

    if (!self.entryField.inputAccessoryView) {
        [self setNumericInputAccessoryView:[[JCSQuickNumericInputAccessoryView alloc] init]];
    }
}

- (void)setNumericInputAccessoryView:(JCSNumericInputAccessoryView *)view {
    [self.entryField setInputAccessoryView:view];
    [self setNumberAccessoryView:view];
    [self updateNumberAccessoryButton];
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)type {
    [self.entryField setAutocapitalizationType:type];
}

- (void)setReturnKeyType:(UIReturnKeyType)type {
    [self.entryField setReturnKeyType:type];
    [self updateNumberAccessoryButton];
}

- (void)updateNumberAccessoryButton {
    __block __weak JCSTextEntryCell *weakSelf = self;

    NSString *returnButtonTitle = self.entryField.returnKeyType == UIReturnKeyNext
            ? NSLocalizedString(@"JCS.button.title.next", nil) : NSLocalizedString(@"JCS.button.title.done", nil);

    [self.numberAccessoryView setReturnButtonTitle:returnButtonTitle action:^{
        [weakSelf.entryField.delegate textFieldShouldReturn:weakSelf.entryField];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.finishedEditingHandler) {
        self.finishedEditingHandler(self);
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!self.inputValidation) {
        return YES;
    }

    return [self.inputValidation textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;

    [self.entryField setUserInteractionEnabled:editable];
}

@end
