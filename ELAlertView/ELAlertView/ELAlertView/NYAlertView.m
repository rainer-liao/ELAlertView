//
//  NYAlertView.m
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//
//  Changed by rainer_liao

#import "NYAlertView.h"

@interface NYAlertTextView : UITextView

@end

@implementation NYAlertTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    
    self.textContainerInset = UIEdgeInsetsZero;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    if ([self.text length]) {
        return self.contentSize;
    } else {
        return CGSizeZero;
    }
}

@end

@implementation UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[self imageWithColor:color] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation NYAlertViewButton

+ (id)buttonWithType:(UIButtonType)buttonType {
    
    return [super buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    
    self.layer.borderWidth = 1.0f;
    
    self.cornerRadius = 4.0f;
    self.clipsToBounds = YES;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [self tintColorDidChange];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self invalidateIntrinsicContentSize];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    if (self.type == NYAlertViewButtonTypeFilled) {
        if (self.enabled) {
            [self setBackgroundColor:self.tintColor];
        }
    } else {
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
    
    self.layer.borderColor = self.tintColor.CGColor;
    
    [self setNeedsDisplay];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGSize)intrinsicContentSize {
    if (self.hidden) {
        return CGSizeZero;
    }
    
    return CGSizeMake([super intrinsicContentSize].width + 12.0f, 30.0f);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.layer.borderColor = self.tintColor.CGColor;
    
    if (self.type == NYAlertViewButtonTypeBordered)
    {
        self.layer.borderWidth = 1.0f;
    }
    else
    {
        self.layer.borderWidth = 0.0f;
    }
    
    if (self.state == UIControlStateHighlighted)
    {
//        self.layer.backgroundColor = self.tintColor.CGColor;
    }
    else
    {
        if (self.type == NYAlertViewButtonTypeBordered)
        {
            self.layer.backgroundColor = nil;
//            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
            
            [self.layer setMasksToBounds:YES];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255/255.0, 255/255.0, 1.0, 1 });
            [self.layer setBorderColor:colorref]; //设置button边框颜色
        }
        else
        {
//            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

@end

@interface NYAlertView ()

@property (nonatomic) NSLayoutConstraint *alertBackgroundWidthConstraint;
@property (nonatomic) UIView *contentViewContainerView;
@property (nonatomic) UIView *actionButtonContainerView;

@end

@implementation NYAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.maximumWidth = 480.0f;
        
        _alertBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.alertBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.alertBackgroundView.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
        self.alertBackgroundView.layer.cornerRadius = 10.0f;
        [self addSubview:_alertBackgroundView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = NSLocalizedString(@"Title Label", nil);
        [self.alertBackgroundView addSubview:self.titleLabel];
        
        _messageTextView = [[NYAlertTextView alloc] initWithFrame:CGRectZero];
        [self.messageTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.messageTextView.backgroundColor = [UIColor clearColor];
        [self.messageTextView setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
        [self.messageTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        self.messageTextView.editable = NO;
        self.messageTextView.textAlignment = NSTextAlignmentCenter;
        self.messageTextView.textColor = [UIColor whiteColor];
        self.messageTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.messageTextView.text = NSLocalizedString(@"Message Text View", nil);
        [self.alertBackgroundView addSubview:self.messageTextView];
        
        _contentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentViewContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.alertBackgroundView addSubview:self.contentViewContainerView];
        
        _actionButtonContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.actionButtonContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.actionButtonContainerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.alertBackgroundView addSubview:self.actionButtonContainerView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertBackgroundView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        CGFloat alertBackgroundViewWidth = MIN(CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds),
                                               CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds)) * 0.8f;
        
        if (alertBackgroundViewWidth > self.maximumWidth) {
            alertBackgroundViewWidth = self.maximumWidth;
        }
        
        _alertBackgroundWidthConstraint = [NSLayoutConstraint constraintWithItem:self.alertBackgroundView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:0.0f
                                                                        constant:alertBackgroundViewWidth];
        
        [self addConstraint:self.alertBackgroundWidthConstraint];
        
        _backgroundViewVerticalCenteringConstraint = [NSLayoutConstraint constraintWithItem:self.alertBackgroundView
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                 multiplier:1.0f
                                                                                   constant:0.0f];
        
        [self addConstraint:self.backgroundViewVerticalCenteringConstraint];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertBackgroundView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.9f
                                                          constant:0.0f]];
        
        // 从此处开始,将许多约束的优先级降低(降为750),以便于后续修改相应约束
        // Reduce some constraints' priority to 750, so we can change them if needed.
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-51@750-[_titleLabel]-51@750-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-51@750-[_messageTextView]-51@750-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_messageTextView)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentViewContainerView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_contentViewContainerView)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_actionButtonContainerView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_actionButtonContainerView)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35@750-[_titleLabel]-12@750-[_messageTextView]-25@750-[_contentViewContainerView]-25@750-[_actionButtonContainerView]-(13@750)-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                                _messageTextView,
                                                                                                                                _contentViewContainerView,
                                                                                                                                _actionButtonContainerView)]];
    }
    
    return self;
}

