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

#import "JCSCoreDataChangeAction.h"

@interface JCSCoreDataChangeAction ()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSFetchedResultsChangeType type;
@property (nonatomic, strong) NSIndexPath *nextIndexPath;

@end

@implementation JCSCoreDataChangeAction

+ (JCSCoreDataChangeAction *)actionAtIndexPath:(NSIndexPath *)indexPath changeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)nextIndexPath {
    JCSCoreDataChangeAction *action = [[JCSCoreDataChangeAction alloc] init];
    [action setIndexPath:indexPath];
    [action setType:type];
    [action setNextIndexPath:nextIndexPath];
    return action;
}

@end
