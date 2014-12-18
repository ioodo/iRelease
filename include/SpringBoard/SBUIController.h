
@interface SBUIController : NSObject
+ (id)sharedInstance;
- (_Bool)clickedMenuButton;
@end

@interface SBUIController (iRelease)
- (void) iReleaseQuitRunningApps;
- (void) iReleaseQuitRunningApp:(NSString *)bundleIdentifier;
- (void) iReleaseKillRunningApp:(NSString *)bundleIdentifier;
@end