#import "SettingConstants.h"

@interface ReleaseSetting: NSObject
{
	NSMutableDictionary* dict;
}
- (id) init;
- (void) setObject:(id)value forKey:(NSString *)key;
- (void) setObjectInt:(int)value forKey:(NSString *)key;
- (void) setObjectBool:(BOOL)value forKey:(NSString *)key;
- (NSString *) stringForKey:(NSString *)key;
- (int) intForKey:(NSString *)key;
- (BOOL) boolForKey:(NSString *)key;
- (void) write;

@end