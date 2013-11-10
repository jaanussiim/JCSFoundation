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

#import "JCSMultiSelectionViewController.h"
#import "JCSSelectable.h"

@interface JCSMultiSelectionViewController ()

@property (nonatomic, strong) NSMutableArray *selected;

@end

@implementation JCSMultiSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedObjects:(NSArray *)selectedObjects {
    [self setSelected:[NSMutableArray arrayWithArray:selectedObjects]];
}

- (void)addToSelected:(id <JCSSelectable>)selectable {
    [self.selected addObject:selectable];
    NSIndexPath *indexPath = [self indexPathForObject:selectable];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSArray *)selectedObjects {
    return [NSArray arrayWithArray:self.selected];
}

- (BOOL)isSelected:(id <JCSSelectable>)selectable {
    return [self.selectedObjects containsObject:selectable];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id <JCSSelectable> selected = [self objectAtIndexPath:indexPath];

    if ([self isSelected:selected]) {
        [self.selected removeObject:selected];
    } else {
        [self.selected addObject:selected];
    }

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.selectionCompletionBlock) {
        self.selectionCompletionBlock([NSArray arrayWithArray:self.selected]);
    }
}

@end
