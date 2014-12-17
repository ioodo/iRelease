#import <Preferences/Preferences.h>

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
@end

// vim:ft=objc
