//
//  KVOViewController.m
//  NSNotification、KVC、KVO
//
//  Created by GG on 16/2/12.
//  Copyright © 2016年 王立广. All rights reserved.
//

#import "KVOViewController.h"
#import "Parent.h"
@interface KVOViewController ()
{
    Parent *parent;
    
    UILabel *label;
}
@end

/*
 * KVO
 
 * What  : Key-Value Observing（键值观察），它提供一种机制，当指定的对象的属性被修改后，则对象就会接受到通知。简单的说就是每次指定的被观察的对象的属性被修改后，KVO就会自动通知相应的观察者了。
 
 * Where : 需要监听某对象某一属性的变化时
 
 * Why   : 能够实时监听对象属性的变化
 
 * How   : 1、采用下面这个方法给属性添加观察者,各参数详情见下文
              - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

           2、观察者实现下面方法，如果监听的属性发生变化，便会调用这个该方法。
              - (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context;
 
           3、适时调用下面方法移除观察者,个人习惯在delloc中释放。
              - (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;
 */

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"KVO";
    
    parent = [Parent new];
    
    Children *children = [Children new];
    
    parent.children = children;
    
    //给parent的起名字，给parent的children起名字
    parent.children.name = @"闪闪";
    parent.name = @"小闪";
    
    /*
     * 监听parent的children的名字
     
     * observer: 设置观察者
     
     * forkeyPath: 设置对象的属性，要注意这里传入的是字符串。在这里我传入的是"children.name"。也就是说我要监听的是parent对象的children属性的name属性。所以说KVO是在KVC的基础上实现的。
     
     * options: 
                NSKeyValueObservingOptionNew：当options中包括了这个参数的时候，观察者收到的change参数中就会包含NSKeyValueChangeNewKey和它对应的值，也就是说，观察者可以得知这个property在被改变之后的新值。
     
                NSKeyValueObservingOptionOld：和NSKeyValueObservingOptionNew的意思类似，当包含了这个参数的时候，观察者收到的change参数中就会包含NSKeyValueChangeOldKey和它对应的值。
     
                NSKeyValueObservingOptionInitial：当包含这个参数的时候，在addObserver的这个过程中，就会有一个notification被发送到观察者那里，反之则没有。
     
                NSKeyValueObservingOptionPrior：当包含这个参数的时候，在被观察的property的值改变前和改变后，系统各会给观察者发送一个change notification；在property的值改变之前发送的change notification中，change参数会包含NSKeyValueChangeNotificationIsPriorKey并且值为@YES，但不会包含NSKeyValueChangeNewKey和它对应的值。
     
                可以指定多个NSKeyValueObservingOptions，将他们用“或”连接后，作为options参数。常用的就前三种，第四种知道便可。目前我们只需知道前三种便可。
    
     
     * content: 可以将任意对象作为参数在这里传递。
     
     */
    [parent addObserver:self forKeyPath:@"children.name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:nil];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, kScreenWidth-200, 40)];
    label.text = [NSString stringWithFormat:@"%@的孩子名字叫做%@",parent.name,parent.children.name];
    [self.view addSubview:label];
    
    
    UITextField *textfiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 300, kScreenWidth-200, 40)];
    textfiled.placeholder = @"重新输入孩子的名字";
    [textfiled addTarget:self action:@selector(textfiledChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textfiled];
    
}

- (void)textfiledChanged:(UITextField *)textfiled{
    
    parent.children.name = textfiled.text;
}




/*
 * 如果监听的属性发生了变化，调用该方法。
 
 * keyPath: 传进来发生变化的属性。
 
 * object: 所监听的对象
 
 * change：是一个字典，包含了与property的值变化相关的信息。其中可能会有这样几个键值对，
 
           NSKeyValueChangeKindKey：这是change中永远会包含的键值对，它的值时一个NSNumber对象，具体的数值有NSKeyValueChangeSetting(对属性进行赋值操作)、NSKeyValueChangeInsertion(对属性进行插入操作)、NSKeyValueChangeRemoval(对属性进行移除操作)、NSKeyValueChangeReplacement(对属性进行替换操作)这几个，其中后三个是针对于一对多关系的。
 
           NSKeyValueChangeNewKey：只有当addObserver的时候在optional参数中加入NSKeyValueObservingOptionNew，这个键值对才会被change参数包含；它表示这个property改变后的新值。
 
           NSKeyValueChangeNewOld：只有当addObserver的时候在optional参数中加入NSKeyValueObservingOptionOld，这个键值对才会被change参数包含；它表示这个property改变前的值。
 
           NSKeyValueChangeIndexesKey：当被观察的property是一个ordered to-many relationship时，这个键值对才会被change参数包含；它的值是一个NSIndexSet对象。
 
           NSKeyValueChangeNotificationIsPriorKey：只有当addObserver的时候在optional参数中加入NSKeyValueObservingOptionPrior，这个键值对才会被change参数包含；它的值是@YES。
 
           用[change objectForKey:@"old"]获取变化前的值
           用[change objectForKey:@"new"]获取变化后的值
 
 *
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    label.text = [NSString stringWithFormat:@"%@的孩子叫做%@",parent.name, [change objectForKey:@"new"]];
    
    NSLog(@"上次的名字是%@",[change objectForKey:@"old"]);
    
    
}

- (void)dealloc{
    
    [parent removeObserver:self forKeyPath:@"children.name"];
    
}


@end
