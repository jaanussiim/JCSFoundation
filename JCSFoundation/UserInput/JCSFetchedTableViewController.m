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

#import "JCSFetchedTableViewController.h"
#import "JCSFoundationConstants.h"

NSString *const kJCSFetchedTableViewCellIdentifier = @"JCSFetchedTableViewCellIdentifier";

@interface JCSFetchedTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *allObjects;
@property (nonatomic, strong) IBOutlet UITableView *tableView;


@end

@implementation JCSFetchedTableViewController

- (void)dealloc {
    [self.allObjects setDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:self.fetchedEntityCellNib forCellReuseIdentifier:kJCSFetchedTableViewCellIdentifier];
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

        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.allObjects sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.allObjects sections] objectAtIndex:(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJCSFetchedTableViewCellIdentifier];
    id objectAtIndexPath = [self.allObjects objectAtIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath withObject:objectAtIndexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    JCSFLog(@"configureCell:atIndexPath:%@", indexPath);
}

- (void)removeObjects {
    [self.allObjects setDelegate:nil];
    [self setAllObjects:nil];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id tapped = [self.allObjects objectAtIndexPath:indexPath];
    [self tappedOnObject:tapped];
}

- (void)tappedOnObject:(id)tapped {
    JCSFLog(@"tapped on %@", tapped);
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
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (NSFetchedResultsController *)createFetchedController {
    JCS_ABSTRACT_METHOD;
    return nil;
}

@end