- (void)setTitleLeadingAndTrailingPadding:(NSInteger)titleLeadingAndTrailingPadding{
    _titleLeadingAndTrailingPadding = titleLeadingAndTrailingPadding;
    NSDictionary *metrics = @{@"padding": [NSNumber numberWithInteger:titleLeadingAndTrailingPadding]};
    
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_titleLabel]-padding-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_titleLabel)]];
}

- (void)setMessageLeadingAndTrailingPadding:(NSInteger)messageLeadingAndTrailingPadding{
    _messageLeadingAndTrailingPadding = messageLeadingAndTrailingPadding;
    NSDictionary *metrics = @{@"padding": [NSNumber numberWithInteger:messageLeadingAndTrailingPadding]};
    
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_messageTextView]-padding-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_messageTextView)]];
}

- (void)setButtonBottomMargin:(NSInteger)buttonBottomMargin{
    _buttonBottomMargin = buttonBottomMargin;
    NSDictionary *metrics = @{@"margin": [NSNumber numberWithInteger:buttonBottomMargin]};
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35@750-[_titleLabel]-12@750-[_messageTextView]-25@750-[_contentViewContainerView]-25@750-[_actionButtonContainerView]-margin-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                            _messageTextView,
                                                                                                                            _contentViewContainerView,
                                                                                                                            _actionButtonContainerView)]];
}

- (void)setTitleTopMargin:(NSInteger)titleTopMargin{
    _titleTopMargin = titleTopMargin;
    NSDictionary *metrics = @{@"margin": [NSNumber numberWithInteger:titleTopMargin]};
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_titleLabel]-12@750-[_messageTextView]-25@750-[_contentViewContainerView]-25@750-[_actionButtonContainerView]-(13@750)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                            _messageTextView,
                                                                                                                            _contentViewContainerView,
                                                                                                                            _actionButtonContainerView)]];
}

- (void)setMessageWithButtonMargin:(NSInteger)messageWithButtonMargin{
    _messageWithButtonMargin = messageWithButtonMargin;
    NSDictionary *metrics = @{@"margin": [NSNumber numberWithInteger:messageWithButtonMargin]};
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35@750-[_titleLabel]-12@750-[_messageTextView]-25@750-[_contentViewContainerView]-margin-[_actionButtonContainerView]-(13@750)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                            _messageTextView,
                                                                                                                            _contentViewContainerView,
                                                                                                                            _actionButtonContainerView)]];
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    self.messageTextView.textAlignment = messageAlignment;
}

- (void)setMessageHeight:(NSInteger)messageHeight {
    _messageHeight = messageHeight;
    NSDictionary *metrics = @{@"height": [NSNumber numberWithInteger:messageHeight]};
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35@750-[_titleLabel]-12@750-[_messageTextView(height)]-25@750-[_contentViewContainerView]-25@750-[_actionButtonContainerView]-(13@750)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                            _messageTextView,
                                                                                                                            _contentViewContainerView,
                                                                                                                            _actionButtonContainerView)]];
    
}

- (void)setContentViewTopMargin:(NSInteger)contentViewTopMargin {
    _contentViewTopMargin = contentViewTopMargin;
    NSDictionary *metrics = @{@"top": [NSNumber numberWithInteger:contentViewTopMargin]};
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35@750-[_titleLabel]-12@750-[_messageTextView]-top-[_contentViewContainerView]-25@750-[_actionButtonContainerView]-(13@750)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                            _messageTextView,
                                                                                                                            _contentViewContainerView,
                                                                                                                            _actionButtonContainerView)]];
}

