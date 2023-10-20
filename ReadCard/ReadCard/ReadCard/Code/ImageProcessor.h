//
//  ImageProcessor.h
//  OpenDemo
//
//  Created by 夜猫子 on 2023/10/18.
//


typedef enum {
    CardTypeIdentificationCard = 0, //身份证
    CardTypeSocialSecurityCard = 1, //社保卡
} CardType; //卡片类型


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserInfoModel.h"



@interface ImageProcessor : NSObject


//截取照片
- (UIImage *)processIDCardImage:(UIImage *)inputImage withCardType:(CardType)cardType;



@end


