//
//  ViewController.m
//  zhen
//
//  Created by cxz on 16/7/23.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "ViewController1.h"

#import "KCImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface ViewController () {
    
    UIImageView *imageV;
    NSMutableArray *imageArray;
}

@property (strong,nonatomic) NSString *s;

@end

@implementation ViewController

@synthesize age = _age;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////    imageV.contentMode=UIViewContentModeScaleAspectFit;
//    [self.view addSubview:imageV];
    
//
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame=CGRectMake(self.view.frame.size.width/2-100, 500, 200, 25);
//    [button setTitle:@"加载图片" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(loadImageWithThread) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
//    NSURL *url=[NSURL URLWithString:@"http://www.365zhanlan.com/upimg/allimg/2014/12/132U31526-0.jpg"];
//    [imageV sd_setImageWithURL:url];
    
    //多个线程的并发 1.创建多个图片控件用于显示图片
//    imageArray = [[NSMutableArray alloc] init];
//    [self layoutUI];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 100, 100, 25)];
    [button setTitle:@"下一页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)btnClicked:(id)sender {
    
    ViewController1 *v = [[ViewController1 alloc] init];
    
    v.NextViewControllerBlock = ^(NSString *text) {
        [self resetLabel:text];
    };
    [self.navigationController pushViewController:v animated:YES];
}

- (void)resetLabel:(NSString *)textStr {
    
    self.navigationItem.title = textStr;
}

////多线程下载图片
//- (void)loadImageWithThread {
//    //方法1：使用对象方法
//    //创建一个线程，第一个参数是请求的操作，第二个参数是操作方法的参数
//    //    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
//    //    //启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
//    //    [thread start];
//    
//    //方法2：使用类方法
//    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
//}
//
////加载图片
//- (void)loadImage {
//    //请求数据
//    NSData *data = [self requestData];
//    /*将数据显示到UI控件,注意只能在主线程中更新UI,
//     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
//     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
//     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
//     waitUntilDone:是否线程任务完成执行
//     */
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
//}
//
////将图片显示到界面
//- (void)updateImage:(NSData *)imageData {
//    
//    UIImage *image = [UIImage imageWithData:imageData];
//    imageV.image = image;
//}
//
//#pragma mark 请求图片数据
//- (NSData *)requestData {
//    
//    //对于多线程操作建议把线程操作放到@autoreleasepool中
//    @autoreleasepool {
//        
//        NSURL *url = [NSURL URLWithString:@"http://www.365zhanlan.com/upimg/allimg/2014/12/132U31526-0.jpg"];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        return data;
//    }
//}

//界面布局2.
- (void)layoutUI {
    
    for (int r = 0; r < ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //imageView.backgroundColor=[UIColor redColor];
            [self.view addSubview:imageView];
            [imageArray addObject:imageView];
            
        }
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(self.view.frame.size.width/2-100, 500, 200, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadImageWithThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

//多线程下载图片
- (void)loadImageWithThread {
    //创建多个线程用于填充图片
    for (int i=0; i<ROW_COUNT*COLUMN_COUNT; ++i) {
        //[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:i]];
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        [thread start];
    }
}

//加载图片
- (void)loadImage:(NSNumber *)index {
    //    NSLog(@"%i",i);
    //currentThread方法可以取得当前操作线程
    NSLog(@"current thread:%@",[NSThread currentThread]);
    
    int i = [index intValue];
    
    //    NSLog(@"%i",i);//未必按顺序输出
    
    NSData *data= [self requestData:i];
    
    KCImageData *imageData=[[KCImageData alloc] init];
    imageData.index = i;
    imageData.data=data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}

//将图片显示到界面
- (void)updateImage:(KCImageData *)imageData {
    
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageView = imageArray[imageData.index];
    imageView.image = image;
}

#pragma mark 请求图片数据
- (NSData *)requestData:(int )index {
    //对于多线程操作建议把线程操作放到@autoreleasepool中
    @autoreleasepool {
        NSURL *url=[NSURL URLWithString:@"http://www.365zhanlan.com/upimg/allimg/2014/12/132U31526-0.jpg"];
        NSData *data=[NSData dataWithContentsOfURL:url];
        return data;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















