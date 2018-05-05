//
//  ViewController.m
//  Test
//
//  Created by Developer on 2018/4/8.
//  Copyright © 2018年 Developer. All rights reserved.
//

#import "ViewController.h"
#import "TestFlowLayout.h"
#import "DataBase.h"
#import "ChartsViewController.h"
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
/** 顶部view */
@property (nonatomic, strong) UIView *topView;
/** 底部view */
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong)UITableView *regionTableView;
@property (nonatomic, strong)NSMutableArray *provinceArray;
@property (nonatomic, strong)NSMutableArray *cityArray;
@property (nonatomic, strong)NSMutableArray *sectionIndexArray;

@end

@implementation ViewController
/** 设置顶部view */
- (void)setTopView:(UIView *)topView {
    _topView = topView;
    
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:_topView];
}
/** 设置底部view */
- (void)setBottomView:(UIView *)bottomView {
    _bottomView = bottomView;
    
    [self.view addSubview:_bottomView];
    [self.view sendSubviewToBack:_bottomView];
    
    // 翻转180度
    CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    _bottomView.layer.transform = transform;
}
- (NSMutableArray *)provinceArray
{
    if (_provinceArray == nil) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}
- (NSMutableArray *)cityArray
{
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
- (NSMutableArray *)sectionIndexArray
{
    if (_sectionIndexArray == nil) {
        _sectionIndexArray = [NSMutableArray array];
    }
    return _sectionIndexArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self createView];
//    [self createCollectionView];
//    [self createRegionView];
    [self textTest];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)textTest
{
    NSLog(@"it's ok");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@%@", path, dic);
    _regionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _regionTableView.delegate = self;
    _regionTableView.dataSource = self;
    [self.view addSubview:_regionTableView];
    self.cityArray = [dic objectForKey:@"Data"];
    [self.sectionIndexArray addObject:@"历史"];
    for (NSDictionary *dict in self.cityArray) {
        [self.sectionIndexArray addObject:[dict objectForKey:@"title"]];
    }
    
    UIView *indexView = [[UIView alloc]initWithFrame:CGRectMake(700 / 2, 270 / 2, 26, 860 / 2)];
    indexView.backgroundColor = [UIColor redColor];
    [self.view addSubview:indexView];
    for (int i = 0; i < self.sectionIndexArray.count; i++) {
        UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        indexButton.frame = CGRectMake(0, 860/ 2 / self.sectionIndexArray.count * i, indexView.frame.size.width, 860 / 2 / self.sectionIndexArray.count);
        indexButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [indexButton setTitle:[self.sectionIndexArray objectAtIndex:i] forState:UIControlStateNormal];
        indexButton.tag = 1001 + i;
        [indexButton addTarget:self action:@selector(indexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [indexView addSubview:indexButton];
    }
    NSLog(@"asdfas");
    [DataBase sharedDataBase];
}
- (void)indexButtonClick:(UIButton *)sender
{
    if (sender.tag > 1001) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag - 1001];
        [self.regionTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        [self.regionTableView  scrollRectToVisible:CGRectMake(0, 0, 0.1f, 0.1f) animated:YES];
    }
    
}
- (void)createRegionView
{
    //读取txt文件的路径
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    
    //gbk编码 如果txt文件为utf-8的则使用NSUTF8StringEncoding
    //    NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    //定义字符串接收从txt文件读取的内容
//    NSString *str = [[NSString alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSString *str = [self readTxtFromPath:txtPath];
    //将字符串转为nsdata类型
    NSData *data = [str dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"data%@", data);
    //将nsdata类型转为NSDictionary
    NSDictionary *pDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dic%@", pDic);
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"json.plist"];
    NSLog(@"%@", filename);
    //输入写入
    [pDic writeToFile:filename atomically:YES];
    
    NSString *jsonPlist = [[NSBundle mainBundle]pathForResource:@"json" ofType:@"plist"];
    NSLog(@"%@", jsonPlist);
    NSLog(@"%@", jsonPlist);
    
    // 最后再从本地将数据从本地取出来 看下是否正确
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filename]];
    
    NSString *regionPlist = [[NSBundle mainBundle]pathForResource:@"region" ofType:@"plist"];
    NSArray *regionArray = [NSArray arrayWithContentsOfFile:regionPlist];
    
    for (NSDictionary *dict in regionArray) {
        [self.provinceArray addObject:[dict objectForKey:@"name"]];
        [self.cityArray addObject:[dict objectForKey:@"cities"]];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return [[self.cityArray[section - 1] objectForKey:@"region"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [[self.cityArray[indexPath.section - 1] objectForKey:@"region"] objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 100;
    }
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        headerView.backgroundColor = [UIColor cyanColor];

        return headerView;
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    titleLabel.text = [self.cityArray[section - 1] objectForKey:@"title"];
    titleLabel.backgroundColor = [UIColor whiteColor];
    return titleLabel;
//    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartsViewController *charts = [[ChartsViewController alloc]init];
    [self.navigationController pushViewController:charts animated:YES];
}
- (void)createCollectionView
{
    TestFlowLayout *layout = [[TestFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(200, 200);
    
    UICollectionView *collectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if (indexPath.row == 0 || indexPath.row == 11) {
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.backgroundColor = [UIColor cyanColor];
    }
    return cell;
}
- (void)createView
{
    //需要翻转的视图
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 320, 200)];
    parentView.backgroundColor = [UIColor yellowColor];
    parentView.tag = 1000;
    [self.view addSubview:parentView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始准备动画
    [UIView beginAnimations:nil context:context];
    //设置动画曲线，翻译不准，见苹果官方文档
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画持续时间
    [UIView setAnimationDuration:1.0];
    //因为没给viewController类添加成员变量，所以用下面方法得到viewDidLoad添加的子视图
    UIView *parentView = [self.view viewWithTag:1000];
    //设置动画效果
//    [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:parentView cache:YES];  //从上向下
    // [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:parentView cache:YES];   //从下向上
    // [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:parentView cache:YES];  //从左向右
     [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:parentView cache:YES];//从右向左
    //设置动画委托
    [UIView setAnimationDelegate:self];
    //当动画执行结束，执行animationFinished方法
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    //提交动画
    [UIView commitAnimations];
}

//动画效果执行完毕
- (void) animationFinished: (id) sender{
    NSLog(@"animationFinished !");
}
/**
 翻转
 
 @param duration 翻转动画所需时间
 @param completion 动画结束后的回调
 */
- (void)turnWithDuration:(NSTimeInterval)duration completion:(void(^)(void))completion{
    if (!self.topView || !self.bottomView) {
        NSAssert(NO, @"未设置topView或bottomView");
    }
    
    // 动画进行到一半的时候将bottomView移到上层
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration / 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self.bottomView];
    });
    
    // 翻转180度
    [UIView animateWithDuration:duration animations:^{
        CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        self.view.layer.transform = transform;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}
- (NSString *)readTxtFromPath:(NSString *)path{
    
    //GBK
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSError *error ;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:encode error:&error];
    
    return content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
