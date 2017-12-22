//
//  ActivityCell.m
//  activityPageDemo
//
//  Created by 胡伟东 on 21/12/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ActivityCell.h"
#import "XSTActivityConst.h"

@interface ActivityCell()<
UIScrollViewDelegate,
UICollectionViewDelegate,UICollectionViewDataSource
>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign, getter=isCanScroll) BOOL canScroll;
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView2;

@end

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCellSubviews];
    }
    return self;
}

- (void)setupCellSubviews {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.scrollView setContentSize:CGSizeMake(2*rect.size.width, rect.size.height)];
    self.scrollView.pagingEnabled = YES;
    [self.contentView addSubview:self.scrollView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((rect.size.width - 30)/2.0, 80);
    //列距
    flowLayout.minimumInteritemSpacing = 10;
    //行距
    flowLayout.minimumLineSpacing = 30;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) collectionViewLayout:flowLayout];
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    self.collectionView1.tag = 1;
    [self.collectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.scrollView addSubview:self.collectionView1];
    
    self.collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) collectionViewLayout:flowLayout];
    self.collectionView2.delegate = self;
    self.collectionView2.dataSource = self;
    self.collectionView2.tag = 2;
    [self.collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.scrollView addSubview:self.collectionView2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:XSTActivityViewSubScrollpNotificationName object:nil];
}


- (void)notificationAction:(NSNotification *)notification {
    if ([notification.name isEqualToString:XSTActivityViewSubScrollpNotificationName]) {
        if ([notification.userInfo[XSTActivityViewCanScrollKey] isEqualToString:@"1"]) {
            self.canScroll = YES;
        }else {
            self.canScroll = NO;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect rect = [UIScreen mainScreen].bounds;

//    scrollView.bounces = (scrollView.contentOffset.y <= 0) ? NO : YES;

//    NSLog(@"!___ scroll : %@", NSStringFromCGPoint(scrollView.contentOffset));
//
//    if (scrollView.contentOffset.y <= 0) {
//        scrollView.scrollEnabled = NO;
//    }else {
//        scrollView.scrollEnabled = YES;
//    }
    
//    if (-scrollView.contentOffset.y <= HEADHEIGHT && scrollView.contentOffset.y <= 0) {
//        //当偏移距离小于headView高时（两个tableView偏移同步）
//        if (scrollView.tag == 1) {
//            self.collectionView2.contentOffset = CGPointMake(0, self.collectionView1.contentOffset.y);
//        }else {
//            self.collectionView1.contentOffset = CGPointMake(0, self.collectionView2.contentOffset.y);
//        }
//        self.headView.frame = CGRectMake(0, -(scrollView.contentOffset.y + HEADHEIGHT), rect.size.width, HEADHEIGHT);
//    }else if(scrollView.contentOffset.y < -HEADHEIGHT){
//
//        self.headView.frame = CGRectMake(0, 0, rect.size.width, HEADHEIGHT);
//    }else {
//        //当偏移距离大于headView高时（两个tableView偏移无关）
//        self.headView.frame = CGRectMake(0, -HEADHEIGHT, rect.size.width, HEADHEIGHT);
//        //修正偏移量不准问题
//        if (scrollView.tag == 1) {
//            if (self.collectionView2.contentOffset.y < 0) {
//                self.collectionView2.contentOffset = CGPointMake(0, 0);
//            }
//        }else {
//            if (self.collectionView1.contentOffset.y < 0) {
//                self.collectionView1.contentOffset = CGPointMake(0, 0);
//            }
//        }
//    }
    
    if (self.canScroll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XSTActivityViewMainScrollNotificationName object:nil userInfo:@{XSTActivityViewCanScrollKey : @"0"}];
    }else {
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.y <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XSTActivityViewMainScrollNotificationName object:nil userInfo:@{XSTActivityViewCanScrollKey : @"1"}];
        self.canScroll = NO;
    }

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (collectionView.tag == 1) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }else {
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

@end
