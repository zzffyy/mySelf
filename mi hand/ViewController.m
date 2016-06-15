//
//  ViewController.m
//  mi hand
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "headerView.h"
#import "InsideView.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic)UITableView *tabView;
@property (weak, nonatomic)UIView*bgView;
@property (weak, nonatomic)UIView*cover;
@property (weak, nonatomic)InsideView*inside;
@property (weak, nonatomic)headerView*hView;
@property (weak, nonatomic)UILabel*runLable;
@property (weak, nonatomic)UIImageView*ball;
@end

@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
    
}



//减速停止了时执行，手触摸时执行执行
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (-scrollView.contentOffset.y<SCREEN_HEIGHT*3.1/5 &&-scrollView.contentOffset.y>(SCREEN_HEIGHT*3.1/5)*0.5) {
        [scrollView setContentOffset:CGPointMake(0, -SCREEN_HEIGHT*3.1/5) animated:YES];
    }
}

//完成拖拽
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self scrollViewDidEndDecelerating:scrollView];
    
}


//只要滚动了就会触发
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (-scrollView.contentOffset.y >= SCREEN_HEIGHT*3.1/5) {
        
        self.bgView.height = SCREEN_HEIGHT*3.1/5-50;
        self.cover.y =-scrollView.contentOffset.y-50;
        self.cover.alpha = (SCREEN_HEIGHT*3.1/5+50+scrollView.contentOffset.y)/50 ;

        CALayer *layer = self.hView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0, 0.1f, 0.0f, 0.0f);
        layer.transform = rotationAndPerspectiveTransform;
        
        CALayer *layerIN = self.inside.layer;
        layerIN.transform = rotationAndPerspectiveTransform;
        
        CGPoint cen = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*3.1/10);
        
        self.runLable.center = cen;
        self.hView.center=cen;
        self.inside.center = cen;
        
    }else if (-scrollView.contentOffset.y >= (SCREEN_HEIGHT*3.1/5)*0.5 ) {
        
        self.bgView.height = -scrollView.contentOffset.y;
        self.cover.alpha = 0.0;
        
    }else{
        self.bgView.height =  (SCREEN_HEIGHT*3.1/5)*0.5;
                self.cover.alpha = 0.0;
        
        self.runLable.center = self.bgView.center;
        self.hView.center=self.bgView.center;
        self.inside.center = self.bgView.center;
        
        self.hView.alpha = 0.0;
        self.inside.alpha = 0.0;
        
    }

    
    if(-scrollView.contentOffset.y >(SCREEN_HEIGHT*3.1/5)*0.5 && -scrollView.contentOffset.y <SCREEN_HEIGHT*3.1/5){

        CALayer *layer = self.hView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (-scrollView.contentOffset.y -((SCREEN_HEIGHT*3.1/5)*0.5))/(SCREEN_HEIGHT*3.1/5*0.5) *- M_PI /2 +M_PI/2, 0.1f, 0.0f, 0.0f);
        layer.transform = rotationAndPerspectiveTransform;
        
        CALayer *layerIN = self.inside.layer;
        layerIN.transform = rotationAndPerspectiveTransform;

        self.hView.center = self.bgView.center;
        self.runLable.center = self.bgView.center;
        self.inside.center = self.hView.center;
        
        self.hView.alpha = (-scrollView.contentOffset.y -(SCREEN_HEIGHT*3.1/5)*0.5)/(SCREEN_HEIGHT*3.1/5*0.5)*0.5;
        self.inside.alpha = (-scrollView.contentOffset.y -(SCREEN_HEIGHT*3.1/5)*0.5)/(SCREEN_HEIGHT*3.1/5*0.5)*0.5;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildViews];
    
    [self setRefresh];

}

