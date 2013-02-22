//
//  UIView+JCSLoadView.h
//  JCSFoundation
//
//  Created by Jaanus Siim on 2/12/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JCSLoadView)

+ (id)loadInstance;
+ (UIView *)loadViewFromXib:(NSString *)xibName;

@end
