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

#import "JCSPopupView.h"

static NSTimeInterval const kJCSPopupAnimationTime = 0.3;

@interface JCSPopupView ()

@property (nonatomic, strong) UIView *dimView;

@end

@implementation JCSPopupView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
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

  [UIView animateWithDuration:kJCSPopupAnimationTime
                   animations:^{
                     [dimView setAlpha:1];
                     [self setAlpha:1];
                   }];
}

- (void)dismiss {
  [UIView animateWithDuration:kJCSPopupAnimationTime animations:^{
    [self.dimView setAlpha:0];
    [self setAlpha:0];
  } completion:^(BOOL finished) {
    [self.dimView removeFromSuperview];
    [self removeFromSuperview];
  }];
}

@end
