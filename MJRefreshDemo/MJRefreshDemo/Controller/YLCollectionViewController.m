//
//  YLCollectionViewController.m
//  MJRefreshDemo
//
//  Created by yulong mei on 16/7/17.
//  Copyright © 2016年 yulong mei. All rights reserved.
//

#import "YLCollectionViewController.h"
#import "MJRefresh.h"

static const CGFloat YLDuration = 2.0;

//随机颜色
#define YLRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface YLCollectionViewController ()
    
    //存放假数据
@property(strong,nonatomic)NSMutableArray *colors;


@end

@implementation YLCollectionViewController

#pragma mark UICollectionView上下拉刷新
- (void)example21{
    __weak typeof(self) weakSelf = self;
    
#pragma mark 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //增加5条假数据
        for (int i = 0; i<10; i++) {
            [weakSelf.colors insertObject:YLRandomColor atIndex:0];
        }
        
        //模拟延迟加载数据，因此2秒后才调用，（真实开发中，可以移除这段GCD代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(YLDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.collectionView reloadData];
            
            //结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    //进入刷新
    [self.collectionView.mj_header beginRefreshing];
    
#pragma mark 上啦刷新
    self.collectionView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        //增加5条假数据
        for (int i = 0; i<10; i++) {
            
            [weakSelf.colors addObject:YLRandomColor];
        }
        
        //模拟延迟加载数据，2秒后才调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(YLDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark -数据相关
- (NSMutableArray *)colors{
    if (!_colors) {
        
        self.colors = [NSMutableArray array];
    }
    return _colors;
}

//初始化
- (id)init{
    
    //UICollectionViewFlowLayout的初始化（与刷新空间无关）
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    return [self initWithCollectionViewLayout:layout];
}


static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items

    //设置为不控件的显示和隐藏
    self.collectionView.mj_footer.hidden = self.colors.count == 0;
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"collection%@",indexPath);
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
