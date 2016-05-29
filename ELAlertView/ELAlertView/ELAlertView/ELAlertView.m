//
//  ELAlertView.m
//  ELAlertView
//
//  Created by rainer_liao on 15/11/5.
//  Copyright © 2015年 rainer_liao. All rights reserved.
//

#import "ELAlertView.h"
#import "NYAlertView.h"
#import "UIView+HitTestEdgeInsets.h"

#define BackgroundBlueColor [UIColor colorWithRed:81/255.0 green:153/255.0 blue:230/255.0 alpha:1.0]
#define DefaultButtonTitleColor [UIColor colorWithRed:90/255.0 green:113/255.0 blue:112/255.0 alpha:1.0]

@interface ELAlertAction ()

@property (nonatomic, weak) UIButton *actionButton;

@end

@implementation ELAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(ELAlertActionStyle)style handler:(void (^)(ELAlertAction *action))handler
{
    ELAlertAction *action = [[ELAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    
    return action;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _enabled = YES;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.actionButton.enabled = enabled;
}

@end

@interface ELAlertView ()

@property (nonatomic, strong) NYAlertView *alertView;
@property (nonatomic, assign) ELAlertViewStyle alertViewStyle;

@end

@implementation ELAlertView

- (void)show
{
    [self createActionButtons];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.alertView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                         self.alertView.alpha = 1.0f;
                         
                     }
                     completion:nil
     ];
}

- (void)close
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.alertView.alpha = 0.0f;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                        
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

- (id)init
{
    return [self initWithStyle:ELAlertViewStyleDefault title:nil message:nil];
}

- (id)initWithStyle:(ELAlertViewStyle)alertViewStyle
{
    return [self initWithStyle:alertViewStyle title:nil message:nil];
}

- (id)initWithStyle:(ELAlertViewStyle)alertViewStyle title:(NSString *)title message:(NSString *)message;
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        self.alertViewStyle = alertViewStyle;
        _actions = [NSArray array];
        
        _buttonTitleFont = [UIFont systemFontOfSize:14.0f];
        _cancelButtonTitleFont = [UIFont boldSystemFontOfSize:14.0f];
        _destructiveButtonTitleFont = [UIFont systemFontOfSize:14.0f];
        
        /**
         *  你可以按照实际的设计图,根据不同的样式修改
         *  You can change the appearance as you like here.
         */
        if (alertViewStyle == ELAlertViewStyleDefault) {
            _buttonColor = BackgroundBlueColor;
            _buttonTitleColor = [UIColor whiteColor];
            _cancelButtonColor = BackgroundBlueColor;
            _cancelButtonTitleColor = [UIColor whiteColor];
            _buttonCornerRadius = 20.0f;
            _destructiveButtonColor = [UIColor whiteColor];
            _destructiveButtonTitleColor = BackgroundBlueColor;
        }
        else {
            _buttonColor = [UIColor whiteColor];
            _buttonTitleColor = BackgroundBlueColor;
            _cancelButtonColor = BackgroundBlueColor;
            _cancelButtonTitleColor = [UIColor whiteColor];
            _buttonCornerRadius = 20.0f;
            _destructiveButtonColor = [UIColor colorWithRed:1.0f green:0.23f blue:0.21f alpha:1.0f];
            _destructiveButtonTitleColor = [UIColor whiteColor];
        }
        _disabledButtonColor = [UIColor lightGrayColor];
        _disabledButtonTitleColor = [UIColor whiteColor];
        
        self.alertView = [[NYAlertView alloc]
                          initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

        self.alertView.alertBackgroundView.backgroundColor = BackgroundBlueColor;

        [self setTitle:title];
        [self setMessage:message];
        
        [self addSubview:self.alertView];
    }
    return self;
}


