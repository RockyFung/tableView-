//
//  InsertAD.m
//  TableView广告插入
//
//  Created by rocky on 16/7/12.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "InsertAD.h"

@interface InsertAD()<IMYAOPTableViewDelegate, IMYAOPTableViewDataSource>
@property (nonatomic, strong) NSMutableArray *titles;
@end

@implementation InsertAD

- (void)setAopUtils:(IMYAOPTableViewUtils *)aopUtils{
    _aopUtils = aopUtils;
    [self injectTableView];
}

- (void)injectTableView{
    [self.aopUtils.tableView registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"AD"];
    
    ///广告回调，跟TableView的Delegate，DataSource 一样。
    self.aopUtils.delegate = self;
    self.aopUtils.dataSource = self;
    
    self.titles = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSString *str = [NSString stringWithFormat:@"我是第%d个广告",i];
        [self.titles addObject:str];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self insertRows];
    });
}

///简单的rows插入
- (void)insertRows
{
    NSMutableArray<IMYAOPTableViewInsertBody*>* insertBodys = [NSMutableArray array];
    ///随机生成了3个要插入的位置
    for (int i = 0 ; i< self.titles.count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arc4random()%10 inSection:0];
        [insertBodys addObject:[IMYAOPTableViewInsertBody insertBodyWithIndexPath:indexPath]];
    }
    ///清空 旧数据
    [self.aopUtils insertWithSections:nil];
    [self.aopUtils insertWithIndexPaths:nil];
    
    ///插入 新数据, 同一个 row 会按数组的顺序 row 进行 递增
    [self.aopUtils insertWithIndexPaths:insertBodys];

    ///调用tableView的reloadData，进行页面刷新
    [self.aopUtils.tableView reloadData];

}

/**
 *      插入sections demo
 *      单纯插入section 是没法显示的，要跟 row 配合。
 */
- (void)insertSections
{
    NSMutableArray<IMYAOPTableViewInsertBody*>* insertBodys = [NSMutableArray array];
    for (int i = 1 ; i< 6; i++) {
        NSInteger section = arc4random() % i;
        IMYAOPTableViewInsertBody* body = [IMYAOPTableViewInsertBody insertBodyWithSection:section];
        [insertBodys addObject:body];
    }
    [self.aopUtils insertWithSections:insertBodys];
    
    [insertBodys enumerateObjectsUsingBlock:^(IMYAOPTableViewInsertBody * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.indexPath = [NSIndexPath indexPathForRow:0 inSection:obj.resultSection];
    }];
    [self.aopUtils insertWithIndexPaths:insertBodys];
    
    [self.aopUtils.tableView reloadData];
}

#pragma mark-AOP Delegate
- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils numberOfSection:(NSInteger)sectionNumber
{
    ///可以获取真实的 sectionNumber 可以在这边进行一些AOP的数据初始化
//    NSLog(@"真实的sectionNumber  %ld",sectionNumber);
}
-(void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///真实的 will display 回调. 有些时候统计需要
//    NSLog(@"真实的 will display 回调 %ld",indexPath.row);
}

#pragma mark- UITableView 回调
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AD"];
    if(cell.contentView.subviews.count == 0) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageHeight = 162 * (screenWidth/320.0f);
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, imageHeight)];
        imageView.image = [UIImage imageNamed:@"aop_ad_image.jpeg"];
        imageView.layer.borderColor = [UIColor blackColor].CGColor;
        imageView.layer.borderWidth = 1;
        [cell.contentView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 200, 50)];
//        NSIndexPath *rr = [self.aopUtils tableIndexPathByReal:indexPath];
//        label.text = self.titles[indexPath.row];
        
        [cell.contentView addSubview:label];
    }
    
    NSIndexPath *rr = [self.aopUtils realIndexPathByTable:indexPath];
    NSIndexPath *ss = [self.aopUtils tableIndexPathByReal:indexPath];
    NSLog(@" yy = %ld , rr = %ld  , ss = %ld",indexPath.row, rr.row,ss.row);
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageHeight = 162 * (screenWidth/320.0f);
    return imageHeight;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"插入的cell要显示啦");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"广告被点击了> <" message:[NSString stringWithFormat:@"我的位置: %@",indexPath] delegate:nil cancelButtonTitle:@"哦~滚" otherButtonTitles:nil];
    [alertView show];
}









@end
