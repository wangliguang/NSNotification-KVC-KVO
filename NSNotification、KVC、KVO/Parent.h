//
//  Parent.h
//  NSNotification、KVC、KVO
//
//  Created by GG on 16/2/12.
//  Copyright © 2016年 王立广. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Children.h"

@interface Parent : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,retain) Children *children;

@end
