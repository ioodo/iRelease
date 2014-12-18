#import <Preferences/Preferences.h>
#import "ReleaseSetting.h"

@interface PSListItemsController (iRelease)
- (UITableViewCell *)tableView:(UITableView *)_tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ReleaseActionSelectController: PSListItemsController {
    NSString *releaseActionKey;
    NSUInteger releaseActions;
}
@end
