#import "ReleaseSetting.h"
#import "SettingConstants.h"

@implementation ReleaseSetting

- (void)dealloc{
    [dict release];
	[super dealloc];
}

- (BOOL)__createFile:(NSString *)propPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:propPath])
	{
        NSMutableDictionary *rootObj = [NSMutableDictionary dictionaryWithCapacity:4];
        NSData* plistData = [NSPropertyListSerialization dataWithPropertyList:rootObj
                                                                       format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
        
        [plistData writeToFile:propPath atomically:YES];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionNone
                                                               forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] setAttributes:attributes
                                         ofItemAtPath:propPath
                                                error:nil];
        
        return YES;
	}
    return NO;
}


- (void) __loadFormFile:(NSString *)propPath withCreate:(BOOL)_isCreate
{
    NSData* plistData = [NSData dataWithContentsOfFile:propPath];
    NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
    
    NSError* error = nil;
    NSDictionary *_dict = [NSPropertyListSerialization propertyListWithData:plistData
                                                                    options:NSPropertyListMutableContainersAndLeaves format:&format error:&error];
    if (error)
        NSLog(@"load plist error:%@", [error localizedDescription]);
    
    
    dict = [ [ NSMutableDictionary alloc ] initWithDictionary:_dict];
    
    if (_isCreate) {
        [self applyDefaults];
    }
}

- (id) init
{
    self = [super init];
    [self load];
    return self;
}

- (void) load
{
    BOOL _isCreate = [self __createFile:kPlistFile];
    [self __loadFormFile:kPlistFile withCreate:_isCreate];
}

- (void) applyDefaults
{
	[self applyDefault:kReleaseEnable andValue: (id)kCFBooleanFalse];
	[self applyDefault:kLeftSideAction andValueInt: ReleaseActionNone];
	[self applyDefault:kRightSideAction andValueInt: ReleaseActionNone];

	[self write];
}

- (void) applyDefault:(NSString *)key andValue:(NSString *)defaultValue
{
    
	id object = [dict objectForKey:key];
	if (object == nil)
	{
        [self setObject:defaultValue forKey:key];
	}
}

- (void) applyDefault:(NSString *)key andValueInt:(int)defaultValue
{
	[self applyDefault:key andValue:[[NSNumber numberWithInt:defaultValue ]stringValue] ];
}

- (void) setObject:(id)value forKey:(NSString *)key
{
    [dict setObject:value forKey:key ];
}

- (void) setObjectInt:(int)value forKey:(NSString *)key
{
	[self setObject:[[NSNumber numberWithInt:value ]stringValue] forKey:key ];
}

- (void) setObjectBool:(BOOL)value forKey:(NSString *)key
{
    id t = value ? (id)kCFBooleanTrue : (id)kCFBooleanFalse;
    [dict setObject:t forKey:key];
}

- (NSString *) stringForKey:(NSString *)key
{
    return [ dict objectForKey:key ];
}

- (int) intForKey:(NSString *)key
{
	NSString* value = [ self stringForKey:key ];
	return [value intValue];
}

- (BOOL) boolForKey:(NSString *)key
{
    id value = [dict objectForKey:key];
    if ( CFBooleanGetValue((CFBooleanRef)value) ) {
        return YES;
    }
    return NO;
}

- (void) write
{

    NSError *error = nil;
    NSData* plistData = [NSPropertyListSerialization dataWithPropertyList:dict
                                                                   format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
    
    if (error)
        NSLog(@"write plist error:%@", [error localizedDescription]);
    
    [plistData writeToFile:kPlistFile atomically:YES];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionNone
                                                           forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:attributes
                                     ofItemAtPath:kPlistFile
                                            error:nil];

}

@end

