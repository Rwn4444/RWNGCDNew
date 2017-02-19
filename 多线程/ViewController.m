//
//  ViewController.m
//  多线程
//
//  Created by RWN on 17/2/18.
//  Copyright © 2017年 RWN. All rights reserved.
//

#import "ViewController.h"
#import "RWNDemoController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"RWNDemo";
    self.RWNTableView.delegate=self;
    self.RWNTableView.dataSource=self;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=self.dataArray[indexPath.row];
    return cell;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RWNDemoController *demo=[[RWNDemoController alloc] init];
    demo.type=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.navigationController pushViewController:demo animated:YES];

}


-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray=[NSMutableArray arrayWithObjects:@"NSOperation无序下载",@"NSOperation有序下载",@"GCD无序下载",@"GCD有序下载", nil];
    }
    return _dataArray;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
