//
//  UIImagePickerController+Edit.m
//  DZNPhotoPickerController
//  https://github.com/dzenbot/DZNPhotoPickerController
//
//  Created by Ignacio Romero Zurbuchen on 1/2/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIImagePickerController+Edit.h"

static DZNPhotoPickerControllerCropMode _editingMode;

@implementation UIImagePickerController (Edit)

- (void)setEditingMode:(DZNPhotoPickerControllerCropMode)mode
{
    _editingMode = mode;
    self.allowsEditing = NO;

    switch (mode) {
        case DZNPhotoPickerControllerCropModeNone:
            [[NSNotificationCenter defaultCenter] removeObserver:self name:DZNPhotoPickerDidFinishPickingNotification object:nil];
            break;
            
        default:
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPickImage:) name:DZNPhotoPickerDidFinishPickingNotification object:nil];
            break;
    }
}

- (DZNPhotoPickerControllerCropMode)editingMode
{
    return _editingMode;
}

- (void)didPickImage:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]){
        
        if ([[notification.userInfo allKeys] containsObject:UIImagePickerControllerEditedImage]) {
            self.editingMode = DZNPhotoPickerControllerCropModeNone;
        }
        
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:notification.userInfo];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DZNPhotoPickerDidFinishPickingNotification object:nil];
    }
}

@end