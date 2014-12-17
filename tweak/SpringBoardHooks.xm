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

/*
static UIWindow *__global_swc_window = nil;
static UIViewController *__global_swc_controller = nil;


%hook SpringBoard

%new(v)
- (void)_notifyPop_safewechat
{
    if (__global_swc_window)
    {
        [__global_swc_window release];
        __global_swc_window = nil;
    }
    
    if (__global_swc_controller)
    {
        [__global_swc_controller release];
        __global_swc_controller = nil;
    }
}

%end
*/

/*
static void callRelease(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{			
  	
  	SpringBoard *sb = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];
  	id top = [sb _accessibilityTopDisplay];
  	if (top != nil)
  	{
  		SBUIController *uiCon = (SBUIController *)[objc_getClass("SBUIController") sharedInstance];
  		[uiCon clickedMenuButton];
  	}
  	
		
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
			
			
			SBApplicationController *appCon = (SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance];
			SBApplication *app = [appCon applicationWithBundleIdentifier:bundleIdentifier];
			
			if ([app isRunning])
			{
				[app deactivate];
			
				FBApplicationProcess *_process = MSHookIvar<FBApplicationProcess *>(app, "_process");
				[_process _queue_processDidExit];
			}
			
			//NSLog(@"-----layout:%@", NSStringFromClass([layout class]));
			[switcherModel remove:layout];
		}
		

		SpringBoard *sb = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];

		[sb _notifyPop_safewechat];
		
    __global_swc_window = [[SWcWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    __global_swc_window.windowLevel = INT_MAX;//INT_MAX;
    
    WcAccountsViewController *controller = [[WcAccountsViewController alloc] init];
    controller.delegate = sb;
    __global_swc_controller = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller release];
    
    [__global_swc_window addSubview:__global_swc_controller.view];

}
*/

static void callRelease(ReleaseOrientation orientation)
{			
  	//killall backgrounds
  	
  	SpringBoard *sb = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];
  	id top = [sb _accessibilityTopDisplay];
  	if (top != nil)
  	{
  		//return to SpringBoard
  		SBUIController *uiCon = (SBUIController *)[objc_getClass("SBUIController") sharedInstance];
  		[uiCon clickedMenuButton];
  	}
  	
		
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
			
			//kill app process
			SBApplicationController *appCon = (SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance];
			SBApplication *app = [appCon applicationWithBundleIdentifier:bundleIdentifier];
			
			if ([app isRunning])
			{
				[app deactivate];
			
				FBApplicationProcess *_process = MSHookIvar<FBApplicationProcess *>(app, "_process");
				[_process _queue_processDidExit];
			}
			
			//remove from switcher
			[switcherModel remove:layout];
		}

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

void initHookSpringBoard()
{
	//if (![[NSFileManager defaultManager] fileExistsAtPath:kSettingPath ])
		//	[[NSFileManager defaultManager] createDirectoryAtPath:kSettingPath withIntermediateDirectories:YES attributes:nil error:nil];
	
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
}