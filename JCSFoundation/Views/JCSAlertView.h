//
//  JCSAlertView.h
//  JCSFoundation
//
//  Created by Jaanus Siim on 2/24/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCSAlertView <NSObject>

+ (id)alertViewWithTitle:(NSString *)alertTitle message:(NSString *)message;

- (void)setConfirmButtonTitle:(NSString *)confirmTitle;
- (void)show;

@end
