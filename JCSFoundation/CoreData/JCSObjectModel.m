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

#import "JCSObjectModel.h"
#import "JCSFoundationConstants.h"

@interface JCSObjectModel ()

@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic, copy) NSString *storeType;
@property (nonatomic, copy) NSString *dataModelName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation JCSObjectModel

- (id)initWithDataModelName:(NSString *)modelName storeType:(NSString *)storeType {
    NSURL *databaseURL = [JCSObjectModel fileUrlInDocumentsFolder:[NSString stringWithFormat:@"%@.sqlite", modelName]];
    return [self initWithDataModelName:modelName storeURL:databaseURL storeType:storeType];
}

- (id)initWithDataModelName:(NSString *)modelName storeURL:(NSURL *)storeURL storeType:(NSString *)storeType {
  self = [super init];

  if (self) {
    _dataModelName = modelName;
    _storeURL = storeURL;
    _storeType = storeType;
  }

  return self;
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity predicate:(NSPredicate *)predicate {
  return [self fetchRequestForEntity:entity predicate:predicate sortDescriptors:nil];
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors {
  return [self fetchRequestForEntity:entity predicate:nil sortDescriptors:sortDescriptors];
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setSortDescriptors:sortDescriptors];
  return fetchRequest;
}

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors {
  NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName sortDescriptors:sortDescriptors];
  NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
      initWithFetchRequest:fetchRequest
      managedObjectContext:self.managedObjectContext
        sectionNameKeyPath:nil cacheName:nil];

  NSError *fetchError = nil;
  [controller performFetch:&fetchError];
  if (fetchError) {
    JCSFLog(@"Fetch error - %@", fetchError);
  }

  return controller;
}

- (id)fetchEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    return [self fetchEntityNamed:entityName withPredicate:predicate atOffset:0];
}

- (id)fetchEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate atOffset:(NSUInteger)offset {
  NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:predicate];
  [fetchRequest setFetchOffset:offset];

  if (offset > 0) {
    [fetchRequest setFetchLimit:1];
  }

  NSError *error = nil;
  NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

  if (error != nil) {
    JCSFLog(@"Fetch error %@", error);
  }

  if ([objects count] > 1) {
    JCSFLog(@"%d objects for fetch with entity %@", [objects count], entityName);
  }

  return [objects lastObject];
}

- (id)fetchEntityNamed:(NSString *)entityName atOffset:(NSUInteger)offset {
    return [self fetchEntityNamed:entityName withPredicate:nil atOffset:offset];
}

- (NSUInteger)countInstancesOfEntity:(NSString *)entityName {
    NSFetchRequest *request = [self fetchRequestForEntity:entityName predicate:nil];

    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];

    if (error != nil) {
        JCSFLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return count;
}

- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (void)deleteObject:(NSManagedObject *)object {
  [self.managedObjectContext deleteObject:object];
  [self saveContext];
}

#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.dataModelName withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }

  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:self.storeURL options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.

     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.


     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

     * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
     @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    if (self.wipeDatabaseOnSchemaConflict) {
      NSLog(@"Wipe file at %@", self.storeURL);
      NSError *wipeError = nil;
      [[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&wipeError];
      if (wipeError) {
        NSLog(@"Wipe error:%@", wipeError);
      }

      _persistentStoreCoordinator = nil;

      return [self persistentStoreCoordinator];
    } else {
      abort();
    }
  }

  return _persistentStoreCoordinator;
}

+ (NSURL *)fileUrlInDocumentsFolder:(NSString *)fileName {
  NSURL *documentsFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
  return [documentsFolder URLByAppendingPathComponent:fileName];
}

@end
