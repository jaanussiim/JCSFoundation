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

#import <CoreData/CoreData.h>
#import "JCSFetchedCollectionViewController.h"
#import "JCSFoundationConstants.h"
#import "JCSCoreDataChangeAction.h"

NSString *const kJCSFetchedCollectionViewCellIdentifier = @"JCSFetchedCollectionViewCellIdentifier";

@interface JCSFetchedCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *allObjects;
@property (nonatomic, strong) NSMutableArray *changeActions;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation JCSFetchedCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setChangeActions:[NSMutableArray array]];
    }
    return self;
}

- (void)dealloc {
    [self.allObjects setDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerNib:self.fetchedEntityCellNib forCellWithReuseIdentifier:kJCSFetchedCollectionViewCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.allObjects) {
        NSFetchedResultsController *controller = [self createFetchedController];
        [controller setDelegate:self];
        [self setAllObjects:controller];

        JCSFLog(@"%d objects fetched", [controller.fetchedObjects count]);

        [self.collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.allObjects sections] objectAtIndex:(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJCSFetchedCollectionViewCellIdentifier forIndexPath:indexPath];
    id object = [self.allObjects objectAtIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath withObject:object];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    id tapped = [self.allObjects objectAtIndexPath:indexPath];
    [self tappedOnObject:tapped];
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    JCSFLog(@"configureCell:atIndexPath:%@", indexPath);
}


- (void)tappedOnObject:(id)tapped {
    JCSFLog(@"tapped on %@", tapped);
}

- (NSFetchedResultsController *)createFetchedController {
    JCS_ABSTRACT_METHOD;
    return nil;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.changeActions setArray:[NSArray array]];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    [self.changeActions addObject:[JCSCoreDataChangeAction actionAtIndexPath:indexPath changeType:type newIndexPath:newIndexPath]];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        NSArray *actions = [NSArray arrayWithArray:self.changeActions];
        JCSFLog(@"Perform %d update actions", [actions count]);
        for (JCSCoreDataChangeAction *action in actions) {
            NSFetchedResultsChangeType type = action.type;
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    [self.collectionView insertItemsAtIndexPaths:@[action.nextIndexPath]];
                    break;
                case NSFetchedResultsChangeDelete:
                    [self.collectionView deleteItemsAtIndexPaths:@[action.indexPath]];
                    break;
                case NSFetchedResultsChangeMove:
                    [self.collectionView moveItemAtIndexPath:action.indexPath toIndexPath:action.nextIndexPath];
                    break;
                case NSFetchedResultsChangeUpdate:
                    [self.collectionView reloadItemsAtIndexPaths:@[action.indexPath]];
                    break;
            }
        }
    } completion:^(BOOL finished) {
        [self contentChanged];
    }];
}

- (void)contentChanged {

}

@end
