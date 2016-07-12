//
//  ViewController.m
//  TableView广告插入
//
//  Created by rocky on 16/7/12.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "ViewController.h"
#import "InsertAD.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@property (nonatomic, strong) NSMutableArray *images;
///只是声明，防止提前释放
@property (nonatomic, strong) InsertAD* insertAD;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Feed List Demo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    self.images = @[].mutableCopy;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    for (int i = 0; i < 10; i++) {
        [self addCell:[NSString stringWithFormat:@"正常标题 - %d",i] class:@"T1HomeTimelineItemsViewController" image:@"Twitter.jpg"];
    }
    
//    [self addCell:@"Weibo" class:@"WBStatusTimelineViewController" image:@"Weibo.jpg"];
    
    
    // 在这个页面显示广告
    self.insertAD = [InsertAD new];
    self.insertAD.aopUtils = self.tableView.aop_utils;
    
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title class:(NSString *)className image:(NSString *)imageName {
    [self.titles addObject:title];
    [self.classNames addObject:className];
    [self.images addObject:[UIImage imageNamed:imageName]];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.imageView.image = _images[indexPath.row];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 48 / 2;
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"内容被点击了> <" message:[NSString stringWithFormat:@"我的位置: %@",indexPath] delegate:nil cancelButtonTitle:@"哦~滚" otherButtonTitles:nil];
    [alertView show];
    
    
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        
        // 这是在跳转页面显示广告
        ///begin 插入3行代码
//        self.insertAD = [InsertAD new];
//        UITableView* feedsTableView = [ctrl valueForKey:@"tableView"];
//        self.insertAD.aopUtils = feedsTableView.aop_utils;
        ///end
        
        ctrl.title = _titles[indexPath.row];
        self.title = @" ";
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
