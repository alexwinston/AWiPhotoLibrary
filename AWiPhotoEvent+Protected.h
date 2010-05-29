//
//  AWiPhotoEvent+Protected.h
//  AWiPhotoLibrary
//
//  Created by Alex Winston on 4/18/10.
//  Copyright 2010 ComFrame Software Corporation. All rights reserved.
//

#import "AWiPhotoEvent.h"
#import "AWiPhotoDocument.h"


@interface AWiPhotoEvent (Protected)
- (void)addDocument:(AWiPhotoDocument *)aDocument;
@end
