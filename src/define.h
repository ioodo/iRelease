#ifndef RELEASE_DEFINE_H_
#define RELEASE_DEFINE_H_

#define kSettingPath        @"/var/mobile/Library/Preferences"
#define KVersion         @"0.1"
#define kPkgID      @"com.ioodo.release"
#define kReleaseServerNameFormat   @"%@.release.%d"

typedef enum {
    ReleaseOrientationLeft = 0,
    ReleaseOrientationRight,
    ReleaseOrientationBoth
} ReleaseOrientation;

#endif