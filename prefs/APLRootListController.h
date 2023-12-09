#import <Preferences/PSListController.h>
#import <AltList/AltList.h>
#import "Common.h"

#define IS_ENABLED_CELL_INDEXPATH [NSIndexPath indexPathForRow:0 inSection:0]
#define BIOMETRIC_CELL_INDEXPATH [NSIndexPath indexPathForRow:1 inSection:0]
#define PASSCODE_CELL_INDEXPATH [NSIndexPath indexPathForRow:2 inSection:0]

@interface APLRootListController : ATLApplicationListMultiSelectionController {
    UITableView* _table;
}

// -(UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
// -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
