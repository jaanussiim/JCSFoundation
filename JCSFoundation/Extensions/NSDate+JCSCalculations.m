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

#import "NSDate+JCSCalculations.h"

@implementation NSDate (JCSCalculations)

- (NSDate *)nextDay {
  return [self dateByAddinDays:1];
}

- (NSDate *)previousDay {
  return [self dateByAddinDays:-1];
}

- (NSDate *)dateByAddinDays:(NSInteger)numberOfDaysToAdd {
  NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
  [dateComponents setDay:numberOfDaysToAdd];
  return [[NSDate gregorian] dateByAddingComponents:dateComponents toDate:self options:0];
}

static NSCalendar *__gregorian;
+ (NSCalendar *)gregorian {
  if (!__gregorian) {
    __gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  }

  return __gregorian;
}

@end
