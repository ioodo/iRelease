#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>
#include <notify.h>
#include <objc/runtime.h>
#import "define.h"

%hook UIStatusBar

- (id)initWithFrame:(struct CGRect)arg1 showForegroundView:(BOOL)arg2 inProcessStateProvider:(id)arg3
{
	id orig = %orig;
	
	UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__releasePressGesture:)];
	tapGesture.minimumPressDuration = 0.5;
	[orig addGestureRecognizer:tapGesture];
	[tapGesture release];
	return orig;
}

%new
- (void)__releasePressGesture:(UITapGestureRecognizer *)gr
{
	if (gr.state == UIGestureRecognizerStateEnded)
	{
			UIView *view = (UIView *)self;
			
			CGRect frame = view.bounds;
			CGPoint point = [gr locationInView:view];
			
			ReleaseOrientation orientation = ReleaseOrientationBoth;
			
			if (point.x >= 0 && point.x <= 70)
					orientation = ReleaseOrientationLeft;
			else if (point.x >= frame.size.width - 70)
					orientation = ReleaseOrientationRight;
			
			if (orientation != ReleaseOrientationBoth)
			{				
				NSString *serverName = [NSString stringWithFormat:kReleaseServerNameFormat, kPkgID, orientation];
        notify_post([serverName UTF8String]);
			}
	}
}

%end