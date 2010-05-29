//
//  AWiPhotoEvent+Protected.m
//  AWiPhotoLibrary
//
//  Created by Alex Winston on 4/18/10.
//  Copyright 2010 ComFrame Software Corporation. All rights reserved.
//

#import "AWiPhotoEvent+Protected.h"


@implementation AWiPhotoEvent (Protected)

- (void)addDocument:(AWiPhotoDocument *)aDocument {
	if (!_startDate || [_startDate isGreaterThan:aDocument.createdDate])
		_startDate = [[aDocument.createdDate copy] retain];
	if (!_endDate || [_endDate isLessThan:aDocument.createdDate])
		_endDate = [[aDocument.createdDate copy] retain];
	
	[_documents addObject:aDocument];
}

@end
