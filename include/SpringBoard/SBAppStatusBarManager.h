
@interface SBAppStatusBarManager : NSObject
+ (id)sharedInstance;
- (_Bool)isStatusBarHidden;
- (void)hideStatusBar;
- (void)showStatusBar;
@end