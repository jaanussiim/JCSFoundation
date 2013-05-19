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

#import "UIView+JCSLoadView.h"

@implementation UIView (JCSLoadView)

+ (id)loadInstance {
    NSString *expectedNibName = NSStringFromClass([self class]);
    return [UIView loadViewFromXib:expectedNibName];
}

+ (UIView *)loadViewFromXib:(NSString *)xibName {
    UIView *result = nil;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:[UIView class]]) {
            result = (UIView *) currentObject;
            break;
        }
    }

    return result;
}

+ (UINib *)viewNib {
    NSString *expectedNibName = NSStringFromClass([self class]);
    return [UINib nibWithNibName:expectedNibName bundle:nil];
}

@end
