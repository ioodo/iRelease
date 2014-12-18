#ifndef SETTING_CONSTANTS_H_
#define SETTING_CONSTANTS_H_

typedef enum ReleaseAction : NSUInteger {
    ReleaseActionNone    = 0,
    ReleaseActionGoHome   = 1 << 0,
    ReleaseActionQuitTopApp   = 1 << 1,
    ReleaseActionQuitAllApp   = 1 << 2,
} ReleaseAction;

#define kPlistFile            @"/var/mobile/Library/Preferences/com.ioodo.release.plist"

#define kReleaseEnable        @"enabled"
#define kLeftSideAction       @"lsa"
#define kRightSideAction      @"rsa"

#endif /*SETTING_CONSTANTS_H_*/