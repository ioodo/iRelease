#include <substrate.h>
#include <objc/runtime.h>
#import "FBApplicationProcess.h"
#import "SBUIController.h"
#import "SBAppSwitcherModel.h"
#import "SBDisplayLayout.h"
#import "SBDisplayItem.h"
#import "SBApplicationController.h"
#import "SBApplication.h"
#import "SpringBoard.h"
#import "define.h"
#import "ReleaseSetting.h"

static void callRelease(ReleaseOrientation orientation)
{		
		ReleaseSetting *setting = [[ReleaseSetting alloc] init];
		
		BOOL releaseEnabled = [setting boolForKey:kReleaseEnable];
		NSUInteger action = ReleaseActionNone;
		
		if (orientation == ReleaseOrientationLeft)
				action = [setting intForKey:kLeftSideAction];
		else
				action = [setting intForKey:kRightSideAction];
		
		[setting release];
		
		if (!releaseEnabled)
				return;
		
		if (action == ReleaseActionNone)
				return;
  	
  	NSUInteger quitAllAction = action & ReleaseActionQuitAllApp;
  	NSUInteger quitTopAppAction = action & ReleaseActionQuitTopApp;
  	
  	SpringBoard *sb = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];
  	SBUIController *uiCon = (SBUIController *)[objc_getClass("SBUIController") sharedInstance];
  	
  	SBApplication *topApp = [sb _accessibilityTopDisplay];
  	
  	if (topApp != nil)
  	{  		
  		//return to SpringBoard
  		[uiCon clickedMenuButton];
  		
			if (quitAllAction == 0 && quitTopAppAction != 0)
			{
					[uiCon iReleaseQuitRunningApp:[topApp bundleIdentifier]];
			}
			
  	}
  	
  	if (quitAllAction != 0)
  		[uiCon iReleaseQuitRunningApps];
}
	
static void callRelease_0(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	callRelease(ReleaseOrientationLeft);
}

static void callRelease_1(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	callRelease(ReleaseOrientationRight);
}

typedef void (*fun_ptr_t)(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);
static fun_ptr_t GetFuncPointer(const char* sfuncname)
{
    if(strcmp(sfuncname,"callRelease_0")==0)
    {
         return &callRelease_0;
    }else if(strcmp(sfuncname,"callRelease_1")==0){
         return &callRelease_1;
    }
    return NULL;                                                                                                  
}

%group HookSB

%hook SBUIController

%new(v)
- (void) iReleaseQuitRunningApps
{
		SBAppSwitcherModel *switcherModel = (SBAppSwitcherModel *)[objc_getClass("SBAppSwitcherModel") sharedInstance];
		
		NSMutableArray *layouts = MSHookIvar<NSMutableArray *>(switcherModel, "_recentDisplayLayouts");
		for (int i = [layouts count]-1; i >= 0; i--)
		{
			SBDisplayLayout *layout = [layouts objectAtIndex:i];
			
			
			NSString *bundleIdentifier = nil;
			NSArray *items = [layout displayItems];

			if (items != nil && [items count] > 0) {
				SBDisplayItem *item = (SBDisplayItem *)[items objectAtIndex:0];
				bundleIdentifier = [item displayIdentifier];
			}
			
			if (bundleIdentifier == nil)
				continue;
			
			[self iReleaseKillRunningApp:bundleIdentifier];
			
			//remove from switcher
			[switcherModel remove:layout];
		}
}

%new(v@)
- (void) iReleaseQuitRunningApp:(NSString *)bundleIdentifier
{
		SBAppSwitcherModel *switcherModel = (SBAppSwitcherModel *)[objc_getClass("SBAppSwitcherModel") sharedInstance];
		
		SBDisplayLayout *layout = nil;
		
		NSMutableArray *layouts = MSHookIvar<NSMutableArray *>(switcherModel, "_recentDisplayLayouts");
		for (int i = [layouts count]-1; i >= 0; i--)
		{
			SBDisplayLayout *_layout = [layouts objectAtIndex:i];
			
			NSString *_bundleIdentifier = nil;
			NSArray *items = [_layout displayItems];

			if (items != nil && [items count] > 0) {
				SBDisplayItem *item = (SBDisplayItem *)[items objectAtIndex:0];
				_bundleIdentifier = [item displayIdentifier];
			}
			
			if (_bundleIdentifier == nil)
				continue;
				
			if ([bundleIdentifier isEqualToString:_bundleIdentifier])
			{
					layout = _layout;
					break;
			}
		}
		
		[self iReleaseKillRunningApp:bundleIdentifier];
		
		//remove from switcher
		if (layout)
				[switcherModel remove:layout];				
}

%new(v@)
- (void) iReleaseKillRunningApp:(NSString *)bundleIdentifier
{
		SBApplicationController *appCon = (SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance];
		SBApplication *app = [appCon applicationWithBundleIdentifier:bundleIdentifier];
			
		if ([app isRunning])
		{
				[app deactivate];
			
				FBApplicationProcess *_process = MSHookIvar<FBApplicationProcess *>(app, "_process");
				[_process _queue_processDidExit];
		}
}

%end

%end

void initHookSpringBoard()
{

	ReleaseSetting *setting = [[ReleaseSetting alloc] init];
	[setting release];
		
	int releaseOrientations[2]={ ReleaseOrientationLeft, ReleaseOrientationRight };
	for (int i = 0; i < 2; i++)
	{
			NSString *serverName = [NSString stringWithFormat:kReleaseServerNameFormat, kPkgID, releaseOrientations[i]];	
			NSString *funName = [NSString stringWithFormat:@"callRelease_%d", releaseOrientations[i]];	
			const char *funNameChar =[funName UTF8String];
			
			fun_ptr_t ptr = GetFuncPointer(funNameChar);
			if (ptr != NULL)
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, 
							ptr, (CFStringRef)serverName, NULL, CFNotificationSuspensionBehaviorCoalesce);		
							
	}
	
	%init(HookSB);
}