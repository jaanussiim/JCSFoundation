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

@interface JCSSelectionViewController ()

@property (nonatomic, strong) JCSSelectionCell *measureCell;

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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.allSelectableObjects sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.allSelectableObjects sections] objectAtIndex:(NSUInteger) section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  JCSSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kJCSSelectionCellIdentifier];

  id<JCSSelectable> selectable = [self.allSelectableObjects objectAtIndexPath:indexPath];
  [cell configureWithSelectable:selectable];
  [cell markSelected:[self isSelected:selectable]];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  id<JCSSelectable> selectable = [self.allSelectableObjects objectAtIndexPath:indexPath];
  [self.measureCell configureWithSelectable:selectable];
  return CGRectGetHeight(self.measureCell.frame);
}


- (BOOL)isSelected:(id <JCSSelectable>)selectable {
  //TODO jaanus: some kind of warning here
  return NO;
}

@end
