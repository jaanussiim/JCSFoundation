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
#import "JCSFoundationConstants.h"
#import "JCSPopupView.h"
#import "JCSAlertView.h"

@interface JCSPopupAlertView : JCSPopupView <JCSAlertView>

@property (nonatomic, copy) JCSActionBlock confirmAction;
@property (nonatomic, strong, readonly) UIButton *confirmButton;
@property (nonatomic, strong, readonly) UIButton *cancelButton;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;


+ (instancetype)alertViewWithTitle:(NSString *)alertTitle message:(NSString *)message;

- (void)setConfirmButtonTitle:(NSString *)confirmTitle cancelButtonTitle:(NSString *)cancelTitle;
- (void)setConfirmButtonTitle:(NSString *)confirmTitle;

@end
