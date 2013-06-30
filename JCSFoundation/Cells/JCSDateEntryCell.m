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

#import "JCSDateEntryCell.h"

@interface JCSDateEntryCell ()

@property (nonatomic, strong) UIDatePicker *picker;

@end

@implementation JCSDateEntryCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [self setPicker:pickerView];
    [pickerView setDatePickerMode:UIDatePickerModeDate];
    [pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.entryField setInputView:pickerView];
}

- (void)setTitle:(NSString *)title selectedDate:(NSDate *)selected {
    [self setSelectedDate:selected];
    [self.titleLabel setText:title];
    [self updatePresentedValue];
    [self.picker setDate:selected];
}

- (void)dateChanged:(UIDatePicker *)picker {
    [self setSelectedDate:picker.date];
    [self updatePresentedValue];
}

- (void)updatePresentedValue {
    [self.entryField setText:[[JCSDateEntryCell displayFormatter] stringFromDate:self.selectedDate]];
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    [self updatePresentedValue];
}

static NSDateFormatter *__displayFormatter;
+ (NSDateFormatter *)displayFormatter {
    if (!__displayFormatter) {
        __displayFormatter = [[NSDateFormatter alloc] init];
        [__displayFormatter setDateStyle:NSDateFormatterMediumStyle];
        [__displayFormatter setTimeStyle:NSDateFormatterNoStyle];
    }

    return __displayFormatter;
}

@end
