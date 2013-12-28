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

#import "JCSQuickActionSheet.h"
#import "JCSFoundationConstants.h"

@interface JCSQuickActionSheet () <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableDictionary *actionsMapping;

@end

@implementation JCSQuickActionSheet

+ (id)actionSheetWithMessage:(NSString *)message {
    JCSQuickActionSheet *actionSheet = [[JCSQuickActionSheet alloc] initWithTitle:message
                                                                         delegate:nil
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];
    [actionSheet setDelegate:actionSheet];
    return actionSheet;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (NSInteger)addButtonWithTitle:(NSString *)title action:(JCSActionBlock)action {
    NSInteger index = [self addButtonWithTitle:title];
    [self.actionsMapping setObject:action forKey:@(index)];
    return index;
}

- (void)addCancelButtonWithTitle:(NSString *)title action:(JCSActionBlock)action {
    NSInteger index = [self addButtonWithTitle:title];
    [self.actionsMapping setObject:action forKey:@(index)];
    [self setCancelButtonIndex:index];
}

- (void)addDestructiveButtonWithTitle:(NSString *)title action:(JCSActionBlock)action {
    NSInteger index = [self addButtonWithTitle:title];
    [self.actionsMapping setObject:action forKey:@(index)];
    [self setDestructiveButtonIndex:index];
}

- (NSMutableDictionary *)actionsMapping {
    if (!_actionsMapping) {
        _actionsMapping = [[NSMutableDictionary alloc] init];
    }

    return _actionsMapping;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    JCSActionBlock action = [self.actionsMapping objectForKey:@(buttonIndex)];
    if (action) {
        action();
    }
}

@end
