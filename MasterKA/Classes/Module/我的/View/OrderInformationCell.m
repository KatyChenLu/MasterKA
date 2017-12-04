//
//  OrderInformationCell.m
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "OrderInformationCell.h"


@implementation OrderInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.recivePeoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recivePeo.mas_centerY);
        make.left.equalTo(self.recivePeo.mas_right).with.offset(28);
        make.right.equalTo(self).with.offset(-8);
        make.height.mas_equalTo(20);
    }];
// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareView :(NSDictionary *)orderInfo{
    NSMutableDictionary *qrInfo =[NSMutableDictionary dictionary];
    if([orderInfo[@"zf_type"] intValue] ==0){
        self.price.text=[NSString stringWithFormat:@"%@ M点",orderInfo[@"m_price"]];
    }else{
        self.price.text=![orderInfo[@"cardTitle"] isEqual:@""]?[NSString stringWithFormat:@"%@抵扣,实付:￥%@",orderInfo[@"cardTitle"],orderInfo[@"each_price"]]:[NSString stringWithFormat:@"￥%@",orderInfo[@"each_price"]];
    }
    
    self.thisOrderId.text=orderInfo[@"order_id"];
    if(orderInfo[@"receiver_address"] ==nil||orderInfo[@"receiver_name"]==nil||[orderInfo[@"receiver_address"] isEqual:@""]||[orderInfo[@"receiver_name"] isEqual:@""])
    {
        self.reciveAddrData.hidden = YES;
        self.reciveAddr.hidden = YES;
        self.recivePeoData.hidden = YES;
        self.recivePeo.hidden = YES;

        [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.specName.mas_bottom).with.offset(20);
            make.left.equalTo(self.classAddr.mas_right).with.offset(20);
            make.right.equalTo(self).with.offset(-12);
            make.height.mas_equalTo([self getaddressHeght:orderInfo[@"address"]]);
            make.bottom.equalTo(self.refuseOrder.mas_top).with.offset(-18);
        }];
    }
    else{
        self.reciveAddrData.hidden = NO;
        self.reciveAddr.hidden = NO;
        self.recivePeoData.hidden = NO;
        self.recivePeo.hidden = NO;
        self.recivePeoData.text = orderInfo[@"receiver_name"];
        self.reciveAddrData.text = orderInfo[@"receiver_address"];
        
        [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.specName.mas_bottom).with.offset(20);
            make.left.equalTo(self.classAddr.mas_right).with.offset(20);
            make.right.equalTo(self).with.offset(-12);
            make.height.mas_equalTo([self getaddressHeght:orderInfo[@"address"]]);
        }];
        
                [self.recivePeo mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.address.mas_bottom).with.offset(20);
                    make.left.equalTo(self).with.offset(12);
                    make.height.mas_equalTo(18);
                    make.width.mas_equalTo(60);
                }];
        
        [self.recivePeoData mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.address.mas_bottom).with.offset(20);
            make.left.equalTo(self.recivePeo.mas_right).with.offset(20);
            make.right.equalTo(self).with.offset(-12);
            make.height.mas_equalTo(18);
        }];
        
        
        [self.reciveAddr mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recivePeo.mas_bottom).with.offset(20);
            make.left.equalTo(self).with.offset(12);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        [self.reciveAddrData mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recivePeoData.mas_bottom).with.offset(20);
            make.left.equalTo(self.reciveAddr.mas_right).with.offset(12);
            make.right.equalTo(self).with.offset(-12);
            make.height.mas_equalTo([self getaddressHeght:orderInfo[@"receiver_address"]]);
            make.bottom.equalTo(self.refuseOrder.mas_top).with.offset(-18);
        }];
    }
    self.code.text=orderInfo[@"code"];
    if (orderInfo[@"code"]) {
        [qrInfo setObject:orderInfo[@"code"] forKey:@"code"];
    }
    [qrInfo setObject:[UserClient sharedUserClient].userId forKey:@"id"];
    [qrInfo setObject:orderInfo[@"oid"] forKey:@"oid"];
    
    [self erweima:[self getQRString:qrInfo]];
    self.classTime.text=orderInfo[@"show_start_date"];
    self.specName.text=orderInfo[@"specName"];
    self.address.text=orderInfo[@"address"];
    [self checkStatus:[orderInfo[@"order_status"] integerValue]];
}

-(CGFloat)getaddressHeght:(NSString*)str{

    CGSize textSize = [str sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    
    CGFloat singleWth = textSize.width;
//    CGFloat singleht = textSize.height;
    CGFloat contentwidth = [UIScreen mainScreen].bounds.size.width-104;
    int lines = singleWth/contentwidth;
    CGFloat hh = (lines+1)*21;
    return hh;

}





-(void)erweima:(NSString *)str
{
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    self.QR_Code.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:151.0];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}
- (NSString*)getQRString:(id)dataInfo{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString encryptWithText];
}
-(void)checkStatus:(NSInteger)status{
    
    
    switch (status) {
        case 1:
            self.QR_Code.alpha=0.2;
            self.QRstatus.image=[UIImage imageNamed:@"yishiyong"];

            break;
        case 2:
            self.QR_Code.alpha=0.2;
            self.QRstatus.image=[UIImage imageNamed:@"yiguoqi"];
            break;
        case 3:
            self.QR_Code.alpha=0.2;
            self.QRstatus.image=[UIImage imageNamed:@"yizuofei"];
            break;
        case 4:
            
            self.QR_Code.alpha=0.2;
            self.QRstatus.image=[UIImage imageNamed:@"daijiedan"];
            break;
        case 5:
            self.QR_Code.alpha=0.2;
            self.QRstatus.image=[UIImage imageNamed:@"yijudan"];
            break;
            default:
            break;
    }
}

@end
