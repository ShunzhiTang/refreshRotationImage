//
//  ViewController.m
//  refreshRotationImage
//
//  Created by tang on 16/3/31.
//  Copyright © 2016年 shunzhitang. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
@interface ViewController () <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic,strong) UzysRadialProgressActivityIndicator *radialIndicator;
@property (weak, nonatomic) IBOutlet UITableView *TSZTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"test";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    self.TSZTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
     self.TSZTableView.autoresizingMask = UIViewAutoresizingNone;
    
    self.TSZTableView.delegate  =self;
    self.TSZTableView.dataSource = self;
    
    self.TSZTableView.showsVerticalScrollIndicator = NO;
    self.TSZTableView.showsHorizontalScrollIndicator = NO;
    self.TSZTableView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf =self;
    
    [self.view addSubview:self.TSZTableView];
    //Because of self.automaticallyAdjustsScrollViewInsets you must add code below in viewWillApper
    
    [_TSZTableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
}


- (void)insertRowAtTop {
    __weak typeof(self) weakSelf = self;
    
    int64_t delayInSeconds = 2.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.TSZTableView beginUpdates];
//        [weakSelf.pData insertObject:[NSDate date] atIndex:0];
//        [weakSelf.TSZTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.TSZTableView endUpdates];
        
        //Stop PullToRefresh Activity Animation
        [weakSelf.TSZTableView stopRefreshAnimation];
    });
}


#pragma mark: uitableview的 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    
    cell.detailTextLabel.text = @"detail";
    
    if (indexPath.row == 5) {
         cell.textLabel.text = @"change image";
        return cell;
    }
    cell.textLabel.text = @"nofound";
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [self.TSZTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 5)
    {
        [self.TSZTableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"thunderbird"]];
    }
}

@end
