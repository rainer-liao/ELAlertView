//
//  ViewController.m
//  ELAlertView
//
//  Created by rainer_liao on 16/5/29.
//  Copyright © 2016年 rainer_liao. All rights reserved.
//

#import "ViewController.h"
#import "ELAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)showELAlertViewStyleDefaultActionCount:(NSInteger)actionCount
{
    ELAlertView *alertView = [[ELAlertView alloc]initWithStyle:ELAlertViewStyleDefault];
    alertView.title = NSLocalizedString(@"default_title", nil);
    alertView.message = NSLocalizedString(@"default_message", nil);
    for (int i = 0; i < actionCount; i++)
    {
        NSString *actionTitle = [NSString stringWithFormat:@"Action %d", i];
        if (i == 0)
        {
            [alertView addAction:[ELAlertAction actionWithTitle:actionTitle
                                                          style:ELAlertActionStyleDefault
                                                        handler:^(ELAlertAction *action) {
                                                            NSLog(@"Event %@",actionTitle);
                                                            
                                                        }]];
        }
        else if (i == 1)
        {
            [alertView addAction:[ELAlertAction actionWithTitle:actionTitle
                                                          style:ELAlertActionStyleCancel
                                                        handler:^(ELAlertAction *action) {
                                                            NSLog(@"Event %@",actionTitle);
                                                            
                                                        }]];
        }
        else
        {
            [alertView addAction:[ELAlertAction actionWithTitle:actionTitle
                                                          style:ELAlertActionStyleDestructive
                                                        handler:^(ELAlertAction *action) {
                                                            NSLog(@"Event %@",actionTitle);
                                                            
                                                        }]];
        }
    }
    [alertView show];
}

- (void)showELAlertViewStyleImageActionCount:(NSInteger)actionCount
{
    ELAlertView *alertView = [[ELAlertView alloc]initWithStyle:ELAlertViewStyleImage];
    alertView.title = NSLocalizedString(@"image_title", nil);
    alertView.message = NSLocalizedString(@"image_message", nil);
    for (int i = 0; i < actionCount; i++)
    {
        NSString *actionTitle = [NSString stringWithFormat:@"Action %d", i];
        if (i == 0)
        {
            [alertView addAction:[ELAlertAction actionWithTitle:actionTitle
                                                          style:ELAlertActionStyleDefault
                                                        handler:^(ELAlertAction *action) {
                                                            NSLog(@"Event %@",actionTitle);
                                                            
                                                        }]];
        }
        else if (i == 1)
        {
            [alertView addAction:[ELAlertAction actionWithTitle:actionTitle
                                                          style:ELAlertActionStyleCancel
                                                        handler:^(ELAlertAction *action) {
                                                            NSLog(@"Event %@",actionTitle);
                                                            
                                                        }]];
        }
        else
        {
            [alertView addAction:[ELAlertAction actionWithTitle:actionTitle
                                                          style:ELAlertActionStyleDestructive
                                                        handler:^(ELAlertAction *action) {
                                                            NSLog(@"Event %@",actionTitle);
                                                            
                                                        }]];
        }
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 91, 83)];
    imageView.image = [UIImage imageNamed:@"icon_gift"];
    [contentView addSubview:imageView];
    
    
    // 设置你的自定义contentView
    // set your custom view(contentView).
    [alertView setContentView:contentView width:100 height:100];
    
    [alertView show];
}

- (void)showCustom1
{
    ELAlertView *alertView = [[ELAlertView alloc] initWithStyle:ELAlertViewStyleDefault];
    alertView.title   = @"xxxxxxx";
    alertView.message = @"1. xxxxxxx？\n    xxxxxxxxxx。\n\n2. xxxxxxxxxx？\n    xxxxxxxxxx\n\n3. xxxxxxx\n    xxxxxxxxxx\n\n4.xxxxx\n    sdfasdfdsafsdafsadf。\n\n5.fdsfsadfsadfsdaf\n    dsfsdfsdafasdsfas\n\n6.sdfasdf\n    fsdfsdfasd\n\n7.sdfasdfasdf\n    dsfsdafsdf\n    sfasfsdaf\n\n8.fdsafdsafsadf\n    fdsfsadfasf \n\n    fdsfsdafsdasdaf";
    alertView.titleTopMargin = 17;
    alertView.messageLeadingAndTrailingPadding = 20;
    alertView.messageAlignment = NSTextAlignmentLeft;
    alertView.messageHeight = 270;
    alertView.alertViewBackgroundColor = [UIColor redColor];
    alertView.titleColor = [UIColor blueColor];
    alertView.messageColor =[UIColor purpleColor];
    
    ELAlertAction *action = [ELAlertAction actionWithTitle:NSLocalizedString(@"ok", nil)
                                                     style:ELAlertActionStyleDestructive
                                                   handler:^(ELAlertAction *action) {
                                                       
                                                   }];
    [alertView addAction:action];
    alertView.buttonBottomMargin = 30;
    [alertView show];
    
}

- (void)showCustom2
{
    ELAlertView *alertView = [[ELAlertView alloc]initWithStyle:ELAlertViewStyleImage];
    alertView.title = NSLocalizedString(@"image_title", nil);
    alertView.message = NSLocalizedString(@"image_message", nil);
    
    ELAlertAction *action = [ELAlertAction actionWithTitle:NSLocalizedString(@"ok", nil)
                                                     style:ELAlertActionStyleDefault
                                                   handler:^(ELAlertAction *action) {
                                                   }];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 91, 83)];
    imageView.image = [UIImage imageNamed:@"icon_gift"];
    [alertView setContentView:imageView width:100 height:100];
    alertView.contentViewBottomMargin = 3;
    alertView.contentViewTopMargin = 50;
    
    [alertView addAction:action];
    [alertView show];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                [self showELAlertViewStyleDefaultActionCount:1];
                break;
                
            case 1:
                [self showELAlertViewStyleDefaultActionCount:2];
                break;
                
            case 2:
                [self showELAlertViewStyleDefaultActionCount:3];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                [self showELAlertViewStyleImageActionCount:1];
                break;
                
            case 1:
                [self showELAlertViewStyleImageActionCount:2];
                break;
                
            case 2:
                [self showELAlertViewStyleImageActionCount:3];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
                [self showCustom1];
                break;
            case 1:
                [self showCustom2];
                
            default:
                break;
        }
    }
}

@end
