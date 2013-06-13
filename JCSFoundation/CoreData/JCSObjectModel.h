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

#import <Foundation/Foundation.h>
#import "JCSFoundationConstants.h"

@interface JCSObjectModel : NSObject

@property (nonatomic, assign) BOOL wipeDatabaseOnSchemaConflict;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithDataModelName:(NSString *)modelName storeType:(NSString *)storeType;
- (id)initWithDataModelName:(NSString *)modelName storeURL:(NSURL *)storeURL storeType:(NSString *)storeType;

- (id)spawnBackgroundInstance;

- (void)saveContext;
- (void)saveContext:(JCSActionBlock)completion;

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName;
- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors;

- (id)fetchEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (id)fetchEntityNamed:(NSString *)entityName atOffset:(NSUInteger)offset;

- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchEntitiesNamed:(NSString *)entityName withSortDescriptors:(NSArray *)descriptors;

- (NSUInteger)countInstancesOfEntity:(NSString *)entityName;

- (BOOL)hasExistingEntity:(NSString *)entityName checkAttributeNamed:(NSString *)attributeName attributeValue:(NSString *)attributeValue;

- (void)deleteObject:(NSManagedObject *)object;

+ (NSURL *)fileUrlInDocumentsFolder:(NSString *)fileName;

@end
