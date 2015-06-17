//
//  SlateActivityIndicatorView.h
//  SlateCore
//
//  Created by wangliqun on 1/01/14.
//  Copyright (c) 2015 mmslate. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SlateActivityIndicatorViewStyle) {
    ActivityIndicatorViewStyleWhiteLarge,
    ActivityIndicatorViewStyleWhite,
    ActivityIndicatorViewStyleGrayLarge,
    ActivityIndicatorViewStyleGray,
};

/**
 *  带有旋转来画效果的视图类，用来表示动作正在进行中
 */
@interface SlateActivityIndicatorView : UIView

@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, readonly) SlateActivityIndicatorViewStyle style;
@property (nonatomic, readonly) BOOL hasBgView;

- (instancetype)initWithViewStyle:(SlateActivityIndicatorViewStyle)style withBgView:(BOOL)withBgView;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
