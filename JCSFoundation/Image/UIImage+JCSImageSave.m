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

#import "UIImage+JCSImageSave.h"
#import "JCSLogger/JCSLogger.h"

@implementation UIImage (JCSImageSave)

- (void)savePNGToFile:(NSString *)path {
    NSData *data = UIImagePNGRepresentation(self);
    [self writeData:data toPath:path];
}

- (void)saveJPEGToFile:(NSString *)path {
    NSData *data = UIImageJPEGRepresentation(self, 0.8);
    [self writeData:data toPath:path];
}

- (void)writeData:(NSData *)data toPath:(NSString *)path {
    NSError *saveError = nil;
    [data writeToFile:path options:nil error:&saveError];
    if (saveError) {
        CoreLogVerbose(@"Error saving image to %@: %@", path, saveError);
    }
}


@end
