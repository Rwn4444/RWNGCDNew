//
//  RWNDemoController.m
//  多线程
//
//  Created by RWN on 17/2/18.
//  Copyright © 2017年 RWN. All rights reserved.
//

#import "RWNDemoController.h"
#import "RWNTableViewCell.h"
@interface RWNDemoController (){

    dispatch_group_t _groupg;

}

@property (nonatomic, strong) NSArray *urlStrs;

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation RWNDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.type isEqualToString:@"0"]) {
        
        [self setupNSOperationFirst];
        
    }else if ([self.type isEqualToString:@"1"]){
     
        [self setupNSOperationSecond];
    
    }else if ([self.type isEqualToString:@"2"]){
        
        [self setupGCDFirst];
        
    }else if ([self.type isEqualToString:@"3"]){
        
        [self setupGCDSecond];
        
    }
    
    
    // Do any additional setup after loading the view.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *identifier = @"cell";
    RWNTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[RWNTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (self.images.count>indexPath.row) {
    cell.imgView.image=self.images[indexPath.row];
    }
    
    return cell;


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;

}


//无序
-(void)setupNSOperationFirst{

    
    typeof(self) weakSelf=self;
    
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    
    NSOperation *op=[NSBlockOperation blockOperationWithBlock:^{
       
        NSString *str =self.urlStrs[0];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        //刷新UI一定要在主线程  刚开始没有在主线程 显示的非常慢
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
   
    [queue addOperation:op];
    

    NSOperation *op1=[NSBlockOperation blockOperationWithBlock:^{
        
        
        NSString *str =self.urlStrs[1];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
  
    [queue addOperation:op1];
    
    
    NSOperation *op2=[NSBlockOperation blockOperationWithBlock:^{
        
        
        NSString *str =self.urlStrs[2];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          [weakSelf.tableView reloadData];
        }];
       
    }];
    
    [queue addOperation:op2];
    
    NSOperation *op3=[NSBlockOperation blockOperationWithBlock:^{
        
        
        NSString *str =self.urlStrs[3];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
   
    [queue addOperation:op3];


   
}

//有序
-(void)setupNSOperationSecond{
    
    
    typeof(self) weakSelf=self;
    
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    
    NSOperation *op=[NSBlockOperation blockOperationWithBlock:^{
        
        NSString *str =self.urlStrs[0];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        //刷新UI一定要在主线程  刚开始没有在主线程 显示的非常慢
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    
    
    
    
    NSOperation *op1=[NSBlockOperation blockOperationWithBlock:^{
        
        
        NSString *str =self.urlStrs[1];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    
    
    
    
    NSOperation *op2=[NSBlockOperation blockOperationWithBlock:^{
        
        
        NSString *str =self.urlStrs[2];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
        
    }];
    
    
    NSOperation *op3=[NSBlockOperation blockOperationWithBlock:^{
        
        
        NSString *str =self.urlStrs[3];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    /*有序的下载就是添加一个依赖  [op1 addDependency:op]; op下载完成之后再下载op1 依次类推  就是有序的了 不同的NSOperationQueue 可以添加依赖*/
    [op1 addDependency:op];
    [op2 addDependency:op1];
    [op3 addDependency:op2];
   
    [queue addOperation:op];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    
}


-(void)setupGCDFirst{

    typeof(self) weakSelf=self;
    
    _groupg=dispatch_group_create();
    
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[0];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
       
        dispatch_group_leave(_groupg);
        
    });
    
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[1];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        dispatch_group_leave(_groupg);
        
    });
    
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[2];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        dispatch_group_leave(_groupg);
        
    });
    
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[3];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        dispatch_group_leave(_groupg);
        
    });
    
    
    dispatch_group_notify(_groupg, dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

-(void)setupGCDSecond{
    
    dispatch_semaphore_t sema=dispatch_semaphore_create(1);
    
    typeof(self) weakSelf=self;
    
    _groupg=dispatch_group_create();
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[0];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        dispatch_group_leave(_groupg);
        
        dispatch_semaphore_signal(sema);
        
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[1];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        dispatch_group_leave(_groupg);
        
        dispatch_semaphore_signal(sema);

    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[2];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        dispatch_group_leave(_groupg);
        
        dispatch_semaphore_signal(sema);

    });
    
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_groupg);
    dispatch_group_async(_groupg, dispatch_get_global_queue(0, 0), ^{
        NSString *str =self.urlStrs[3];
        NSURL *url=[NSURL URLWithString:str];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [weakSelf.images addObject:image];
        
        dispatch_group_leave(_groupg);
        dispatch_semaphore_signal(sema);

    });
    
    
    dispatch_group_notify(_groupg, dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSArray *)urlStrs {
    if (!_urlStrs) {
        _urlStrs = @[@"http://img.juimg.com/tuku/yulantu/130904/328512-130Z41J34638.jpg",
                     @"http://img05.tooopen.com/images/20140805/sy_68194794777.jpg",
                     @"http://img.taopic.com/uploads/allimg/140814/240410-140Q40F92258.jpg",
                     @"http://img.taopic.com/uploads/allimg/140814/240410-140Q406492266.jpg"];
    }
    return _urlStrs;
}

-(NSArray *)images{
    
    if (!_images) {
        _images=[NSMutableArray array];
    }
    return _images;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
