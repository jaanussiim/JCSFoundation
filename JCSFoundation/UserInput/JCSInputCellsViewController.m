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
#import "UIApplication+Keyboard.h"
#import "JCSInlinePickerCell.h"

@interface JCSInputCellsViewController ()

@property (nonatomic, strong) NSMutableArray *presentedSections;
@property (nonatomic, strong) NSMutableArray *openSection;
@property (nonatomic, strong) NSMutableDictionary *pickerCells;
@property (nonatomic, strong) NSIndexPath *presentingPickerForIndexPath;

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

    [self setPresentedSections:[NSMutableArray array]];
    [self setOpenSection:[NSMutableArray array]];
    [self setPickerCells:[NSMutableDictionary dictionary]];
    [self.presentedSections addObject:self.openSection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    JCSTextEntryCell *lastCell;
    for (NSArray *sectionCells in self.presentedSections) {
        for (UITableViewCell *cell in sectionCells) {
            if (![self isEntryCell:cell]) {
                continue;
            }

            JCSTextEntryCell *textEntryCell = (JCSTextEntryCell *) cell;
            [textEntryCell setReturnKeyType:UIReturnKeyNext];
            lastCell = textEntryCell;
        }
    }

    [lastCell setReturnKeyType:UIReturnKeyDone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.presentedSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presentedSections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.presentedSections[indexPath.section][indexPath.row];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self isCellEditable:cell]) {
        [self moveFocusToCell:cell];
    } else if ([self hasInlinePickerAttachedAtIndexPath:indexPath]) {
        [UIApplication dismissKeyboard];
        [self handleInlinePickerForIndexPath:indexPath];
    } else {
        [UIApplication dismissKeyboard];
        [self tappedCellAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.presentedSections[indexPath.section][indexPath.row];
    return CGRectGetHeight(cell.frame);
}

- (NSIndexPath *)addCellForPresentation:(UITableViewCell *)cell {
    NSUInteger index = [self.openSection count];
    [self.openSection addObject:cell];

    if ([cell isKindOfClass:[JCSTextEntryCell class]]) {
        JCSTextEntryCell *entryCell = (JCSTextEntryCell *) cell;
        [entryCell setFinishedEditingHandler:^(JCSTextEntryCell *textCell) {
            [textCell.entryField resignFirstResponder];
            [self moveFocusToNextEntryCell:textCell];
        }];
    }

    return [NSIndexPath indexPathForRow:index inSection:self.presentedSections.count - 1];
}

- (void)moveFocusToNextEntryCell:(UITableViewCell *)cell {
    NSIndexPath *currentIndexPath = [self indexPathForCell:cell];
    if (currentIndexPath == nil) {
        return;
    }

    NSIndexPath *moveToIndexPath = [self nextEditableCellAfterIndexPath:currentIndexPath];
    if (moveToIndexPath == nil) {
        [UIApplication dismissKeyboard];
        return;
    }

    UITableViewCell *nextFocused = self.presentedSections[moveToIndexPath.section][moveToIndexPath.row];
    [self moveFocusToCell:nextFocused];
}

- (NSIndexPath *)nextEditableCellAfterIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) indexPath.row;

    for (; section < [self.presentedSections count]; section++) {
        NSArray *sectionCells = self.presentedSections[section];
        for (; row < [sectionCells count]; row++) {
            id cell = sectionCells[row];
            if (![self isEntryCell:cell]) {
                continue;
            }

            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            if ([path isEqual:indexPath]) {
                continue;
            }

            JCSTextEntryCell *entryCell = cell;
            if (![entryCell.entryField isEnabled]) {
                continue;
            }

            return path;
        }

        row = 0;
    }

    return nil;
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    NSInteger section = 0;
    for (NSArray *cells in self.presentedSections) {
        NSInteger row = 0;
        for (UITableViewCell *checked in cells) {
            if (checked == cell) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }

            row++;
        }
        section++;
    }

    return nil;
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

- (BOOL)isCellEditable:(UITableViewCell *)cell {
    if (![self isEntryCell:cell]) {
        return NO;
    }

    JCSTextEntryCell *entryCell = (JCSTextEntryCell *) cell;
    return [entryCell isEnabled];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    JCSFLog(@"tappedCellAtIndexPath:%@", indexPath);
}

- (void)closeSection {
    [self setOpenSection:[NSMutableArray array]];
    [self.presentedSections addObject:self.openSection];
}

- (void)addInlinePickerCell:(JCSInlinePickerCell *)pickerCell forIndexPath:(NSIndexPath *)indexPath {
    self.pickerCells[indexPath] = pickerCell;
}

- (NSUInteger)currentOpenSection {
    return self.presentedSections.count - 1;
}

- (BOOL)hasInlinePickerAttachedAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *checked = [self indexPathWithoutPossiblePickerOffset:indexPath];
    return self.pickerCells[checked] != nil;
}

- (void)handleInlinePickerForIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];

    NSIndexPath *handled = [self indexPathWithoutPossiblePickerOffset:indexPath];

    NSIndexPath *previous = self.presentingPickerForIndexPath;
    if (previous) {
        [self dismissPickerForIndexPath:previous];
    }

    if (![handled isEqual:previous]) {
        [self presentPickerForIndexPath:handled];
    }

    [self.tableView endUpdates];
}

- (void)presentPickerForIndexPath:(NSIndexPath *)indexPath {
    JCSInlinePickerCell *pickerCell = self.pickerCells[indexPath];
    NSIndexPath *insertPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    NSMutableArray *section = self.presentedSections[insertPath.section];
    [section insertObject:pickerCell atIndex:insertPath.row];

    [self.tableView insertRowsAtIndexPaths:@[insertPath] withRowAnimation:UITableViewRowAnimationFade];

    if (pickerCell.willPresentHandler) {
        pickerCell.willPresentHandler();
    }

    [self setPresentingPickerForIndexPath:indexPath];
}

- (void)dismissPickerForIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *removePath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    NSMutableArray *section = self.presentedSections[removePath.section];
    [section removeObjectAtIndex:removePath.row];

    [self.tableView deleteRowsAtIndexPaths:@[removePath] withRowAnimation:UITableViewRowAnimationFade];

    [self setPresentingPickerForIndexPath:nil];
}

- (NSIndexPath *)indexPathWithoutPossiblePickerOffset:(NSIndexPath *)indexPath {
    if (!self.presentingPickerForIndexPath || self.presentingPickerForIndexPath.section != indexPath.section || self.presentingPickerForIndexPath.row >= indexPath.row) {
        return indexPath;
    }

    return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
}

@end
