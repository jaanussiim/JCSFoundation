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

#import "JCSDropDownCell.h"
#import "JCSDropDownItem.h"

@interface JCSDropDownCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) id<JCSDropDownItem> selectedItem;
@property (nonatomic, strong) NSArray *possibleValues;
@property (nonatomic, strong) UIPickerView *picker;

@end

@implementation JCSDropDownCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:pickerView];

    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];
    [self.entryField setInputView:pickerView];
}


- (void)setTitle:(NSString *)title selected:(id <JCSDropDownItem>)selected {
    [self setTitle:title value:selected ? [selected displayValue] : @""];
    [self setSelectedItem:selected];
    [self updatePickerSelection];
}

- (void)setAllValues:(NSArray *)allValues {
    _possibleValues = allValues;
    [self updatePickerSelection];
}

- (id <JCSDropDownItem>)selectedValue {
    return self.selectedItem;
}

- (void)setSelectedValue:(id <JCSDropDownItem>)selected {
    [self.entryField setText:selected.displayValue];
    [self setSelectedItem:selected];

    [self updatePickerSelection];
}

- (NSString *)value {
    return [self.selectedItem value];
}

- (void)updatePickerSelection {
    if (!self.selectedItem) {
        return;
    }

    if (!self.possibleValues) {
        return;
    }

    NSUInteger index = [self.possibleValues indexOfObject:self.selectedItem];
    if (index == NSNotFound) {
        return;
    }

    [self.picker selectRow:index inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.possibleValues count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id<JCSDropDownItem> item = self.possibleValues[(NSUInteger) row];
    return item.displayValue;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    id<JCSDropDownItem> item = self.possibleValues[(NSUInteger) row];
    [self setSelectedValue:item];
}

@end
