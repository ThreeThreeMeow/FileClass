//
//  ViewController.m
//  FileShow
//
//  Created by 光小星 on 2016/12/22.
//  Copyright © 2016年 Shanxi shaodianbao network technology co.,LTD. All rights reserved.
//

#import "ViewController.h"
#import "FileManageClass.h"

@interface ViewController ()

@property (nonatomic,strong)NSMutableArray *videoArray;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *textArray;
@property (nonatomic,strong)NSMutableArray *groupArray;

@end

@implementation ViewController

-(NSMutableArray *)textArray {
    if (_textArray == nil) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}
-(NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(NSMutableArray *)videoArray {
    if (_videoArray == nil) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
-(NSMutableArray *)groupArray {
    if (_groupArray == nil) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}





@end
