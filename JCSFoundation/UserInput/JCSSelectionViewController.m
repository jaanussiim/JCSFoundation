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

#import "JCSSelectionViewController.h"
#import "JCSSelectionCell.h"
#import "JCSSelectable.h"

NSString *const kJCSSelectionCellIdentifier = @"JCSSelectionCellIdentifier";

@interface JCSSelectionViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) JCSSelectionCell *measureCell;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *rightBarButton;

@end

@implementation JCSSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:self.selectionCellNib forCellReuseIdentifier:kJCSSelectionCellIdentifier];
    [self setMeasureCell:[self.tableView dequeueReusableCellWithIdentifier:kJCSSelectionCellIdentifier]];

    if (self.rightBarButton) {
        [self.navigationItem setRightBarButtonItem:self.rightBarButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.selectableObjectsController setDelegate:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.selectableObjectsController) {
        return [[self.selectableObjectsController sections] count];
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectableObjectsController) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.selectableObjectsController sections] objectAtIndex:(NSUInteger) section];
        return [sectionInfo numberOfObjects];
    }

    return [self.selectableObjectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCSSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kJCSSelectionCellIdentifier];

    id <JCSSelectable> selectable = [self objectAtIndexPath:indexPath];
    [cell configureWithSelectable:selectable];
    [cell markSelected:[self isSelected:selectable]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <JCSSelectable> selectable = [self objectAtIndexPath:indexPath];
    [self.measureCell configureWithSelectable:selectable];
    return CGRectGetHeight(self.measureCell.frame);
}

- (id <JCSSelectable>)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectableObjectsController) {
        return [self.selectableObjectsController objectAtIndexPath:indexPath];
    } else {
        return [self.selectableObjectsArray objectAtIndex:(NSUInteger) indexPath.row];
    }
}

- (NSIndexPath *)indexPathForObject:(id <JCSSelectable>)object {
    if (self.selectableObjectsController) {
        return [self.selectableObjectsController indexPathForObject:object];
    }

    NSUInteger indexOfObject = [self.selectableObjectsArray indexOfObject:object];
    return [NSIndexPath indexPathForRow:indexOfObject inSection:0];
}


- (BOOL)isSelected:(id <JCSSelectable>)selectable {
    //TODO jaanus: some kind of warning here
    return NO;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch (type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
