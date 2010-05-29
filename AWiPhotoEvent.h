//
//  AWiPhotoEvent.h
//  AWiPhotoController
//
//  Created by Alex Winston on 4/11/10.
//  Copyright 2010 Alex Winston. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AWiPhotoEvent : NSObject {
	NSString *_id;
	NSString *_name;
	NSString *_comment;
	NSMutableArray *_documents;
	NSDate *_startDate;
	NSDate *_endDate;
}
@property (copy) NSString *id;
@property (copy) NSString *name;
@property (copy) NSString *comment;
@property (nonatomic, retain) NSArray *documents;
- (NSDate *)startDate;
- (NSDate *)endDate;
@end