-(void)setUpChildViews{

    
    UITableView*tabView=[[UITableView alloc]init];
    tabView.frame = self.view.bounds;
    tabView.dataSource= self;
    tabView.delegate = self;
    self.tabView = tabView;
    tabView.contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT*3.1/5, 0, 0, 0);
    tabView.backgroundColor = [UIColor lightGrayColor];
    tabView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:tabView];
    
    UIView*bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*3.1/5 -50);
    bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView = bgView;
    [self.view addSubview:bgView];

    //遮罩涂层
    UIView*cover = [[UIView alloc]init];
    cover.frame = CGRectMake(0, SCREEN_HEIGHT*3.1/5-50, SCREEN_WIDTH, 50);
    cover.backgroundColor = [UIColor lightGrayColor];
    self.cover = cover;
    [self.view addSubview:cover];

    

    //外部圆环图层
    headerView*hView = [[headerView alloc]init];
    hView.frame = CGRectMake((SCREEN_WIDTH - (SCREEN_HEIGHT*3.1/5-100))*0.5, 50, SCREEN_HEIGHT*3.1/5-100, SCREEN_HEIGHT*3.1/5-100);
    hView.backgroundColor = [UIColor lightGrayColor];
    hView.alpha = 0.5;
    self.hView = hView;
     [self.bgView addSubview:hView];


    //  内部圆环图层
    InsideView*inside = [[InsideView alloc]init];
    inside.frame =CGRectMake((SCREEN_WIDTH - (SCREEN_HEIGHT*3.1/5-100))*0.5, 50, SCREEN_WIDTH-((SCREEN_WIDTH - (SCREEN_HEIGHT*3.1/5-100))*0.5)*2,  SCREEN_WIDTH-((SCREEN_WIDTH - (SCREEN_HEIGHT*3.1/5-100))*0.5)*2);
    inside.alpha = 0.5;
    inside.backgroundColor = [UIColor lightGrayColor];
    self.inside = inside;
    [self.bgView addSubview:inside];

    
    
    
    //中间文字lable
    UILabel*runLable = [[UILabel alloc]init];
    runLable.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)*0.5, (self.bgView.frame.size.height-100)*0.5, 100, 100);
    runLable.text = @"18920";
    runLable.font = [UIFont systemFontOfSize:20];
    runLable.textAlignment = NSTextAlignmentCenter;
    runLable.center = self.inside.center;
    self.runLable = runLable;
    [self.view addSubview:runLable];
    

    //小球图片
    UIImageView*ball = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flash-JC-27_clip_image002.jpg"]];
    self.ball.layer.anchorPoint = CGPointMake(0.5, 0.25);
    ball.frame = CGRectMake(self.hView.width*0.5, 0, 10, 10);
    ball.center = CGPointMake(self.hView.width*0.5, 5);
    self.ball = ball;
    [self.hView addSubview:ball];

}

-(void)setRefresh{

    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    ;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    header.frame =CGRectMake(0, 0, 50, 50);
    
    // 设置文字
    [header setTitle:@"下拉同步数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始同步" forState:MJRefreshStatePulling];
    [header setTitle:@"同步数据％%0" forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    
    self.tabView.mj_header =header;
    
}

// 下拉刷新调用的方法

-(void)pullRefresh{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.hView.alpha = 0.5;
        self.inside.alpha = 0.0;
    }];
    
    // 小球滚动
    [UIView animateWithDuration:0 animations:^{
        CAKeyframeAnimation*frameAnim=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        frameAnim.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.hView.size.width*0.5, self.hView.size.height*0.5) radius:(([UIScreen mainScreen].bounds.size.height*3.1/5-100)-10)/2 startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:YES].CGPath;
        frameAnim.duration = 1.5;
        frameAnim.removedOnCompletion = NO;
        
        
        [self.ball.layer addAnimation:frameAnim forKey:@"anim"];
    }completion:^(BOOL finished) {
        
        [NSThread sleepForTimeInterval:1.5];
        
        [self.tabView.mj_header endRefreshing];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.hView.alpha = 0.5;
            self.inside.alpha = 0.5;
        }];
    }];
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
