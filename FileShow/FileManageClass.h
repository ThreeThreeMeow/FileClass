//
//  FileManageClass.h
//  FileShow
//
//  Created by 杨鑫 on 2016/12/22.
//  Copyright © 2016年 Shanxi shaodianbao network technology co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface FileManageClass : NSObject

+ (instancetype)defaultInstance;//单例
+(NSMutableArray *)getImage;//获取所有图片
+(NSMutableArray *)getVideo;//获取所有视频
+(NSMutableArray *)getAllSystemPhotoAlbum;//获取所有系统相册
+(NSMutableArray *)getAllPersonPhotoAlbum;//获取所有用户相册
+(PHAssetCollection *)getPHAassetCollectionWithTitle:(NSString *)title;//创建相册
+(NSMutableArray *)getImagesWithPhotoAlbum:(PHAssetCollection *)collection ;//获取某一个相册中的所有照片
-(void)saveImageToPersonPhotoAlbumWithImage:(UIImage *) image WithPhotoAlbum:(PHAssetCollection *)collection;//保存图片到某个相册
-(void)saveImageToSystemPhotoAlbumWithImage:(UIImage *)image;//保存图片到系统相册
+(PHFetchResult<PHAsset *> *)getAllImageFetchResult;//全部的图片对象
+(PHFetchResult<PHAsset *> *)getAllVideoFetchResult;//全部的视频对象
+(void)deletePhotoWithPHAsset:(PHAsset *)asset;//删除照片

@end
