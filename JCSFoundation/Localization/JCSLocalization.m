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

#import "JCSLocalization.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
    _sharedObject = block(); \
  }); \
  return _sharedObject; \

@interface JCSLocalization ()

@property (nonatomic, strong) NSBundle *languageBundle;

@end

@implementation JCSLocalization

+ (JCSLocalization *)sharedInstance {
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[JCSLocalization alloc] initSingleton];
  });
}

- (id)init {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                   NSStringFromClass([self class]),
                                                                   NSStringFromSelector(@selector(sharedInstance))]
                               userInfo:nil];
  return nil;
}

- (id)initSingleton {
  self = [super init];

  if (self) {

  }

  return self;
}

- (NSString *)localizedStringForKey:(NSString *)key {
  return NSLocalizedStringFromTableInBundle(key, @"", [self languageBundle], nil);
}

- (NSBundle *)languageBundle {
  if (_languageBundle) {
    return _languageBundle;
  }

  if (!self.forcedLocale) {
    [self setForcedLocale:[NSLocale systemLocale]];
  }

  NSString *languageCode = [self.forcedLocale objectForKey:NSLocaleLanguageCode];
  NSBundle *bundle = [self loadLanguageBundleWithCode:languageCode];

  if (!bundle) {
    bundle = [self loadLanguageBundleWithCode:@"en"];
  }

  [self setLanguageBundle:bundle];

  return bundle;
}

- (NSBundle *)loadLanguageBundleWithCode:(NSString *)languageCode {
  return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"]];
}

@end
