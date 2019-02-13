//
//  CameraModuleManager.m
//  SampleProjectCamera
//
//  Created by Gabriel on 11/02/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "React/RCTViewManager.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(CameraModuleManager,RCTViewManager)

    RCT_EXPORT_VIEW_PROPERTY(width, NSNumber)
    RCT_EXPORT_VIEW_PROPERTY(height, NSNumber)

    RCT_EXPORT_VIEW_PROPERTY(image, NSString)
    RCT_EXTERN_METHOD(onCameraTakePhoto:(nonnull NSNumber *)node)
    RCT_EXPORT_VIEW_PROPERTY(onImageReturn, RCTDirectEventBlock)

    //RCT_EXTERN_METHOD( testEvent:(NSString *)eventName )
    /*
    RCT_EXPORT_VIEW_PROPERTY(onUpdate, RCTDirectEventBlock)
    */
    /*
    RCT_EXTERN_METHOD(callbackMethod:(RCTResponseSenderBlock)callback)
    */
@end
