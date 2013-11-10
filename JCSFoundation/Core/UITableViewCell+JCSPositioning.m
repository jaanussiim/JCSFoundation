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

#import "UITableViewCell+JCSPositioning.h"

@implementation UITableViewCell (JCSPositioning)

+ (void)adjustWidthForTitle:(UIView *)title value:(UIView *)value {
    CGRect titleFrame = title.frame;
    CGSize titleSize = [title sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(titleFrame))];
    CGFloat widthChange = titleSize.width - CGRectGetWidth(titleFrame);
    titleFrame.size.width += widthChange;
    [title setFrame:titleFrame];

    CGRect valueFrame = value.frame;
    valueFrame.origin.x += widthChange;
    valueFrame.size.width -= widthChange;
    [value setFrame:valueFrame];
}

@end
