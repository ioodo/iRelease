#import "ReleaseActivator.h"
#import "SBUIController.h"
#import "SpringBoard.h"
#import "SBApplication.h"
#import <objc/runtime.h>

@implementation ReleaseActivator

- (id)initWithAction:(ReleaseAction)action
{
    self = [super init];
    _action = action;
    return self;
}

- (void)activator:(id)activator receiveEvent:(LAEvent *)event {
    
    BOOL iReleaseEnabled = NO;
    
    ReleaseSetting *setting = [[ReleaseSetting alloc] init];
    iReleaseEnabled = [setting boolForKey:kReleaseEnable];
    [setting release];
    
    if (iReleaseEnabled)
        return;
    
    SBUIController *uiCon = (SBUIController *)[objc_getClass("SBUIController") sharedInstance];
    if (!uiCon)
        return;
    
    event.handled = YES;

    SpringBoard *sb = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];
    
    SBApplication *topApp = [sb _accessibilityTopDisplay];
    [uiCon clickedMenuButton];

    if (_action == ReleaseActionQuitTopApp)
        [uiCon iReleaseQuitRunningApp:[topApp bundleIdentifier]];
    else if (_action == ReleaseActionQuitAllApp)
        [uiCon iReleaseQuitRunningApps];
}

@end