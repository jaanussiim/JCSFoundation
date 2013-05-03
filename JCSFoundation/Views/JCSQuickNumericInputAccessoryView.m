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

#import "JCSQuickNumericInputAccessoryView.h"

@interface JCSQuickNumericInputAccessoryView ()

@property (nonatomic, strong) UIBarButtonItem *button;
@property (nonatomic, copy) JCSActionBlock actionBlock;

@end

@implementation JCSQuickNumericInputAccessoryView

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 20, 44)];
    if (self) {
        [self initializeView];
    }

    return self;
}

- (void)initializeView {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:self.bounds];
    [bar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [bar setBarStyle:UIBarStyleBlackTranslucent];

    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Button" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressed)];
    [self setButton:button];

    [bar setItems:@[spacer, button]];
    [self addSubview:bar];
}

- (void)setReturnButtonTitle:(NSString *)title action:(JCSActionBlock)action {
    [self.button setTitle:title];
    [self setActionBlock:action];
}

- (void)buttonPressed {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
