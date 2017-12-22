//
//  ViewController.m
//  activityPageDemo
//
//  Created by 胡伟东 on 20/12/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "ActivityCell.h"
#import "XSTActivityConst.h"

@interface FCHActivityViewControllerMainTableView : UITableView
@end

@implementation FCHActivityViewControllerMainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end

#define HEADHEIGHT 400

@interface ViewController ()<
UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) FCHActivityViewControllerMainTableView *tableView;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) ActivityCell *activityCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, HEADHEIGHT)];
    self.headView.backgroundColor = [UIColor blackColor];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, HEADHEIGHT - 50, rect.size.width, 50)];
    titleLb.text = @"23333233332333323333233332333323333332333323333";
    titleLb.textColor = [UIColor whiteColor];
    [self.headView addSubview:titleLb];
    
    self.tableView = [[FCHActivityViewControllerMainTableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 999;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:self.headView];
    
    //初始化默认最外面的可以动
    self.canScroll = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:XSTActivityViewMainScrollNotificationName object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notificationAction:(NSNotification *)notification {
    if ([notification.name isEqualToString:XSTActivityViewMainScrollNotificationName]) {
        if ([notification.userInfo[XSTActivityViewCanScrollKey] isEqualToString:@"1"]) {
            self.canScroll = YES;
        }else {
            self.canScroll = NO;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.activityCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (self.activityCell == nil) {
        self.activityCell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCell"];
    }
    return self.activityCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [UIScreen mainScreen].bounds;
    return rect.size.height;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect rect = [UIScreen mainScreen].bounds;
    
    //    scrollView.bounces = (scrollView.contentOffset.y <= 0) ? NO : YES;
//    if (scrollView.contentOffset.y >= HEADHEIGHT) {
//        scrollView.scrollEnabled = NO;
//        ActivityCell *cell = [self.contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        cell.collectionView1.scrollEnabled = YES;
//        cell.collectionView2.scrollEnabled = YES;
//    }else {
//        scrollView.scrollEnabled = YES;
//    }
//    NSLog(@"!___ scroll : %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    if (self.canScroll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XSTActivityViewSubScrollpNotificationName object:nil userInfo:@{XSTActivityViewCanScrollKey : @"0"}];
    }else {
        scrollView.contentOffset = CGPointMake(0, HEADHEIGHT);
    }
    
    if (scrollView.contentOffset.y >= HEADHEIGHT) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XSTActivityViewSubScrollpNotificationName object:nil userInfo:@{XSTActivityViewCanScrollKey : @"1"}];
        self.canScroll = NO;
    }
    
}


@end
