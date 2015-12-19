//
//  Bitmap+ImageCreating.m
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-19.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

#import "Bitmap+ImageCreating.h"

@implementation Bitmap (ImageCreating)

- (UIImage *)image
{
    return [UIImage imageWithCGImage:CGBitmapContextCreateImage(self.graphicsContext)];
}

@end
