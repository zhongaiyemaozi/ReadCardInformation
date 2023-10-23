//
//  ViewController.m
//  OpenDemo
//
//  Created by 夜猫子 on 2023/10/18.
//

#import "ViewController.h"
#import "ImageProcessor.h"



@interface ViewController ()


@property(nonatomic,strong)ImageProcessor *imageProcessor;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *SocialImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end


#define IdentificationCardimaheName @"hsenfenzhengTemp.jpg" //平行的身份证
#define SocialSecurityCardImaheName @"WechatIMG22150.jpg" //社保卡平行身份证

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:IdentificationCardimaheName];
    self.SocialImageView.image = [UIImage imageNamed:SocialSecurityCardImaheName];
}




- (IBAction)btnOne:(UIButton *)sender {
    
    
    NSLog(@"点击了身份证读取");
    
    [UserInfoModel getUserInfoModelWithImage:[UIImage imageNamed:IdentificationCardimaheName] withCardType:CardTypeIdentificationCard completion:^(UserInfoModel * model) {
        
        if(model) {
            NSLog(@" \n姓名= %@ \n身份证号码 = %@ \n生日 = %@ \n性别 = %@ \n原数据 = %@",model.userName,model.identificationCard,model.birthday,model.gender,model.rawData);
        } else {
            NSLog(@"身份证读取失败");
        }
        
    }];
    
    
    
    
}


- (IBAction)btnTwo:(UIButton *)sender {
    
    NSLog(@"点击了截取图片");
    
    UIImage *image = [self.imageProcessor processIDCardImage:[UIImage imageNamed:IdentificationCardimaheName] withCardType:CardTypeIdentificationCard];
    
    if (image) {
        self.imageView.image = image;
    } else {
        NSLog(@"身份证截取图片失败");
    }
    
    UIImage *Socialimage = [self.imageProcessor processIDCardImage:[UIImage imageNamed:SocialSecurityCardImaheName] withCardType:CardTypeSocialSecurityCard];
    
    if (Socialimage) {
        self.SocialImageView.image = Socialimage;
    } else {
        NSLog(@"社保卡截取图片失败");
    }
    
}

- (IBAction)btnThree:(UIButton *)sender {
    
    NSLog(@"点击了社保卡识别");
    [UserInfoModel getUserInfoModelWithImage:[UIImage imageNamed:SocialSecurityCardImaheName] withCardType:CardTypeSocialSecurityCard completion:^(UserInfoModel * model) {
        
        if(model) {
            NSLog(@" \n姓名= %@ \n身份证号码 = %@ \n生日 = %@ \n性别 = %@ \n原数据 = %@",model.userName,model.identificationCard,model.birthday,model.gender,model.rawData);
        } else {
            NSLog(@"社保卡读取失败");
        }
        
    }];
    
    
}







- (ImageProcessor *)imageProcessor {
    if(!_imageProcessor) {
        _imageProcessor = [[ImageProcessor alloc] init];
    }
    return _imageProcessor;
}






@end
