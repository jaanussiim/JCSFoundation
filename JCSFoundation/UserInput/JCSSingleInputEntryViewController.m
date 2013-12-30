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

#import "JCSSingleInputEntryViewController.h"
#import "UIApplication+Keyboard.h"

@interface JCSSingleInputEntryViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *entryField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButtonItem;

- (IBAction)donePressed:(id)sender;

@end

@implementation JCSSingleInputEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setRightBarButtonItem:self.doneButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.entryField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIApplication dismissKeyboard];
    if ([self hasValidInput]) {
        [self notifyCompletionHandler];
    }

    return YES;
}

- (void)notifyCompletionHandler {
    if (!self.completionBlock) {
        return;
    }

    self.completionBlock(self.entryField.text);
}


- (IBAction)donePressed:(id)sender {
    [UIApplication dismissKeyboard];
    if ([self hasValidInput]) {
        [self notifyCompletionHandler];
    }
}

- (BOOL)hasValidInput {
    if (!self.entryValidationBlock) {
        return YES;
    }

    return self.entryValidationBlock(self.entryField.text);
}

@end
