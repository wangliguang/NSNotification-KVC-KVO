//
//  KVCViewController.m
//  NSNotification、KVC、KVO
//
//  Created by GG on 16/1/20.
//  Copyright © 2016年 王立广. All rights reserved.
//

#import "KVCViewController.h"
#import "Parent.h"
@implementation KVCViewController

/*
 
 * KVC
 
 * What:  全称，key valued coding(键值编码)
 
 * Where: 最常用的是将字典数据转model
 
 * Why:   特殊情况下，更加简便，下文会进行分析。
 
 * How:   见下文。
 
 */

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"KVC";
    
    /*
     * 将字典@{@"name":@"红红",@"children":@{@"name":@"小红"}}采用多种方式转化为model.
     */
    
    NSDictionary *dict = @{@"name":@"红红",@"children":@{@"name":@"小红"}};
    
#pragma mark -------------------老方式-------------------
    
    Parent *oldWayparent = [Parent new];
    
    //给parent起名字
    oldWayparent.name = dict[@"name"];
    
    Children *children1 = [Children new];
    children1.name = dict[@"children"][@"name"];
    
    //给parent的孩子起名字
    oldWayparent.children = children1;
    
    NSLog(@"oldWay ======= %@的孩子叫做%@",oldWayparent.name,oldWayparent.children.name);
    
    
#pragma mark -------------------KVC 方式-------------------
    
    /*
     
     * 采用kvc将字典转化为model的三种方式
     
     * 方式一 : 存值：[id setValue:<#value#> forKey:<#key#>];
               取值：[id valueForKey:<#key#>];
     
               给id对象的key属性赋值value。此处key的值一定必须要和在id对象key属性一模一样。
     
     * 方式二 : 存值：[id setValue:<#value#> forKeyPath:<#key.key#>];
               取值：[id valueForKeyPath:<#key#>];
     
               同样是给id对象的相应属性赋值，但此时后面将不再直接给出键，而是按照键值路径来查找出相应的键，系统会按『.』,自动进入对象内部，查找对象属性。温馨提示：此处我挖有坑。
     
     * 方式三 : [id setValuesForKeysWithDictionary:<#NSDictionary#>];
     
               上面的两种方式都需要取出来字典中的值，赋值给对象的相应属性。如果该对象要是有八九十来个属性，就要写八九十来行代码。这样太麻烦。碰到这样情况直接采用方式三便可。直接将整个字典作为参数传进来，便可将字典转化为model对象。
     
     * 温馨提示 ： 这三种方式并不是完全独立，不是不可混合使用的，要根据字典内容做决定，接下来我用上面的那个字典做一下简单分析。
     
     */


    Parent *kvcWayParent = [Parent new];
    
    //采用方式一给属性赋值，如果属性是用@property声明的可以直接用self.name = dict[@"name"]，如果没有用@property，而是在大括号内声明的属性要用这种方式。
    [kvcWayParent setValue:dict[@"name"] forKey:@"name"];
  
    Children *children2 = [Children new];
    [kvcWayParent setValue:children2 forKey:@"children"];
    
    /*
     * 采用方式二给属性赋值。此时要注意以下两点：
     
     * 1、是forKeyPath，不是forkey
       2、forkeyPath后childeren一定必须要和kvcWayParent里面的children属性名字一样，它后面的name必须一定要和children里面的name属性名一样。
     */
    [kvcWayParent setValue:dict[@"children"][@"name"] forKeyPath:@"children.name"];
    
    NSLog(@"kvcWay ======= %@的孩子叫做%@",kvcWayParent.name,kvcWayParent.children.name);
    

    
    Parent *newKvcWayParent = [Parent new];
    
    /* 
     * 采用第三种方式将字典转化为model,此时我们要注意以下几点：
     
     * 1、字典里面有什么东西，挑出我们需要用的（一般都需要）在model类中给声明出来。例如字典里有name,我就要在model类中声明该属性。
     
     * 2、声明属性的时候要注意匹配数据类型。如果是数字，建议声明成NSNumber,因为在进行编码的时候，kvc会自动将字典中的数字转化为NSNumber类型。
     */
    
    
    [newKvcWayParent setValuesForKeysWithDictionary:dict];

    NSLog(@"newsKvcWay ======= %@你太伟大了%@",newKvcWayParent.name,newKvcWayParent.children);

    
    
    
}




@end
