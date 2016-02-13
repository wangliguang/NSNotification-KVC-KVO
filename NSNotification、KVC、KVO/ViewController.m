//
//  ViewController.m
//  NSNotification、KVC、KVO
//
//  Created by GG on 16/1/20.
//  Copyright © 2016年 王立广. All rights reserved.
//

#import "ViewController.h"
#import "NSNotificationViewController.h"
#import "KVCViewController.h"
#import "KVOViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"通知、KVC、KVO";
    

    //通知
    UIButton *notificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMargin, kMargin,kScreenWidth-kMargin*2 , 50)];
    [notificationBtn setTitle:@"点击注册发工资通知" forState:UIControlStateNormal];
    [self.view addSubview:notificationBtn];
    [notificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    notificationBtn.backgroundColor = [UIColor grayColor];
    notificationBtn.layer.cornerRadius = 5;
    notificationBtn.layer.masksToBounds = YES;
    [notificationBtn addTarget:self action:@selector(clickNotificationBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //KVC
    UIButton *KVCBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMargin, kMargin+kMargin,kScreenWidth-kMargin*2 , 50)];
    [KVCBtn setTitle:@"KVC" forState:UIControlStateNormal];
    [self.view addSubview:KVCBtn];
    [KVCBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    KVCBtn.backgroundColor = [UIColor grayColor];
    KVCBtn.layer.cornerRadius = 5;
    KVCBtn.layer.masksToBounds = YES;
    [KVCBtn addTarget:self action:@selector(clickKVCBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //KVO
    UIButton *KVOBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMargin, kMargin+kMargin+kMargin,kScreenWidth-kMargin*2 , 50)];
    [KVOBtn setTitle:@"KVO" forState:UIControlStateNormal];
    [self.view addSubview:KVOBtn];
    [KVOBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    KVOBtn.backgroundColor = [UIColor grayColor];
    KVOBtn.layer.cornerRadius = 5;
    KVOBtn.layer.masksToBounds = YES;
    [KVOBtn addTarget:self action:@selector(clickKVOBtn) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)clickNotificationBtn{
    
    /*
     * 通知中心
     
     * What: 是一种一对多的信息广播机制,一个应用程序同时只能有一个NSNotificationCenter(通知中心)对象，因为如果有多个通知，发送通知的时候就不知道是该给谁发送了。
     
     * Where: delegate和block也属于一种信息传递机制，但这两种都是一对一的，每次执行的方法都不一样，而通知是一对多，只要有地方触发通知，执行的是同一个方法。
     
     * How: 1、注册一个通知
              [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySalary) name:@"发工资啦" object:nil];
     
            2、实现添加通知时方法选择器选择的方法。
     
            3、在需要发送通知的类中采用下面方法发送通知，发送成功便会执行步骤二实现的方法。
              [[NSNotificationCenter defaultCenter] postNotificationName:@"发工资啦" object:nil];
          
            4、移除通知，个人习惯在delloc中释放
               [[NSNotificationCenter defaultCenter] postNotificationName:nil object:nil userInfo:nil];

     *
     
    */
    
    
    
    /*
     
     * 注册通知
     
     * defaultCenter指返回一个单例对象
     
     * observer：设置一个观察者
     
     * selector: 方法选择器，指定通知来了以后执行的操作
     
     * name:     设置什么类型的通知，这里传入的是一个字符串。如果发送该类型的通知要和此时指定的name一样。
     
     * object:   注册通知时如果指定了object对象，那么发送通知时的object参数要和这里指定的object参数一样，才会接收到通知，如果这里将这个参数设置为了nil，则会结束到所有的通知。
     
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySalary:) name:@"发工资啦" object:nil];
    
    [self.navigationController pushViewController:[[NSNotificationViewController alloc]init] animated:YES];

}

- (void)clickKVCBtn{
    
    KVCViewController *kvcVC = [KVCViewController new];
    
    kvcVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:kvcVC animated:YES];
    
}

- (void)clickKVOBtn{
    
    KVOViewController *kvoVC = [KVOViewController new];
    
    kvoVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:kvoVC animated:YES];
    
}


/*
 *  实现添加通知时选择器选择的方法。
 
 *  notification： 用来存储发送通知时传递过来的信息。
 
 */
- (void)paySalary:(NSNotification *)notification{
    

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:notification.userInfo[@"message"] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *concelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    
    [alert addAction:concelAction];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
 * 移除通知，个人习惯在delloc中释放
 */

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:[ViewController class] name:@"发工资啦" object:nil];
    
}





@end
