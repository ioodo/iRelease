#import "FBApplicationProcess.h"

@interface SBApplication : NSObject
{
    FBApplicationProcess *_process;
}
- (_Bool)isRunning;
- (void)deactivate;
- (id)bundleIdentifier;
@end