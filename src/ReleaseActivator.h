#import "ReleaseSetting.h"
#import "libactivator/libactivator.h"

@interface ReleaseActivator : NSObject <LAListener>
{
    ReleaseAction _action;
}
- (id)initWithAction:(ReleaseAction)action;
@end