//
//  FileManageClass.m
//  FileShow
//
//  Created by 杨鑫 on 2016/12/22.
//  Copyright © 2016年 Shanxi shaodianbao network technology co.,LTD. All rights reserved.
//

#import "FileManageClass.h"


@interface FileManageClass ()


@end

@implementation FileManageClass

-(id)init {
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)defaultInstance {
    static FileManageClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FileManageClass alloc] init];
    });
    return sharedInstance;
}


+(NSMutableArray *)getImage {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;//图片大小加载模式
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//请求选项设置
    options.synchronous = YES;//是否同步加载
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<assets.count; i ++) {
        [[PHCachingImageManager defaultManager] requestImageForAsset:assets[i] targetSize:CGSizeMake(assets[i].pixelWidth ,assets[i].pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@",result);
            [array addObject:result];
        }];
    }
    return  array;
}
+(PHFetchResult<PHAsset *> *)getAllImageFetchResult {
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    return assets;
}

+(PHFetchResult<PHAsset *> *)getAllVideoFetchResult {
    PHFetchResult<PHAsset *> *assetsResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    return assetsResult;
}


+(NSMutableArray *)getVideo {
    NSMutableArray *array = [NSMutableArray array];
    PHFetchResult<PHAsset *> *assetsResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    options2.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    for (PHAsset *a in assetsResult) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:a options:options2 resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSLog(@"%@",info);
            NSLog(@"%@",audioMix);
            NSLog(@"%@",((AVURLAsset*)asset).URL);//asset为AVURLAsset类型 可直接获取相应视频的绝对地址
        }];
    }
    return array;
}
+(NSMutableArray *)getAllSystemPhotoAlbum {
    PHFetchResult*customUserCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (PHAssetCollection *collection in customUserCollections) {
        [array addObject:collection];
    }
    return array;
}
+(NSMutableArray *)getAllPersonPhotoAlbum {
    PHFetchResult*customUserCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (PHAssetCollection *collection in customUserCollections) {
        [array addObject:collection];
    }
    return array;
}

+(NSMutableArray *)getImagesWithPhotoAlbum:(PHAssetCollection *)collection {
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (PHAsset *asset in result) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;//图片大小加载模式
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//请求选项设置
        options.synchronous = YES;//是否同步加载
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth ,asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [array addObject:result];
         }];
    }
    return array;
}

-(void)saveImageToSystemPhotoAlbumWithImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{    if (error) {
  
    } else {

    }
}

-(void)saveImageToPersonPhotoAlbumWithImage:(UIImage *) image WithPhotoAlbum:(PHAssetCollection *)collection {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        NSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册(用户当初点击了"好")
        [self saveImageWithImage: image WithPhotoAlbum:collection];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
       // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
          [self saveImageWithImage: image WithPhotoAlbum:collection];
            }
        }];
    }
    
}
-(void)saveImageWithImage:(UIImage *) image WithPhotoAlbum:(PHAssetCollection *)collection {
__block NSString *assetLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            NSLog(@"保存图片失败!");
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = collection;
        if (createdAssetCollection == nil) {
            NSLog(@"查找相簿失败!");
            return;
        }

        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                NSLog(@"保存成功");
            } else {
                NSLog(@"保存失败");
            }
        }];
    }];
}
+(PHAssetCollection *)getPHAassetCollectionWithTitle:(NSString *)title {
    NSError *error = nil;
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) return nil;
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}


+(void)deletePhotoWithPHAsset:(PHAsset *)asset {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[asset]];
    } completionHandler:^(BOOL success, NSError *error) {
//        NSLog(@"Error: %@", error);
    }];
}

@end
