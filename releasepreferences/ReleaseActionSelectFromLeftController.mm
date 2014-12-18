#import "ReleaseActionSelectController.h"

@interface ReleaseActionSelectFromLeftController: ReleaseActionSelectController {
}
@end

@implementation ReleaseActionSelectFromLeftController

- (id)specifiers {
    if (_specifiers == nil)
        releaseActionKey = kLeftSideAction;
    return [super specifiers];
}
@end