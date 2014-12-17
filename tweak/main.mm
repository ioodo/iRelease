
extern void initHookSpringBoard();

__attribute__((constructor)) static void init()
{
    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    if ([identifier isEqualToString:@"com.apple.springboard"])
    {
        initHookSpringBoard();
    }
//    [pool release];
}


