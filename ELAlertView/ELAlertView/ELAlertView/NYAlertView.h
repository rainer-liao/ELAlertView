//
//  NYAlertView.h
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//
//  Changed by rainer_liao 

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NYAlertViewButtonType) {
    NYAlertViewButtonTypeFilled,
    NYAlertViewButtonTypeBordered
};

@interface UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end

@interface NYAlertViewButton : UIButton

@property (nonatomic) NYAlertViewButtonType type;

@property (nonatomic) CGFloat cornerRadius;

@end

@interface NYAlertView : UIView

@property UILabel *titleLabel;
@property UITextView *messageTextView;
@property (nonatomic) UIView *contentView;

@property (nonatomic) UIFont *buttonTitleFont;
@property (nonatomic) UIFont *cancelButtonTitleFont;
@property (nonatomic) UIFont *destructiveButtonTitleFont;

@property (nonatomic) UIColor *buttonColor;
@property (nonatomic) UIColor *buttonTitleColor;
@property (nonatomic) UIColor *cancelButtonColor;
@property (nonatomic) UIColor *cancelButtonTitleColor;
@property (nonatomic) UIColor *destructiveButtonColor;
@property (nonatomic) UIColor *destructiveButtonTitleColor;

@property (nonatomic) CGFloat buttonCornerRadius;
@property (nonatomic) CGFloat maximumWidth;

@property (nonatomic, readonly) UIView *alertBackgroundView;

@property (nonatomic, readonly) NSLayoutConstraint *backgroundViewVerticalCenteringConstraint;

@property (nonatomic) NSArray *actionButtons;


- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height;


@property (nonatomic, assign) NSInteger titleTopMargin;
@property (nonatomic, assign) NSInteger titleLeadingAndTrailingPadding;

@property (nonatomic, assign) NSInteger messageLeadingAndTrailingPadding;
@property (nonatomic, assign) NSInteger buttonBottomMargin;

@property (nonatomic, assign) NSInteger messageWithButtonMargin;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

@property (nonatomic, assign) NSInteger messageHeight;
@property (nonatomic, assign) NSInteger contentViewTopMargin;
@property (nonatomic ,assign) NSInteger contentViewBottomMargin;

@end
