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

#import "JCSSingleSelectionViewController.h"
#import "JCSSelectable.h"

@interface JCSSingleSelectionViewController ()

@end

@implementation JCSSingleSelectionViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self scrollToSelectedCell];
}

- (void)scrollToSelectedCell {
    NSIndexPath *indexPath = [self indexPathForObject:self.selected];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}


- (BOOL)isSelected:(id <JCSSelectable>)selectable {
    return [selectable isEqual:self.selected];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id <JCSSelectable> selected = [self objectAtIndexPath:indexPath];

    if (selected == self.selected) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        NSIndexPath *index = [self indexPathForObject:self.selected];
        [self setSelected:selected];
        [tableView reloadRowsAtIndexPaths:@[indexPath, index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.selectionCompletionBlock) {
        self.selectionCompletionBlock(self.selected);
    }
}

@end