- (void)setContentViewBottomMargin:(NSInteger)contentViewBottomMargin {
    _contentViewBottomMargin = contentViewBottomMargin;
    NSDictionary *metrics = @{@"bottom": [NSNumber numberWithInteger:contentViewBottomMargin]};
    [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35@750-[_titleLabel]-12@750-[_messageTextView]-25@750-[_contentViewContainerView]-bottom-[_actionButtonContainerView]-(13@750)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                            _messageTextView,
                                                                                                                            _contentViewContainerView,
                                                                                                                            _actionButtonContainerView)]];
}


// Pass through touches outside the backgroundView for the presentation controller to handle dismissal
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setMaximumWidth:(CGFloat)maximumWidth {
    _maximumWidth = maximumWidth;
    self.alertBackgroundWidthConstraint.constant = maximumWidth;
}

- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height {
    [self.contentView removeFromSuperview];
    
    _contentView = contentView;
    
    NSDictionary *metrics = @{@"height": [NSNumber numberWithInteger:height],
                              @"width": [NSNumber numberWithInteger:width],
                              };
    
    if (contentView) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentViewContainerView addSubview:self.contentView];
        
        [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentView(width)]"
                                                                                              options:0
                                                                                              metrics:metrics
                                                                                                views:NSDictionaryOfVariableBindings(_contentView)]];
        
        [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_contentView(height)]-2-|"
                                                                                              options:0
                                                                                              metrics:metrics
                                                                                                views:NSDictionaryOfVariableBindings(_contentView)]];
        
        [self.contentViewContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:self.contentView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentViewContainerView
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0f
                                       constant:0.0f]];

        [self.contentViewContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:self.contentView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentViewContainerView
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0f
                                       constant:0.0f]];
    }

}

- (void)setActionButtons:(NSArray *)actionButtons
{
    for (UIButton *button in self.actionButtons)
    {
        [button removeFromSuperview];
    }
    
    _actionButtons = actionButtons;
    
    // If there are 2 actions, display the buttons next to each other.
    if ([actionButtons count] == 2)
    {
        UIButton *firstButton = actionButtons[0];
        UIButton *lastButton = actionButtons[1];
        
        [self.actionButtonContainerView addSubview:firstButton];
        [self.actionButtonContainerView addSubview:lastButton];
        
        [self.actionButtonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:firstButton
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:lastButton
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                  multiplier:1.0f
                                                                                    constant:0.0f]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[firstButton]-[lastButton]-|"
                                                                                               options:NSLayoutFormatAlignAllCenterY
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(firstButton, lastButton)]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[firstButton(40)]|"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(_contentViewContainerView, firstButton)]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastButton(40)]"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(lastButton)]];
    }
    else if ([actionButtons count] == 1) //只有一个按钮的时候,按钮的大小要定制 (if only one button, we need to custom it.
    {
        UIButton *theButton = actionButtons[0];
        [self.actionButtonContainerView addSubview:theButton];
        
        [self.actionButtonContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:theButton
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.actionButtonContainerView
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0f
                                       constant:0.0f]];
        
        [self.actionButtonContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:theButton
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.actionButtonContainerView
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0f
                                       constant:0.0f]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-51-[theButton]-51-|"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(theButton)]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[theButton(40)]"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(_contentViewContainerView,theButton)]];
    }
    
    else
    {
        for (int i = 0; i < [actionButtons count]; i++)
        {
            
            UIButton *actionButton = actionButtons[i];
            
            [self.actionButtonContainerView addSubview:actionButton];
            
            [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-51-[actionButton]-51-|"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:NSDictionaryOfVariableBindings(actionButton)]];
            
            [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionButton(40)]"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:NSDictionaryOfVariableBindings(actionButton)]];
            
            if (i == 0)
            {
                [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[actionButton]"
                                                                                                       options:0
                                                                                                       metrics:nil
                                                                                                         views:NSDictionaryOfVariableBindings(_contentViewContainerView, actionButton)]];
            }
            else
            {
                UIButton *previousButton = actionButtons[i - 1];
                
                [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousButton]-[actionButton]"
                                                                                                       options:0
                                                                                                       metrics:nil
                                                                                                         views:NSDictionaryOfVariableBindings(previousButton, actionButton)]];
            }
            
            if (i == ([actionButtons count] - 1))
            {
                [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionButton]|"
                                                                                                       options:0
                                                                                                       metrics:nil
                                                                                                         views:NSDictionaryOfVariableBindings(actionButton)]];
            }
        }
    }
}

@end
