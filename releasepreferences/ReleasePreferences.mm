#import <Preferences/Preferences.h>
#import "ReleaseSetting.h"

@interface ReleasePreferencesListController: PSListController {
}
@end

@implementation ReleasePreferencesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ReleasePreferences" target:self] retain];
	}
	return _specifiers;
}

-(void)appOpenUrl:(NSString *)scheme
{
    UIApplication *application = [UIApplication sharedApplication];
    
    NSURL * url = [NSURL URLWithString:scheme];
    if ([application canOpenURL:url]) {
        [application openURL:url];
    }
}

-(void)feedBack
{
    [self appOpenUrl:@"mailto:ioododev@gmail.com"];
}

- (void)visitWebSite
{
    [self appOpenUrl:@"http://www.ioodo.com"];
}

- (id)getEnabled:(PSSpecifier*)specifier
{

    ReleaseSetting *setting = [[ReleaseSetting alloc] init];
    BOOL releaseEnabled = [setting boolForKey:kReleaseEnable];
    [setting release];
    
    if (releaseEnabled)
        return (id)kCFBooleanTrue;
    return (id)kCFBooleanFalse;
}

-(void) setEnabled:(id)value specifier:(PSSpecifier*)specifier {
    
    ReleaseSetting *setting = [[ReleaseSetting alloc] init];
    [setting setObjectBool:[value boolValue] forKey:kReleaseEnable];
    [setting write];
    [setting release];
}
@end
