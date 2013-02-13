//
//  UIView+LoadView.m
//  JCSFoundation
//
//  Created by Jaanus Siim on 2/12/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import "UIView+LoadView.h"

@implementation UIView (LoadView)

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

@end
