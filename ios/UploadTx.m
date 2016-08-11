//
//  uploadImage.m
//  XS6
//
//  Created by 孙峰 on 16/6/29.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "UploadTx.h"
#import "RCTConvert.h"
#import "RCTUtils.h"
#import "TXYUploadManager.h"
#define  SIGN_URL @"http://203.195.194.28/php/getsignv2.php"

@interface UploadTx ()
{
  NSString *appId;
  NSString *persistenceId;
  NSString *bucket;
  TXYPhotoUploadTaskRsp *photoResp;
  
  UIImageView *imageV;
  UILabel *imgUrl;
  UILabel *imgFileID;
}
@property (nonatomic,strong) TXYUploadManager *uploadImageManager;
@property (nonatomic,strong) TXYPhotoUploadTask *uploadPhotoTask;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *oneSign;
@property NSString *ok;

@end

@implementation UploadTx
RCT_EXPORT_MODULE(TxUploadIOS);



RCT_EXPORT_METHOD(uploadImg:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback)
{
  
  appId = options[@"appId"];//10000002//
  bucket = options[@"bucket"];//test2p//
 
  
  persistenceId = @"sunfeng";//自定义,唯一,没有限制persistenceId
  _uploadImageManager = [[TXYUploadManager alloc] initWithCloudType:TXYCloudTypeForImage
                                                      persistenceId:persistenceId
                                                              appId:appId];//上传图片
  

  _uploadPhotoTask = [[TXYPhotoUploadTask alloc] initWithPath:options[@"path"]                                                                       sign:options[@"sign"]
                                                            bucket:bucket
                                                       expiredDate:0
                                                        msgContext:@"服务器透穿信息"
                                                            fileId:nil];
  


  [_uploadImageManager upload:_uploadPhotoTask
                     complete:^(TXYTaskRsp *resp, NSDictionary *context) {
                       
                       photoResp = (TXYPhotoUploadTaskRsp *)resp;
                       
                       //NSLog(@"上传图片的url =%@ 上传图片的fileid = %@",photoResp.photoURL,photoResp.photoFileId);
                       if (photoResp.retCode>=0) {
                          NSDictionary *dct=@{@"status":@1,@"url":photoResp.photoURL,@"fileid":photoResp.photoFileId};
                          callback(@[[NSNull null],dct ]);
                       } else {
                         int errCode=photoResp.retCode;
                         NSDictionary *dct=@{@"status":@0,@"errCode":@(errCode)};
                         callback(@[[NSNull null],dct]);
                       }
                       
                       //NSLog(@"upload return=%d",photoResp.retCode);
                       
                     }
                     progress:^(int64_t totalSize, int64_t sendSize, NSDictionary *context) {
                       //命中妙传，不走这里的！
                       NSLog(@" totalSize %lld",totalSize);
                       NSLog(@" sendSize %lld",sendSize);
                       NSLog(@" sendSize %@",context);
                       
                     }
                  stateChange:^(TXYUploadTaskState state, NSDictionary *context) {
                    //NSLog(@"%ld lalalalaalla",(long)state);
                    switch (state) {
                      case TXYUploadTaskStateWait:
                        NSLog(@"任务等待中");
                        break;
                      case TXYUploadTaskStateConnecting:
                        NSLog(@"任务连接中");
                        break;
                      case TXYUploadTaskStateFail:
                        NSLog(@"任务失败");
                        break;
                      case TXYUploadTaskStateSuccess:
                        NSLog(@"任务成功");
                        break;
                      default:
                        break;
                    }}];
}

RCT_EXPORT_METHOD(uploadFile:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback)
{
  
  
  
  
  persistenceId = @"sunfeng1";//自定义,唯一,没有限制persistenceId
  _uploadImageManager = [[TXYUploadManager alloc] initWithCloudType:TXYCloudTypeForFile
                                                      persistenceId:persistenceId
                                                              appId:options[@"appId"]];//上传图片
  
  
  NSString *dir =[NSString stringWithFormat:@"/"];
  
  //上传文件总共五步之     第四步: 初始化上传任务task
  TXYFileUploadTask *fileTask =[[TXYFileUploadTask alloc] initWithPath:options[@"path"]
                                                                  sign:options[@"sign"]
                                                                bucket:options[@"bucket"]
                                                       customAttribute:nil
                                                       uploadDirectory:dir
                                                            msgContext:nil];
  
  
  
  [_uploadImageManager upload:fileTask
                     complete:^(TXYTaskRsp *resp, NSDictionary *context) {
                       
                       TXYFileUploadTaskRsp *fileResp = (TXYFileUploadTaskRsp *)resp;
                       
//                       if (fileResp.retCode >= 0) {
//                         NSLog(@"fileResp.fileURL = %@",fileResp.fileURL);
//                         //
//                         
//                         imgUrl.text =fileResp.fileURL;
//                       
//                       } else {
//                         
//                         NSLog(@"%@",[NSString stringWithFormat:@"错误码:%d,描述:%@",fileResp.retCode,fileResp.descMsg]);
//                       }
                       if (fileResp.retCode>=0) {
                         NSDictionary *dct=@{@"status":@1,@"url":fileResp.fileURL};
                         callback(@[[NSNull null],dct ]);
                       } else {
                         int errCode=fileResp.retCode;
                         NSDictionary *dct=@{@"status":@0,@"errCode":@(errCode),@"msg":fileResp.descMsg};
                         callback(@[[NSNull null],dct]);
                       }
                       
                     }
                     progress:^(int64_t totalSize, int64_t sendSize, NSDictionary *context) {
                       //命中妙传，不走这里的！
                       NSLog(@" totalSize %lld",totalSize);
                       NSLog(@" sendSize %lld",sendSize);
                       NSLog(@" sendSize %@",context);
                       
                     }
                  stateChange:^(TXYUploadTaskState state, NSDictionary *context) {
                    
                    switch (state) {
                      case TXYUploadTaskStateWait:
                        NSLog(@"任务等待中");
                        break;
                      case TXYUploadTaskStateConnecting:
                        NSLog(@"任务连接中");
                        break;
                      case TXYUploadTaskStateFail:
                        NSLog(@"任务失败");
                        break;
                      case TXYUploadTaskStateSuccess:
                        NSLog(@"任务成功");
                        break;
                      default:
                        break;
                    }}];
}

@end
