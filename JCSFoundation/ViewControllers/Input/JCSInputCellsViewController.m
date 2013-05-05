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

#import "JCSInputCellsViewController.h"
#import "JCSTextEntryCell.h"
#import "JCSFoundationConstants.h"

@interface JCSInputCellsViewController ()

@property (nonatomic, strong) NSMutableArray *presentedCells;

@end

@implementation JCSInputCellsViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setPresentedCells:[NSMutableArray array]];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  JCSTextEntryCell *lastCell;
  for (UITableViewCell *cell in self.presentedCells) {
    if (![self isEntryCell:cell]) {
      continue;
    }

    JCSTextEntryCell *textEntryCell = (JCSTextEntryCell *) cell;
    [textEntryCell setReturnKeyType:UIReturnKeyNext];
    lastCell = textEntryCell;
  }

  [lastCell setReturnKeyType:UIReturnKeyDone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.presentedCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.presentedCells objectAtIndex:(NSUInteger) indexPath.row];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if ([self isEntryCell:cell]) {
    [self moveFocusToCell:cell];
  } else {
    [self tappedCellAtIndexPath:indexPath];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.presentedCells objectAtIndex:(NSUInteger) indexPath.row];
  return CGRectGetHeight(cell.frame);
}

- (void)addCellForPresentation:(UITableViewCell *)cell {
  [self.presentedCells addObject:cell];

  if ([cell isKindOfClass:[JCSTextEntryCell class]]) {
    JCSTextEntryCell *entryCell = (JCSTextEntryCell *) cell;
      [entryCell setFinishedEditingHandler:^(JCSTextEntryCell *textCell) {
          [textCell.entryField resignFirstResponder];
          [self moveFocusToNextEntryCell:textCell];
      }];
  }
}

- (void)moveFocusToNextEntryCell:(UITableViewCell *)cell {
  NSUInteger index = [self.presentedCells indexOfObject:cell];
  if (index == NSNotFound) {
    return;
  }

  index++;
  while (index < [self.presentedCells count]) {
    UITableViewCell *nextCell = [self.presentedCells objectAtIndex:index];
    if ([self isEntryCell:nextCell]) {
      [self moveFocusToCell:nextCell];
      return;
    }
    index++;
  }
}

- (void)moveFocusToCell:(UITableViewCell *)cell {
  if ([cell isKindOfClass:[JCSTextEntryCell class]]) {
    JCSTextEntryCell *entryCell = (JCSTextEntryCell *) cell;
    [entryCell.entryField becomeFirstResponder];
  }
}

- (BOOL)isEntryCell:(UITableViewCell *)cell {
  return [cell isKindOfClass:[JCSTextEntryCell class]];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    JCSFLog(@"tappedCellAtIndexPath:%@", indexPath);
}

@end
