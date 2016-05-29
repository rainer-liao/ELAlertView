//
//  ELAlertView.h
//  ELAlertView
//
//  Created by rainer_liao on 15/11/5.
//  Copyright © 2015年 rainer_liao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ELAlertActionStyle)
{
    ELAlertActionStyleDefault = 0,
    ELAlertActionStyleCancel,
    ELAlertActionStyleDestructive,
};

@interface ELAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title style:(ELAlertActionStyle)style handler:(void (^)(ELAlertAction *action))handler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) ELAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(ELAlertAction *action);
@property (nonatomic, assign) BOOL enabled;

@end

typedef NS_ENUM(NSInteger, ELAlertViewStyle)
{
    ELAlertViewStyleDefault = 0,
    ELAlertViewStyleImage
};

@interface ELAlertView : UIView

- (id)initWithStyle:(ELAlertViewStyle)alertViewStyle;

- (id)initWithStyle:(ELAlertViewStyle)alertViewStyle title:(NSString *)title message:(NSString *)message;

- (void)show;
- (void)close;

/**
 *  set your custom view with width and height
 *
 *  @param contentView The custom view you want to use
 *  @param width       view width
 *  @param height      view height
 */
- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height;


@property (nonatomic, copy) NSString * title;

/**
 The message displayed under the alert view's title
 */
@property (nonatomic) NSString *message;

/**
 The custom view displayed in the presented alert view
 
 @discussion The default value of this property is nil. Set this property to a view that you create to add the custom view to the displayed alert view.
// */
//@property (nonatomic) UIView *alertViewContentView;


/**
 The background color of the alert view
 */
@property (nonatomic) UIColor *alertViewBackgroundColor;

/**
 The font used to display the title in the alert view
 
 @see title
 */
@property (nonatomic) UIFont *titleFont;

/**
 The font used to display the messsage in the alert view
 
 @see message
 */
@property (nonatomic) UIFont *messageFont;

/**
 The font used for buttons (actions with style NYAlertActionStyleDefault) in the alert view
 */
@property (nonatomic) UIFont *buttonTitleFont;

/**
 The font used for cancel buttons (actions with style NYAlertActionStyleCancel) in the alert view
 */
@property (nonatomic) UIFont *cancelButtonTitleFont;

/**
 The font used for destructive buttons (actions with style NYAlertActionStyleDestructive) in the alert view
 */
@property (nonatomic) UIFont *destructiveButtonTitleFont;

/**
 The color used to display the alert view's title
 
 @see title
 */
@property (nonatomic) UIColor *titleColor;

/**
 The color used to display the alert view's message
 
 @see message
 */
@property (nonatomic) UIColor *messageColor;

/**
 The background color for the alert view's buttons corresponsing to default style actions
 */
@property (nonatomic) UIColor *buttonColor;

/**
 The background color for the alert view's buttons corresponsing to cancel style actions
 */
@property (nonatomic) UIColor *cancelButtonColor;

/**
 The background color for the alert view's buttons corresponsing to destructive style actions
 */
@property (nonatomic) UIColor *destructiveButtonColor;

/**
 The background color for the alert view's buttons corresponsing to disabled actions
 */
@property (nonatomic) UIColor *disabledButtonColor;

/**
 The color used to display the title for buttons corresponsing to default style actions
 */
@property (nonatomic) UIColor *buttonTitleColor;

/**
 The color used to display the title for buttons corresponding to cancel style actions
 */
@property (nonatomic) UIColor *cancelButtonTitleColor;

/**
 The color used to display the title for buttons corresponsing to destructive style actions
 */
@property (nonatomic) UIColor *destructiveButtonTitleColor;

/**
 The color used to display the title for buttons corresponsing to disabled actions
 */
@property (nonatomic) UIColor *disabledButtonTitleColor;

/**
 The radius of the displayed alert view's corners
 */
@property (nonatomic) CGFloat alertViewCornerRadius;

/**
 The radius of button corners
 */
@property (nonatomic) CGFloat buttonCornerRadius;

/**
 An array of NYAlertAction objects representing the actions that the user can take in response to the alert view
 */
@property (nonatomic, readonly) NSArray *actions;

/**
 Add an alert action object to be displayed in the alert view
 
 @param action The action object to display in the alert view to be presented
 */
- (void)addAction:(ELAlertAction *)action;

/**
 The leading and trailing distance for title
 */
@property (nonatomic, assign) NSInteger titleLeadingAndTrailingPadding;

/**
 The leading and trailing distance for message
 */
@property (nonatomic, assign) NSInteger messageLeadingAndTrailingPadding;

/**
 The bottom distance for buttons
 */
@property (nonatomic, assign) NSInteger buttonBottomMargin;

/**
 The title top distance
 */
@property (nonatomic, assign) NSInteger titleTopMargin;

/**
 *  Distance between message and buttons
 */
@property (nonatomic, assign) NSInteger messageWithButtonMargin;

/**
 Default is center
 */
@property (nonatomic, assign) NSTextAlignment messageAlignment;

/**
 *  message height
 */
@property (nonatomic, assign) NSInteger messageHeight;

/**
 *  Content view top
 */
@property (nonatomic, assign) NSInteger contentViewTopMargin;

/**
 *  Content view bottom
 */
@property (nonatomic ,assign) NSInteger contentViewBottomMargin;

@end