- (void)createActionButtons
{
    NSMutableArray *buttons = [NSMutableArray array];
    
    // Create buttons for each action
    for (int i = 0; i < [self.actions count]; i++) {
        ELAlertAction *action = self.actions[i];
        
        NYAlertViewButton *button = [NYAlertViewButton buttonWithType:UIButtonTypeCustom];
        button.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -15, -15, -15);
        
        button.tag = i;
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        button.enabled = action.enabled;
        button.cornerRadius = self.buttonCornerRadius;

        button.type = NYAlertViewButtonTypeBordered;
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:action.title forState:UIControlStateNormal];
        
        [button setTitleColor:self.disabledButtonTitleColor forState:UIControlStateDisabled];
        [button setBackgroundColor:self.disabledButtonColor forState:UIControlStateDisabled];
        
        if (action.style == ELAlertActionStyleCancel) {
            
            [button setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:self.cancelButtonTitleColor forState:UIControlStateHighlighted];
            [button setBackgroundColor:self.cancelButtonColor forState:UIControlStateNormal];
            [button setBackgroundColor:self.cancelButtonColor forState:UIControlStateHighlighted];
            
            button.titleLabel.font = self.cancelButtonTitleFont;
        }
        else if (action.style == ELAlertActionStyleDestructive) {
            [button setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateHighlighted];
            [button setBackgroundColor:self.destructiveButtonColor forState:UIControlStateNormal];
            [button setBackgroundColor:self.destructiveButtonColor forState:UIControlStateHighlighted];
            
            button.titleLabel.font = self.destructiveButtonTitleFont;
            if (self.alertViewStyle == ELAlertViewStyleImage) {
                button.type = NYAlertViewButtonTypeFilled;
            }
        }
        else {
            [button setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:self.buttonTitleColor forState:UIControlStateHighlighted];
            [button setBackgroundColor:self.buttonColor forState:UIControlStateNormal];
            [button setBackgroundColor:self.buttonColor forState:UIControlStateHighlighted];
            
            button.titleLabel.font = self.buttonTitleFont;
        }
        
        [buttons addObject:button];
        
        action.actionButton = button;
    }
    
    self.alertView.actionButtons = buttons;
}

- (void)actionButtonPressed:(UIButton *)button
{
    [self close];
    ELAlertAction *action = self.actions[button.tag];
    if (action.handler) {
        action.handler(action);
    }
}


- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height
{
    [self.alertView setContentView:contentView width:width height:height];
}

#pragma mark - Getters/Setters
- (void)setTitle:(NSString *)title
{
    self.alertView.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.alertView.messageTextView.text = message;
}

- (UIView *)alertViewContentView
{
    return self.alertView.contentView;
}

//- (void)setAlertViewContentView:(UIView *)alertViewContentView
//{
//    self.alertView.contentView = alertViewContentView;
//}

- (void)setAlertViewBackgroundColor:(UIColor *)alertViewBackgroundColor
{
    _alertViewBackgroundColor = alertViewBackgroundColor;
    
    self.alertView.alertBackgroundView.backgroundColor = alertViewBackgroundColor;
}

- (UIFont *)titleFont
{
    return self.alertView.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    self.alertView.titleLabel.font = titleFont;
}

- (UIFont *)messageFont
{
    return self.alertView.messageTextView.font;
}

- (void)setMessageFont:(UIFont *)messageFont
{
    self.alertView.messageTextView.font = messageFont;
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont
{
    _buttonTitleFont = buttonTitleFont;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style != ELAlertActionStyleCancel) {
            button.titleLabel.font = buttonTitleFont;
        }
    }];
}

- (void)setCancelButtonTitleFont:(UIFont *)cancelButtonTitleFont
{
    _cancelButtonTitleFont = cancelButtonTitleFont;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style == ELAlertActionStyleCancel) {
            button.titleLabel.font = cancelButtonTitleFont;
        }
    }];
}

- (void)setDestructiveButtonTitleFont:(UIFont *)destructiveButtonTitleFont
{
    _destructiveButtonTitleFont = destructiveButtonTitleFont;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style == ELAlertActionStyleDestructive) {
            button.titleLabel.font = destructiveButtonTitleFont;
        }
    }];
}

- (UIColor *)titleColor {
    return self.alertView.titleLabel.textColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.alertView.titleLabel.textColor = titleColor;
}

- (UIColor *)messageColor {
    return self.alertView.messageTextView.textColor;
}

- (void)setMessageColor:(UIColor *)messageColor {
    self.alertView.messageTextView.textColor = messageColor;
}

- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style != ELAlertActionStyleCancel) {
            [button setBackgroundColor:buttonColor forState:UIControlStateNormal];
        }
    }];
}

- (void)setCancelButtonColor:(UIColor *)cancelButtonColor {
    _cancelButtonColor = cancelButtonColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
       ELAlertAction *action = self.actions[idx];
        
        if (action.style == ELAlertActionStyleCancel) {
            [button setBackgroundColor:cancelButtonColor forState:UIControlStateNormal];
        }
    }];
}

