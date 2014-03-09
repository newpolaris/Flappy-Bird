/*
 File: BannerViewController.m
 Abstract: A container view controller that manages an ADBannerView and a content view controller
 Version: 2.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

//  Yeah, what ^ they said!
//
//  BannerViewController.m
//  UniBase
//
//  Created by Greg Meach on 9/16/10.
//  Copyright 2010-2013 MeachWare. All rights reserved.
//
//  VERSION 2.1

#import "cocos2d.h"
#import "IntroLayer.h"

#import "BannerViewController.h"
#import "AppDelegate.h"

NSString * const BannerViewActionWillBegin = @"BannerViewActionWillBegin";
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";

// iAd position:
// 0 = bottom / 1 = top
#define kiAdPositionTop         0

// Enable to take screenshots (without ads)
#define kDisableAllAds          0

// Uncomment for MobClix
//#define MOBLCIX_ADS             1


@interface BannerViewController ()

- (void)layoutForCurrentOrientation:(BOOL)animated;
#ifdef MOBCLIX_ADS
- (void)disableMobClix;
- (void)enableMobClix;
#endif

@end


@implementation BannerViewController
{
    ADBannerView *_bannerView;
#ifdef MOBCLIX_ADS
    MobclixAdView *_adView;
#endif
    UIViewController *_contentController;

    UIView *_adContentView;
}

@synthesize allowAdInteraction, adsAreDisabled;

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskPortrait
        + UIInterfaceOrientationMaskPortraitUpsideDown;
	
	// iPad only
    return UIInterfaceOrientationMaskPortrait
    + UIInterfaceOrientationMaskPortraitUpsideDown;
}

#pragma mark !!!REQUIRED FOR LANDSCAPE ONLY APP!!!
// Prevents Game Center portrait display crash
// Only called in iOS 6
- (BOOL)shouldAutorotate
{
    return YES;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	// iPad only - ALL
	return (UIInterfaceOrientationIsLandscape(interfaceOrientation) || (UIInterfaceOrientationIsPortrait(interfaceOrientation)));
	
    // iPad Landscape ONLY
	//return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (id)initWithContentViewController:(UIViewController *)contentController
{
    self = [super init];
    if (self != nil) {
        if (!kDisableAllAds) {
            _bannerView = [[ADBannerView alloc] init];
            _bannerView.delegate = self;
            adsAreDisabled = NO;
        } else {
            adsAreDisabled = YES;
        }
        _contentController = contentController;
        
        isAniPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        
        if (!kDisableAllAds) {
            okToShowAds = YES;
#ifdef MOBCLIX_ADS
            if (isAniPad) {
                _adView = [[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0, 0.0, 728.0, 90.0)];
                _adView.delegate = self;
            } else {
                _adView = [[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
                _adView.delegate = self;
            }
            _adContentView = [[UIView alloc] initWithFrame:_adView.frame];
            [_adContentView setBackgroundColor:[UIColor blackColor]];
#endif            
            NSLog(@"Creating AdViews.....\n======> Ad Loc:%@",(kiAdPositionTop ? @"TOP" : @"BOTTOM"));
        } else {
            okToShowAds = NO;
            NSLog(@"\n!\n!!\n!!!\n--->AdViews DISABLED!!\n!!!\n!!\n!");
        }
    }
    return self;
}

- (void)loadView
{
    UIView *mainContentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self addChildViewController:_contentController];
    [mainContentView addSubview:_contentController.view];

    if (!kDisableAllAds) {
        [mainContentView addSubview:_bannerView];
#ifdef MOBCLIX_ADS
        [mainContentView addSubview:_adView];
        _adView.hidden = TRUE;
#endif
        // allow ad interaction until the game is played
        allowAdInteraction = YES;
    }
    [_contentController didMoveToParentViewController:self];
    self.view = mainContentView;
    [mainContentView release];
    
    [self layoutForCurrentOrientation:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLayoutSubviews
{
    [self layoutForCurrentOrientation:YES];    
}

-(void)layoutForCurrentOrientation:(BOOL)animated
{
    CGFloat animationDuration = animated ? 0.2 : 0.0;
        
#ifndef MOBCLIX_ADS
    UIView *_adView = [[UIView alloc] initWithFrame:CGRectZero];
#endif

    float leftBorder = 0.0f;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        if (isAniPad)
            leftBorder = 20.0f;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        if (isAniPad)
            leftBorder = 128.0f;
        else
            leftBorder = ([[AppController sharedAppDelegate] isAniPhone5] ? 124.0f : 80.0f);
    }
    
    // Define Rect's to be used
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    
    if (okToShowAds) {
        if (kiAdPositionTop) {
            if(isAniPad) {
                _adContentView.frame = CGRectMake(leftBorder, 0.0, 728.0, 90.0);
            } else {
                _adContentView.frame = CGRectMake(leftBorder, 0.0, 320.0, 50.0);
            }
        } else {
            if(isAniPad) {
                _adContentView.frame = CGRectMake(leftBorder, contentFrame.size.height-90.0, 728.0, 90.0);
            } else {
                _adContentView.frame = CGRectMake(leftBorder, contentFrame.size.height-50.0, 480.0, 50.0);
            }
        }
        
        // Remember: Uses UIView coordinate system
        if (_bannerView.bannerLoaded) {
            if (kiAdPositionTop) {
                bannerFrame.origin.y = 0.0;
            } else {
                bannerFrame.origin.y = (contentFrame.size.height-_bannerView.frame.size.height);
            }
            _adView.hidden = YES;
            NSLog(@"[iAd]: Ad Loaded");
        } else {
            if (kiAdPositionTop) {
                bannerFrame.origin.y -= _bannerView.frame.size.height;
            } else {
                bannerFrame.origin.y = contentFrame.size.height;
            }
            _adView.hidden = NO;
            NSLog(@"[iAd]: No Ad...");
        }
    } else { //NOT okToShowAds
        if (kiAdPositionTop) {
            if(isAniPad) {
                _adContentView.frame = CGRectMake(leftBorder, -90.0, 728.0, 90.0);
            } else {
                _adContentView.frame = CGRectMake(leftBorder, -50.0, 320.0, 50.0);
            }
            bannerFrame = CGRectMake(_bannerView.frame.origin.x, -_bannerView.frame.size.height, _bannerView.frame.size.width, _bannerView.frame.size.height);
        } else {
            if(isAniPad) {
                _adContentView.frame = CGRectMake(leftBorder, contentFrame.size.height+90.0, 728.0, 90.0);
            } else {
                _adContentView.frame = CGRectMake(leftBorder, contentFrame.size.height+50.0, 480.0, 50.0);
            }
            bannerFrame = CGRectMake(_bannerView.frame.origin.x, contentFrame.size.height+_bannerView.frame.size.height, _bannerView.frame.size.width, _bannerView.frame.size.height);
        }
    }
    
    _contentController.view.frame = contentFrame;
        
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         _bannerView.frame = bannerFrame;
                         _adView.frame = _adContentView.frame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
#ifdef MOBCLIX_ADS
                             if (okToShowAds)
                                 [_adView resumeAdAutoRefresh];
                             else
                                 [_adView pauseAdAutoRefresh];
#endif
                         }
                     }];
    
}

#pragma mark ADBannerViewDelegate methods
- (BOOL)allowActionToRun
{
	NSLog(@"Okay for Ad's: %@", (allowAdInteraction ? @"YES" : @"NO"));
    return allowAdInteraction;  // only if game is not running
}

- (void) stopActionsForAd
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kPauseAudio" object:nil];
}

- (void) startActionsForAd
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kResumeAudio" object:nil];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	BOOL shouldExecuteAction = [self allowActionToRun];
	if (!willLeave && shouldExecuteAction)
	{
		// insert code here to suspend any services that might conflict with the advertisement
		[self stopActionsForAd];
	}
	return shouldExecuteAction;
	
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	NSLog(@"[iAd]: Action finished.");
	[self startActionsForAd];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
#ifdef MOBCLIX_ADS
    if (_adView != nil) {
        adViewLoaded = NO;
        adViewPaused = YES;
        [_adView pauseAdAutoRefresh];
        NSLog(@"[AdView] paused for iAd Banner");
    }
#endif
    [self layoutForCurrentOrientation:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
#ifdef MOBCLIX_ADS
    if (_adView != nil) {
        [_adView resumeAdAutoRefresh];
        NSLog(@"[AdView] resume");
    } else {
        adViewLoaded = NO;
    }
#endif
    [self layoutForCurrentOrientation:YES];
}

#ifdef MOBCLIX_ADS
#pragma mark -MobClix
- (void)adViewDidFinishLoad:(MobclixAdView*)adView {
    NSLog(@"[AdView] didLoad");
    adViewLoaded = YES;
}
- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error {
    NSLog(@"[AdView] didFail: %@",error.description);
    adViewLoaded = NO;
}
- (BOOL)adViewCanAutoplay:(MobclixAdView*)adView {
    return (!adViewPaused);
}
- (void)disableMobClix {
    NSLog(@"[AdView] disabled");
    adViewPaused = YES;
    allowAdInteraction = NO;
    [_adView pauseAdAutoRefresh];
}
- (void)enableMobClix {
    NSLog(@"[AdView] enabled");
    [_adView resumeAdAutoRefresh];
    adViewPaused = NO;
    allowAdInteraction = YES;
}
#else
// Not used in non-MobClix config
- (void)disableMobClix {
    
}
- (void)enableMobClix {
    
}
#endif


-(void)forceAdViewToHide:(BOOL)hide
{
    okToShowAds = !hide;
    if(hide) {
        [self disableMobClix];
    } else {
        [self enableMobClix];
    }
    
    [self layoutForCurrentOrientation:YES];
}


@end
