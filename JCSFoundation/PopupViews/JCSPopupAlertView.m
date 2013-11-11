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

#import <CoreGraphics/CoreGraphics.h>
#import "JCSPopupAlertView.h"
#import "UIView+JCSLoadView.h"

@interface JCSPopupAlertView ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UIButton *confirmButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

- (IBAction)confirmPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end

@implementation JCSPopupAlertView

+ (id)alertViewWithTitle:(NSString *)alertTitle message:(NSString *)message {
    NSString *expectedNibName = NSStringFromClass([self class]);
    JCSPopupAlertView *alertView = (JCSPopupAlertView *) [UIView loadViewFromXib:expectedNibName];

    [alertView setTitle:alertTitle message:message];

    return alertView;
}

- (void)setConfirmButtonTitle:(NSString *)confirmTitle cancelButtonTitle:(NSString *)cancelTitle {
    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
}


- (void)setTitle:(NSString *)title message:(NSString *)message {
    [self.titleLabel setText:title];
    [self.messageLabel setText:message];
}

- (void)setConfirmButtonTitle:(NSString *)confirmTitle {
    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [self.cancelButton removeFromSuperview];

    CGRect confirmFrame = self.cancelButton.frame;
    confirmFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(confirmFrame)) / 2;
    [self.confirmButton setFrame:confirmFrame];
}

- (IBAction)confirmPressed:(id)sender {
    [self executeActionAndDismiss:self.confirmAction];
}

- (IBAction)cancelPressed:(id)sender {
    [self executeActionAndDismiss:nil];
}

- (void)executeActionAndDismiss:(JCSActionBlock)actionBlock {
    if (actionBlock) {
        actionBlock();
    }

    [self dismiss];
}

@end