- (void)setDestructiveButtonColor:(UIColor *)destructiveButtonColor {
    _destructiveButtonColor = destructiveButtonColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style == ELAlertActionStyleDestructive) {
            [button setBackgroundColor:destructiveButtonColor forState:UIControlStateNormal];
        }
    }];
}

- (void)setDisabledButtonColor:(UIColor *)disabledButtonColor {
    _disabledButtonColor = disabledButtonColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (!action.enabled) {
            [button setBackgroundColor:disabledButtonColor forState:UIControlStateNormal];
        }
    }];
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style != ELAlertActionStyleCancel) {
            [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:buttonTitleColor forState:UIControlStateHighlighted];
        }
    }];
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    _cancelButtonTitleColor = cancelButtonTitleColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style == ELAlertActionStyleCancel) {
            [button setTitleColor:cancelButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:cancelButtonTitleColor forState:UIControlStateHighlighted];
        }
    }];
}

- (void)setDestructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor {
    _destructiveButtonTitleColor = destructiveButtonTitleColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (action.style == ELAlertActionStyleDestructive) {
            [button setTitleColor:destructiveButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:destructiveButtonTitleColor forState:UIControlStateHighlighted];
        }
    }];
}

- (void)setDisabledButtonTitleColor:(UIColor *)disabledButtonTitleColor {
    _disabledButtonTitleColor = disabledButtonTitleColor;
    
    [self.alertView.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        ELAlertAction *action = self.actions[idx];
        
        if (!action.enabled) {
            [button setTitleColor:disabledButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:disabledButtonTitleColor forState:UIControlStateHighlighted];
        }
    }];
}

- (CGFloat)alertViewCornerRadius {
    return self.alertView.alertBackgroundView.layer.cornerRadius;
}

- (void)setAlertViewCornerRadius:(CGFloat)alertViewCornerRadius {
    self.alertView.alertBackgroundView.layer.cornerRadius = alertViewCornerRadius;
}

- (void)setButtonCornerRadius:(CGFloat)buttonCornerRadius {
    _buttonCornerRadius = buttonCornerRadius;
    
    for (NYAlertViewButton *button in self.alertView.actionButtons) {
        button.cornerRadius = buttonCornerRadius;
    }
}

- (void)addAction:(ELAlertAction *)action {
    _actions = [self.actions arrayByAddingObject:action];
}

- (void)setTitleLeadingAndTrailingPadding:(NSInteger)titleLeadingAndTrailingPadding {
    _titleLeadingAndTrailingPadding = titleLeadingAndTrailingPadding;
    self.alertView.titleLeadingAndTrailingPadding = titleLeadingAndTrailingPadding;
}

- (void)setMessageLeadingAndTrailingPadding:(NSInteger)messageLeadingAndTrailingPadding {
    _messageLeadingAndTrailingPadding = messageLeadingAndTrailingPadding;
    self.alertView.messageLeadingAndTrailingPadding = messageLeadingAndTrailingPadding;
}

- (void)setButtonBottomMargin:(NSInteger)buttonBottomMargin {
    _buttonBottomMargin = buttonBottomMargin;
    self.alertView.buttonBottomMargin = buttonBottomMargin;
}

- (void)setTitleTopMargin:(NSInteger)titleTopMargin {
    _titleTopMargin = titleTopMargin;
    self.alertView.titleTopMargin = titleTopMargin;
}

- (void)setMessageWithButtonMargin:(NSInteger)messageWithButtonMargin {
    _messageWithButtonMargin = messageWithButtonMargin;
    self.alertView.messageWithButtonMargin = messageWithButtonMargin;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    self.alertView.messageAlignment = messageAlignment;
}

- (void)setMessageHeight:(NSInteger)messageHeight {
    _messageHeight = messageHeight;
    self.alertView.messageHeight = messageHeight;
}

- (void)setContentViewTopMargin:(NSInteger)contentViewTopMargin {
    _contentViewTopMargin = contentViewTopMargin;
    self.alertView.contentViewTopMargin = contentViewTopMargin;
}

- (void)setContentViewBottomMargin:(NSInteger)contentViewBottomMargin {
    _contentViewBottomMargin = contentViewBottomMargin;
    self.alertView.contentViewBottomMargin = contentViewBottomMargin;
}

@end
