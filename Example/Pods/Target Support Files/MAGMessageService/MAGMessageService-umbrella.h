#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MAGMessageFrame.h"
#import "MAGMessageService.h"
#import "MAGSocketClient.h"
#import "Reachability.h"

FOUNDATION_EXPORT double MAGMessageServiceVersionNumber;
FOUNDATION_EXPORT const unsigned char MAGMessageServiceVersionString[];

