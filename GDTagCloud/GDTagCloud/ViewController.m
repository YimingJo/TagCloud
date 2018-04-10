//
//  ViewController.m
//  GDTagCloud
//
//  Created by linekong on 2018/4/10.
//

#import "ViewController.h"
#import "GDTagCloudView.h"
@interface ViewController ()
@property (nonatomic, strong) GDTagCloudView *tagCloudView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagCloudView = [[GDTagCloudView alloc] initWithFrame:CGRectMake(50, 90, 200, 200)];
    [self.view addSubview:self.tagCloudView];
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < 100; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        label.text = [NSString stringWithFormat:@"%ld",i];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [mutArray addObject:label];
        [self.tagCloudView addSubview:label];
    }
    [self.tagCloudView setCloudTags:mutArray];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
