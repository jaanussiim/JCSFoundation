/*
 * Copyright 2013 JaanusSiim
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "JCSPhotoCaptureView.h"
#import "JCSCameraCapture.h"
#import "JCSFoundationConstants.h"

@interface JCSPhotoCaptureView ()

@property (nonatomic, strong) JCSCameraCapture *cameraCapture;

@end

@implementation JCSPhotoCaptureView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)startPreview {
  JCSFLog(@"startPreview");
  if (!self.cameraCapture) {
    [self createCameraCapture];
  }

  AVCaptureVideoPreviewLayer *previewLayer = [self.cameraCapture previewLayer];
  [previewLayer setFrame:self.bounds];
  [self.layer addSublayer:previewLayer];

  [self.cameraCapture startSession];
}

- (void)stopPreview {
  [self.cameraCapture stopSession];
}

- (void)captureImageWithCompletionHandler:(JCSPhotoCaptureBlock)completionHandler {
  [self.cameraCapture captureImageWithCompletionHandler:^(NSURL *pathToCapturedImage) {
    completionHandler(pathToCapturedImage);
  }];
}

- (void)createCameraCapture {
  JCSCameraCapture *capture = [[JCSCameraCapture alloc] init];
  [capture setUp];
  [self setCameraCapture:capture];
}

@end
