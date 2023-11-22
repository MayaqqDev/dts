//
//  main.m
//  dts
//
//  Created by Maxim Baránek on 19.11.2023.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

NSString *getBundleIdentifier(NSString *appName);

void setDefaultTerminal(NSString *bundleId) {
    CFStringRef unixExecutableContentType = CFBridgingRetain(@"public.unix-executable");
    LSSetDefaultRoleHandlerForContentType(unixExecutableContentType, kLSRolesShell, CFBridgingRetain(bundleId));
    CFRelease(unixExecutableContentType);
    CFRelease((__bridge CFTypeRef)bundleId);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Check if there are enough arguments
        if (argc < 3) {
            NSLog(@"Usage: %s --path <path>", argv[0]);
            return 1;
        }

        // Compare the second argument with "--path"
        if (strcmp(argv[1], "--path") == 0) {
            NSString *path = [NSString stringWithUTF8String:argv[2]];
            NSString *bundleId = getBundleIdentifier(path);

            if (bundleId != NULL) {
                setDefaultTerminal(bundleId);
                NSLog(@"Deafult Terminal Set to %@", bundleId);
            }
        } else {
            NSLog(@"The second argument is not '--path'");
        }
    }
    return 0;
}


NSString *getBundleIdentifier(NSString *appName) {
    // Get the bundle identifier using NSBundle
    NSBundle *appBundle = [NSBundle bundleWithPath:appName];
    NSString *bundleIdentifier = [appBundle bundleIdentifier];

    if (bundleIdentifier) {
        NSLog(@"Bundle Identifier: %@", bundleIdentifier);
        return bundleIdentifier;
    } else {
        NSLog(@"Unable to retrieve the bundle identifier for the specified app path.");
        return NULL;
    }
}

