//
//  DynamicBgViewController.m
//  YJBannerViewDemo
//
//  Created by YJHou on 2017/11/7.
//  Copyright © 2017年 地址:https://github.com/stackhou/YJBannerViewOC . All rights reserved.
//

#import "DynamicBgViewController.h"
#import "YJBannerView.h"
#import <ChameleonFramework/Chameleon.h>
#import <UIImageView+WebCache.h>

@interface DynamicBgViewController () <YJBannerViewDataSource, YJBannerViewDelegate>

@property (nonatomic, strong) UIView *bannerBgView;
@property (nonatomic, strong) YJBannerView *bannerView; /**< banner */
@property (nonatomic, strong) NSArray *showImagePaths;
@property (nonatomic, strong) NSMutableArray *showImageColors; /**< 要显示的图片 */

@end

@implementation DynamicBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setUpDynamicBgMainView];
}

- (void)_setUpDynamicBgMainView{
    
    [self.view addSubview:self.bannerBgView];
    [self.showImageColors removeAllObjects];
    for (NSInteger i = 0; i < self.showImagePaths.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.showImagePaths[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self savaImageColor:image];
        }];
        [self.view addSubview:imageView];
    }
}

- (void)savaImageColor:(UIImage *)image{
    
    
//    UIColor *color = [[NSArray arrayOfColorsFromImage:image withFlatScheme:YES] lastObject];
    
    UIColor *color = [UIColor colorWithAverageColorFromImage:image];
    [self.showImageColors addObject:color];
    
    if (self.showImageColors.count == self.showImagePaths.count) {
        self.bannerBgView.backgroundColor = [self.showImageColors objectAtIndex:0];
        [self.bannerView reloadData];
    }
}

#pragma mark - DataSource
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView{
    return self.showImagePaths;
}

- (void)bannerView:(YJBannerView *)bannerView didScroll2Index:(NSInteger)index{
//    NSLog(@"滚动到-->%ld", index);
    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction  animations:^{
//        self.bannerBgView.backgroundColor = [self.showImageColors objectAtIndex:index];
//    } completion:^(BOOL finished) {
//
//    }];
}

- (void)bannerView:(YJBannerView *)bannerView didScrollCurrentIndex:(NSInteger)currentIndex contentOffset:(CGFloat)contentOffset{
    
//    NSLog(@"当前页面-->%ld", currentIndex);
    
    CGFloat showItemW = bannerView.frame.size.width;
//    NSLog(@"showItemW-->%f", contentOffset);
    CGFloat halfWidth = fabs(contentOffset - showItemW * 0.5);
    CGFloat alpah = halfWidth / (showItemW * 0.5);
    NSLog(@"alpah-->%f", alpah);
    if (alpah <= 1) {
        alpah = 1;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction  animations:^{
        UIColor *showColor = [self.showImageColors objectAtIndex:currentIndex];
        self.bannerBgView.backgroundColor = [showColor colorWithAlphaComponent:alpah];;

    } completion:^(BOOL finished) {

    }];
    
    
}

#pragma mark - Lazy
- (UIView *)bannerBgView{
    if (!_bannerBgView) {
        _bannerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 240)];
        [_bannerBgView addSubview:self.bannerView];
        _bannerBgView.userInteractionEnabled = YES;
    }
    return _bannerBgView;
}

- (YJBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [YJBannerView bannerViewWithFrame:CGRectMake(15, 40, kSCREEN_WIDTH - 30, 140) dataSource:self delegate:self emptyImage:[UIImage imageNamed:@"placeholder"] placeholderImage:[UIImage imageNamed:@"placeholder"] selectorString:@"sd_setImageWithURL:placeholderImage:"];
        _bannerView.layer.cornerRadius = 5.0f;
        _bannerView.layer.masksToBounds = YES;
//        _bannerView.repeatCount = 2;
//        _bannerView.autoScroll = NO;
    }
    return _bannerView;
}

- (NSArray *)showImagePaths{
    
    return @[@"http://img.zcool.cn/community/01430a572eaaf76ac7255f9ca95d2b.jpg",
             @"http://img.zcool.cn/community/0137e656cc5df16ac7252ce6828afb.jpg",
             @"http://img.zcool.cn/community/01e5445654513e32f87512f6f748f0.png@900w_1l_2o_100sh.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513327933031&di=d3626251a1d506e10093bb714fe8c773&imgtype=0&src=http%3A%2F%2Fpic74.nipic.com%2Ffile%2F20150803%2F20546783_180157153760_2.jpg"
             ];
}

- (NSMutableArray *)showImageColors{
    if (!_showImageColors) {
        _showImageColors = [NSMutableArray array];
    }
    return _showImageColors;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
