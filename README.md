# ELAlertView
ELAlertView support custom content views and appeanace for alert view.【ELAlertView 可以定制化弹框的外形和其内容.】     
A good choice for alertView with image.【最关键的是可以放置图片.】       
You can use it to replace UIAlertController/UIAlertView.【你可以使用它来代替系统的UIAlertController/UIAlertView.】    
Support iOS7.【支持iOS7.】     

This project is inspired by [NYAlertViewController](https://github.com/nealyoung/NYAlertViewController)

![Flipboard playing multiple GIFs](https://github.com/rainer-liao/ELAlertView/blob/1.0.0/ELAlertView/ezgif-1657319143.gif)

## Installation 安装
### Manual 手动
Just download the zip and drag the ELAlertView directory into you Xcode project.【下载本项目,将项目中的ELAlertView文件拖到你的Xcode工程就OK了. 】    
   

###CocoaPods
pod 'ELAlertView', '~>1.0.0'

## How To Use 使用方法
```objc
// Import the class
#import "ELAlertView.h"

// ...
    // Create an instance
    ELAlertView *alertView = [[ELAlertView alloc] initWithStyle:ELAlertViewStyleDefault];
    
    // Set title and message if needed
    alertView.title   = @"title";
    alertView.message = @"message";
    
    // Custom your appearance
    alertView.titleTopMargin = 17;
    alertView.messageLeadingAndTrailingPadding = 20;
    alertView.messageAlignment = NSTextAlignmentLeft;
    alertView.messageHeight = 270;
    alertView.alertViewBackgroundColor = [UIColor redColor];
    alertView.titleColor = [UIColor blueColor];
    alertView.messageColor =[UIColor purpleColor];
    alertView.buttonBottomMargin = 30;
    
    // Add alert actions
    ELAlertAction *action = [ELAlertAction actionWithTitle:NSLocalizedString(@"ok", nil)
                                                     style:ELAlertActionStyleDestructive
                                                   handler:^(ELAlertAction *action) {
                                                       
                                                   }];
    [alertView addAction:action];
    
    // Show the alertView
    [alertView show];
```
    
## License
This project is released under the MIT License.
