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

#import <AVFoundation/AVFoundation.h>
#import "JCSCameraCapture.h"
#import "JCSFoundationConstants.h"

@interface JCSCameraCapture ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

@end

@implementation JCSCameraCapture

- (void)startSession {
    [self.session startRunning];
}

- (void)stopSession {
    [self.session stopRunning];
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    return captureVideoPreviewLayer;
}

- (void)setUp {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    [self setSession:captureSession];

    [self configureSessionForDevice:AVCaptureDevicePositionBack];

    AVCaptureStillImageOutput *output = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [output setOutputSettings:outputSettings];

    [self setImageOutput:output];
    [self.session addOutput:output];
}

- (void)captureImageWithCompletionHandler:(JCSCameraCaptureBlock)completion {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }

    NSLog(@"Capture device %d - %d", self.device.position, self.device.isAdjustingFocus);
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
            ^(CMSampleBufferRef sampleBuffer, NSError *error) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
                JCSFLog(@"Image data size %d", [imageData length]);

                NSURL *libraryFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
                libraryFolder = [libraryFolder URLByAppendingPathComponent:@"JCSFoundation" isDirectory:YES];
                libraryFolder = [libraryFolder URLByAppendingPathComponent:@"JCSCameraCapture" isDirectory:YES];

                NSError *createFolderError = nil;
                [[NSFileManager defaultManager] createDirectoryAtURL:libraryFolder withIntermediateDirectories:YES attributes:nil error:&createFolderError];
                if (createFolderError) {
                    JCSFLog(@"Create folder error:%@", createFolderError);
                }


                NSURL *photoPath = [libraryFolder URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [[NSProcessInfo processInfo] globallyUniqueString]]];
                NSError *fileWriteError = nil;
                [imageData writeToURL:photoPath options:NSDataWritingAtomic error:&fileWriteError];
                if (fileWriteError) {
                    JCSFLog(@"File write error:%@", fileWriteError);
                }

                completion(photoPath);
            }];
}


- (void)configureSessionForDevice:(AVCaptureDevicePosition)position {
    [self.session beginConfiguration];

    NSArray *existingInputs = [self.session inputs];
    for (AVCaptureInput *input in existingInputs) {
        [self.session removeInput:input];
    }

    AVCaptureDevice *camera = nil;
    NSArray *captureDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in captureDevices) {
        if (device.position != position) {
            continue;
        }

        camera = device;
    }

    if (!camera) {
        //TODO jaanus: error callback?
        JCSFLog(@"No device created");
        return;
    }

    [self setDevice:camera];

    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    if (error) {
        NSLog(@"Error:%@", error);
        //TODO jaanus: error callback?
        JCSFLog(@"Input device not created:%@", error);
        return;
    }

    [self.session addInput:input];

    [self.session commitConfiguration];
}

@end
