//
//  ViewController1.h
//  zhen
//
//  Created by cxz on 16/7/24.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController1 : UIViewController

@property (nonatomic,copy) void (^NextViewControllerBlock)(NSString *text);

@end
