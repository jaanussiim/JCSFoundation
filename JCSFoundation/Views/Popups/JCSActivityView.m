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

#import "JCSActivityView.h"
#import "UIView+LoadView.h"

@interface JCSActivityView ()

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;

@end

@implementation JCSActivityView

@synthesize messageLabel;

+ (instancetype)activityViewWithMessage:(NSString *)message {
  NSString *expectedNibName = NSStringFromClass([self class]);
  JCSActivityView *activityView = (JCSActivityView *) [UIView loadViewFromXib:expectedNibName];

  [activityView.messageLabel setText:message];

  return activityView;
}

@end
