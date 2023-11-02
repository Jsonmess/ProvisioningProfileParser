//
//  ViewController.m
//  ProvisioningProfileParserDemo
//
//  Created by jsonmess on 2023/10/13.
//

#import "ViewController.h"
#import <ProvisioningProfileParser/ProvisioningProfile.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *provisionNameLabel;//描述文件名称
@property (weak, nonatomic) IBOutlet UILabel *teamLabel; //Team
@property (weak, nonatomic) IBOutlet UILabel *provisionExpiryLabel;//描述文件过期时间
@property (weak, nonatomic) IBOutlet UILabel *certificateCreateTimeLabel;//证书创建时间
@property (strong, nonatomic) ProvisioningProfileParser * parser;//解析器
@property(strong,nonatomic)NSDateFormatter *dateFormatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}

- (void)setUpView {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //根据解析provision文件 得到数据
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *name = @"embedded.mobileprovision";
    ProvisioningProfileParser * tmpParser = [[ProvisioningProfileParser alloc] init];
    self.parser = tmpParser;
    __weak typeof(self)weakSelf = self;
    [tmpParser fetchLocaProvisioningProfileWithBundle:bundle
                                             fileName:name
                                            completed:^(ProvisionProfileInfo *  profile, NSError *  error) {
        if (profile) {
            weakSelf.provisionNameLabel.text = profile.provisionName;
            weakSelf.teamLabel.text = profile.team;
            weakSelf.certificateCreateTimeLabel.text = [self.dateFormatter stringFromDate: profile.certificateCreateDate];
            weakSelf.provisionExpiryLabel.text = [self.dateFormatter stringFromDate: profile.provisionExpiryDate];
        }else {
            NSLog(@"遇到错误----：%@",error.domain);
        }
      
    }];
}
@end
