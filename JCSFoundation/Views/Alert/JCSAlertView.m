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
#import "JCSAlertView.h"
#import "UIView+LoadView.h"

static NSTimeInterval const kAnimationTime = 0.3;

@interface JCSAlertView ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UIButton *confirmButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) UIView *dimView;

- (IBAction)confirmPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end

@implementation JCSAlertView

@synthesize confirmButton;
@synthesize cancelButton;
@synthesize titleLabel;
@synthesize messageLabel;

+ (instancetype)alertViewWithTitle:(NSString *)alertTitle message:(NSString *)message {
  NSString *expectedNibName = NSStringFromClass([self class]);
  JCSAlertView *alertView = (JCSAlertView *) [UIView loadViewFromXib:expectedNibName];

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

- (void)show {
  UIWindow *window = [UIApplication sharedApplication].keyWindow;

  UIView *dimView = [[UIView alloc] initWithFrame:window.bounds];
  [dimView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];

  [self setDimView:dimView];
  [self setCenter:window.center];

  [dimView setAlpha:0];
  [self setAlpha:0];

  [window addSubview:self];
  [window insertSubview:dimView belowSubview:self];

  [UIView animateWithDuration:kAnimationTime
                   animations:^{
                     [dimView setAlpha:1];
                     [self setAlpha:1];
                   }];
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

  [UIView animateWithDuration:kAnimationTime animations:^{
    [self.dimView setAlpha:0];
    [self setAlpha:0];
  } completion:^(BOOL finished) {
    [self.dimView removeFromSuperview];
    [self removeFromSuperview];
  }];
}

@end
