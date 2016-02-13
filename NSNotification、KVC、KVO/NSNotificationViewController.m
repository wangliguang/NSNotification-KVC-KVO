//
//  NSNotificationViewController.m
//  NSNotification、KVC、KVO
//
//  Created by GG on 16/1/20.
//  Copyright © 2016年 王立广. All rights reserved.
//

#import "NSNotificationViewController.h"
#import "ViewController.h"
@interface NSNotificationViewController ()

@end

@implementation NSNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"通知";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *tellParent = [UIButton buttonWithType:UIButtonTypeCustom];
    tellParent.frame = CGRectMake(kMargin, kMargin, 70, 50);
    tellParent.backgroundColor = [UIColor grayColor];
    [tellParent setTitle:@"通知父母" forState:UIControlStateNormal];
    [tellParent sizeToFit];
    tellParent.layer.cornerRadius = 5;
    tellParent.layer.masksToBounds = YES;
    [tellParent addTarget:self action:@selector(tellParetn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tellParent];
    
    
    UIButton *tellSelf = [UIButton buttonWithType:UIButtonTypeCustom];
    tellSelf.frame = CGRectMake(kMargin, kMargin*2, 70, 50);
    tellSelf.backgroundColor = [UIColor grayColor];
    [tellSelf setTitle:@"通知自己" forState:UIControlStateNormal];
    [tellSelf sizeToFit];
    tellSelf.layer.cornerRadius = 5;
    tellSelf.layer.masksToBounds = YES;
    [tellSelf addTarget:self action:@selector(tellSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tellSelf];
   
}

- (void)tellParetn{
    
    /*
     * 发送通知
    
     * name: 指定要发送什么类型的通知
     
     * object: 标明是谁发的通知
     
     * userInfo: 发送通知时传递过去的信息，是字典类型
     
     */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"发工资啦" object:nil userInfo:@{@"message":@"parent知道了"}];
    
}

- (void)tellSelf{
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"发工资啦" object:nil userInfo:@{@"message":@"我知道了"}];
    
    
}






@end
