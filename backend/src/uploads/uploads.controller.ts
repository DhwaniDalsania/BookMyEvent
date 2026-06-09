import { Controller, Post, UseInterceptors, UploadedFile, Get, Param, Res, BadRequestException } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { extname } from 'path';
import * as fs from 'fs';

// Bypass TypeScript declarations check for Multer by importing it dynamically
const { diskStorage } = require('multer');

@Controller('uploads')
export class UploadsController {
  @Post('image')
  @UseInterceptors(FileInterceptor('image', {
    storage: diskStorage({
      destination: (req: any, file: any, callback: any) => {
        const uploadPath = './uploads';
        if (!fs.existsSync(uploadPath)) {
          fs.mkdirSync(uploadPath, { recursive: true });
        }
        callback(null, uploadPath);
      },
      filename: (req: any, file: any, callback: any) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
        const ext = extname(file.originalname);
        callback(null, `${uniqueSuffix}${ext}`);
      }
    })
  }))
  uploadImage(@UploadedFile() file: any) {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }
    // Return a relative URL path that the frontend will prepend with ApiConstants.baseUrl
    return {
      imageUrl: `/uploads/${file.filename}`,
    };
  }

  @Get(':filename')
  serveFile(@Param('filename') filename: string, @Res() res: any) {
    return res.sendFile(filename, { root: './uploads' });
  }
}
