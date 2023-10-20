//
//  ImageProcessor.h
//  OpenDemo
//
//  Created by 夜猫子 on 2023/10/18.
//

typedef enum {
    CardTypeIdentificationCard = 0, //身份证
    CardTypeSocialSecurityCard = 1, //社保卡
} CardType; //BLE連接狀態



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageProcessor : NSObject

@property(nonatomic,assign)CardType type;//读取卡片类型

//截取照片
- (UIImage *)processIDCardImage:(UIImage *)inputImage;


@end


