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

#import <UIKit/UIKit.h>

@class NSFetchedResultsController;

@interface JCSFetchedCollectionViewController : UIViewController

@property (nonatomic, strong) UINib *fetchedEntityCellNib;
@property (nonatomic, strong, readonly) NSFetchedResultsController *allObjects;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL ignoreOffScreenUpdates;


- (NSFetchedResultsController *)createFetchedController;
- (void)tappedOnObject:(id)tapped;
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (void)contentChanged;
- (void)changeFetchedControllerTo:(NSFetchedResultsController *)controller;
- (void)changeFetchedControllerTo:(NSFetchedResultsController *)controller fetch:(BOOL)fetch;
- (void)updateFetchedControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors;
- (void)updateFetchedControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors animate:(BOOL)animate;

@end
