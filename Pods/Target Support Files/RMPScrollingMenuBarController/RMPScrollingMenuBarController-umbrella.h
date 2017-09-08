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

#import "RMPScrollingMenuBar.h"
#import "RMPScrollingMenuBarController.h"
#import "RMPScrollingMenuBarControllerAnimator.h"
#import "RMPScrollingMenuBarControllerTransition.h"
#import "RMPScrollingMenuBarItem.h"
#import "UIViewController+RMPScrollingMenuBarControllerHelper.h"

FOUNDATION_EXPORT double RMPScrollingMenuBarControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char RMPScrollingMenuBarControllerVersionString[];

