//
//  SlateActivityIndicatorView.m
//  SlateCore
//
//  Created by wangliqun on 1/01/14.
//  Copyright (c) 2015 mmslate. All rights reserved.
//

#import "SlateActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

#define IsPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

@interface UIImage (imageNamedInBundle)
+ (UIImage*)imageNamed:(NSString*)name inBundle:(NSBundle *)bundle;
@end

@implementation UIImage (imageNamedInBundle)
+ (UIImage*)imageNamed:(NSString*)name inBundle:(NSBundle *)bundle
{
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)])
    {
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[[bundle resourcePath] stringByAppendingPathComponent:name]];
        return image;
    }
}
@end

@interface SlateActivityIndicatorView ()

- (UIImage *)activityIndicatorImageWithStyle:(SlateActivityIndicatorViewStyle)style;

@end

@implementation SlateActivityIndicatorView
{
    BOOL                         _animating;
    UIImageView                  *_image;
}

@synthesize hidesWhenStopped;

- (instancetype)initWithViewStyle:(SlateActivityIndicatorViewStyle)style withBgView:(BOOL)withBgView
{
    _style = style;
    _hasBgView = withBgView;

    CGRect f = CGRectZero;
    if ((_style == ActivityIndicatorViewStyleGray) || (_style == ActivityIndicatorViewStyleWhite))
    {
        f.size = CGSizeMake(50.0, 50.0);
        if (IsPhone)
        {
            f.size = CGSizeMake(19.0, 19.0);
        }
    }
    else
    {
        f.size = CGSizeMake(106.0, 106.0);
    }
    
    self = [super initWithFrame:f];
    if (self)
    {
        self.hidesWhenStopped = YES;
        if (withBgView)
        {
            UIView *bgView = [[UIView alloc] initWithFrame:f];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            bgView.layer.cornerRadius = 5.0f;
            bgView.layer.masksToBounds = YES;
            [self addSubview:bgView];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect f = frame;
    if (IsPhone)
    {
        f.size = CGSizeMake(19.0, 19.0);
    }
    else
    {
        f.size = CGSizeMake(50.0, 50.0);
    }
    
    self = [super initWithFrame:f];
    if (self) {
        self.hidesWhenStopped = YES;
        _style = ActivityIndicatorViewStyleGray;
        _animating = NO;
    }
    return self;
}

- (void)setup
{
    if (!_image)
    {
        CGRect f = CGRectZero;
        if ((_style == ActivityIndicatorViewStyleGray) || (_style == ActivityIndicatorViewStyleWhite))
        {
            f.size = CGSizeMake(20.0, 20.0);
            if (IsPhone)
            {
                f.size = CGSizeMake(19.0, 19.0);
            }
        }
        else
        {
            f.size = CGSizeMake(76.0, 76.0);
        }
        f.origin = CGPointMake(floorf((self.bounds.size.width - f.size.width) * 0.5f), floorf((self.bounds.size.height - f.size.height) * 0.5f));
        
        _image = [[UIImageView alloc] initWithFrame:f];
        _image.image = [self activityIndicatorImageWithStyle:self.style];
        [self addSubview:_image];
    }
}

- (UIImage *)activityIndicatorImageWithStyle:(SlateActivityIndicatorViewStyle)style
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = nil;
    
    if (style == ActivityIndicatorViewStyleWhite)
    {
        image = [UIImage imageNamed:@"ActivityIndicator.bundle/ipad_white" inBundle:bundle];
        if (IsPhone)
        {
            image = [UIImage imageNamed:@"ActivityIndicator.bundle/iphone_white" inBundle:bundle];
        }
    }
    else if (style == ActivityIndicatorViewStyleWhiteLarge)
    {
        image = [UIImage imageNamed:@"ActivityIndicator.bundle/white_large" inBundle:bundle];
    }
    else if (style == ActivityIndicatorViewStyleGray)
    {
        image = [UIImage imageNamed:@"ActivityIndicator.bundle/ipad_gray" inBundle:bundle];
        if (IsPhone)
        {
            image = [UIImage imageNamed:@"ActivityIndicator.bundle/iphone_gray" inBundle:bundle];
        }
    }
    else
    {
        image = [UIImage imageNamed:@"ActivityIndicator.bundle/gray_large" inBundle:bundle];
    }
    return image;
}

- (void)startAnimating
{
    if (_animating)
    {
        [_image.layer removeAllAnimations];
    }
    
    [self setup];

    self.hidden = NO;
    _animating = YES;

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.2];
    rotationAnimation.duration = 0.15;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;

    [_image.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating
{
    [self setup];

    if (self.hidesWhenStopped)
    {
        self.hidden = YES;
    }
    _animating = NO;

    [_image.layer removeAllAnimations];
}

- (BOOL)isAnimating
{
    return _animating;
}

@end
