//
//  EVMacros.h
//  EVFramework
//
//  Created by Joseph Hankin on 9/15/11.
//  Copyright 2011 Fuzz Productions. All rights reserved.
//


////////////////////////////////////////////////

// Standard Paths
////////////////////////////////////////////////
#define EV_DOCUMENT_PATH(inPath) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:inPath]
#define EV_BUNDLE_PATH(inPath) [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:inPath]
#define EV_TEMPORARY_PATH(inPath) [NSTemporaryDirectory() stringByAppendingPathComponent:inPath]
#define EV_CACHE_PATH(inPath) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:inPath]
////////////////////////////////////////////////
// Memory Management
////////////////////////////////////////////////
#define EV_SAFE_RELEASE(instance)		\
			if (instance != nil) {		\
				[instance release];		\
				instance = nil;			\
			}

////////////////////////////////////////////////
// Equality Tests
////////////////////////////////////////////////
#define EV_OBJECTS_EQUAL_OR_NIL(obj1, obj2) \
    ([obj1 isEqual:obj2] || (obj1 == nil && obj2 == nil))
#define EV_STRINGS_EQUAL_OR_NIL(str1, str2) \
    ([str1 isEqualToString:str2] || (str1 == nil && str2 == nil))
#define EV_IS_NOT_NULL(x) (x && ![[NSNull null] isEqual:x])

////////////////////////////////////////////////
// Strings
////////////////////////////////////////////////
#define EV_IS_EMPTY_STRING(inString) (!inString || (NSNull *)inString == [NSNull null] || [[inString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[inString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"<null>"])

#define EV_STRING_OR_NIL(inString) ( EV_IS_EMPTY_STRING(inString) ? nil : inString )
#define EV_STRING_FROM_INT(x) [NSString stringWithFormat:@"%d", x]
#define EV_STRING_FROM_DATA(data) [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]
#define EV_PERCENTAGE_FROM_FLOAT(x) [NSString stringWithFormat:@"%d%%", (int)((float)x * 100.0)]

////////////////////////////////////////////////
// Design Constants
////////////////////////////////////////////////
#define EV_AUTORESIZE_TO_FIT UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
#define EV_AUTORESIZE_TO_CENTER UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin

////////////////////////////////////////////////
// Grand Central Dispatch
////////////////////////////////////////////////
#define EV_PERFORM_ON_MAIN_QUEUE(block) \
	dispatch_async(dispatch_get_main_queue(), block)
#define EV_PERFORM_ON_BACKGROUND_QUEUE(block) \
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
#define EV_DISPATCH_AFTER(secs, block) \
    do { \
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)); \
        dispatch_after(popTime, dispatch_get_main_queue(), block); \
    } while (0)
#define EV_ONLY_PERFORM_IN_BACKGROUND(block) \
    if ([[NSThread currentThread] isMainThread]) { \
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block); \
        return; \
    } \

////////////////////////////////////////////////
// View Controllers
////////////////////////////////////////////////
#define EV_POP_OR_DISMISS()     do { if (self.presentingViewController) { [self dismissViewControllerAnimated:YES completion:NULL]; } else { [self.navigationController popViewControllerAnimated:YES]; } } while (0)

////////////////////////////////////////////////
// Colors
////////////////////////////////////////////////
#define EV_RGB_COLOR(r, g, b) [UIColor colorWithRed:(r <= 1.0 ? r : r / 255.0f) green:(g <= 1.0 ? g : g / 255.0f) blue:(b <= 1.0 ? b : b / 255.0f) alpha:1.0f]
#define EV_RGB_ALPHA_COLOR(r, g, b, a) [UIColor colorWithRed:(r <= 1.0 ? r : r / 255.0f) green:(g <= 1.0 ? g : g / 255.0f) blue:(b <= 1.0 ? b : b / 255.0f) alpha:(a <= 1.0 ? a : (a / 255.0f))]
#define EV_RETURN_STATIC_RGB_COLOR(r, g, b) \
    static UIColor *color; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        color = EV_RGB_COLOR(r, g, b); \
    }); \
    return color; \

////////////////////////////////////////////////
// Geometry
////////////////////////////////////////////////
#define EV_CENTER_POINT_OF_RECT(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))

////////////////////////////////////////////////
// Trigonometry
////////////////////////////////////////////////
#define EV_DEGREES_TO_RADIANS(degrees) (degrees * (M_PI / 180.0))
#define EV_RADIANS_TO_DEGREES(radians) (radians * (180.0 / M_PI))

////////////////////////////////////////////////
// Interface
////////////////////////////////////////////////
#define EV_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define EV_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

////////////////////////////////////////////////
// Logging
////////////////////////////////////////////////
#ifndef DLog
	#ifdef DEBUG
	#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
	#else
	#	define DLog(...)
	#endif
#endif

////////////////////////////////////////////////
// Main Bundle Shortcuts
////////////////////////////////////////////////
#define EV_APP_VERSION [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define EV_APP_BUILD [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]