#import "ReleaseActionSelectController.h"

@implementation ReleaseActionSelectController

- (ReleaseAction)actionFromRow:(int)row
{
    switch (row)
    {
        case 1:
            return ReleaseActionGoHome;
        case 2:
            return ReleaseActionQuitTopApp;
        case 3:
            return ReleaseActionQuitAllApp;
        default:
            return ReleaseActionNone;
    }
}

- (id)specifiers {
	if(_specifiers == nil)
    {
        ReleaseSetting *setting = [[ReleaseSetting alloc] init];
        releaseActions = [setting intForKey:releaseActionKey];
        [setting release];
    }
    id specs = [super specifiers];
    return specs;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:_tableView cellForRowAtIndexPath:indexPath];

    ReleaseAction action = [self actionFromRow:[indexPath row]];
    
    if ((releaseActions & action) == 0)
    {
        if (action == ReleaseActionNone && (releaseActions == 0))
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_specifiers)
        return;
    
    ReleaseAction action = [self actionFromRow:[indexPath row]];
    if ((releaseActions & action) == 0)
    {
        if (action == ReleaseActionNone)
            releaseActions = 0;
        else
            releaseActions = (releaseActions | action);
    }
    else
        releaseActions = releaseActions - (releaseActions & action);
    
    if (releaseActionKey)
    {
        ReleaseSetting *setting = [[ReleaseSetting alloc] init];
        [setting setObjectInt:releaseActions forKey:releaseActionKey];
        [setting write];
        [setting release];
    }
    
    [_tableView reloadData];
}

@end
