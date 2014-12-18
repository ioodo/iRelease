#import "ReleaseActionSelectController.h"

@interface ReleaseActionSelectFromRightController: ReleaseActionSelectController {
}
@end

@implementation ReleaseActionSelectFromRightController

- (id)specifiers {
    if (_specifiers == nil)
        releaseActionKey = kRightSideAction;
    return [super specifiers];
}
@end