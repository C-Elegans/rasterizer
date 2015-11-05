//
//  ViewController.m
//  image playground
//
//  Created by Michael Nolan on 11/4/15.
//  Copyright © 2015 Michael Nolan. All rights reserved.
//

#import "ViewController.h"
#include <xmmintrin.h>
#include <tmmintrin.h>
#include <smmintrin.h>
@implementation ViewController
void modifyImage(unsigned char* data, size_t size);
- (void)viewDidLoad {
	[super viewDidLoad];
	long start_time,stop_time;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
	self.image = [[NSImage alloc] initWithContentsOfFile:imagePath];
	NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithData:[self.image TIFFRepresentation]];
	NSLog(@"width: %ld, height: %ld",(long)[imageRep pixelsHigh],[imageRep pixelsWide]);
	size_t size = [imageRep pixelsHigh] * [imageRep pixelsWide]* ([imageRep bitsPerPixel]/8);
	
	start_time = mach_absolute_time();
	modifyImage([imageRep bitmapData],size);
	stop_time = mach_absolute_time();
	long elapsed = stop_time-start_time;
	mach_timebase_info_data_t info;
	mach_timebase_info(&info);
	double nanoseconds = (double)elapsed * (double)info.numer/(double)info.denom;
	NSLog(@"Time to convert %f",nanoseconds/1e6);
	self.image = [[NSImage alloc] initWithCGImage:[imageRep CGImage] size:[imageRep size]];
	// Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
	
	// Update the view, if already loaded.
}
void modifyImage(unsigned char* data, size_t size){
	__m128i* ssePointer = (__m128i*) data;
	__m128i redMult = _mm_set1_epi16(77);
	__m128i greenMult = _mm_set1_epi16(151);
	__m128i blueMult = _mm_set1_epi16(28);
	__m128i zero = _mm_setzero_si128();
	__m128i mask = _mm_setr_epi8(0x00,0x04,0x08,0x0c, 0x01,0x05,0x09,0x0d, 0x02,0x06,0x0a,0x0e, 0x03,0x07,0x0b,0x0f);
	for(int i=0;i<size;i+=32){
		__m128i red = _mm_shuffle_epi8(_mm_load_si128(ssePointer),mask);
		__m128i green = _mm_shuffle_epi8(_mm_load_si128(ssePointer+1),mask);
		__m128i blue = _mm_shuffle_epi8(_mm_load_si128(ssePointer+2),mask);
		__m128i alpha = _mm_shuffle_epi8(_mm_load_si128(ssePointer+3),mask);
		_MM_TRANSPOSE4_PS(red, green, blue, alpha);
		
		__m128i red_high = _mm_unpackhi_epi8(red, zero);
		__m128i red_lo = _mm_unpacklo_epi8(red, zero);
		red_high = _mm_srli_epi16(_mm_mullo_epi16(red_high, redMult),8);
		red_lo = _mm_srli_epi16(_mm_mullo_epi16(red_lo, redMult),8);
		red = _mm_packus_epi16(red_lo, red_high);
		__m128i green_high = _mm_unpackhi_epi8(green, zero);
		__m128i green_lo = _mm_unpacklo_epi8(green, zero);
		green_high = _mm_srli_epi16(_mm_mullo_epi16(green_high, greenMult),8);
		green_lo = _mm_srli_epi16(_mm_mullo_epi16(green_lo, greenMult),8);
		green = _mm_packus_epi16(green_lo, green_high);
		__m128i blue_high = _mm_unpackhi_epi8(blue, zero);
		__m128i blue_lo = _mm_unpacklo_epi8(blue, zero);
		blue_high = _mm_srli_epi16(_mm_mullo_epi16(blue_high, blueMult),8);
		blue_lo = _mm_srli_epi16(_mm_mullo_epi16(blue_lo, blueMult),8);
		blue = _mm_packus_epi16(blue_lo, blue_high);
		red =blue = green= _mm_add_epi8(_mm_add_epi8(red, green),blue);
		_MM_TRANSPOSE4_PS(red, green, blue, alpha);
		red = _mm_shuffle_epi8(red, mask);
		_mm_store_si128(ssePointer, red);
		_mm_store_si128(ssePointer+1, _mm_shuffle_epi8(green, mask));
		_mm_store_si128(ssePointer+2, _mm_shuffle_epi8(blue, mask));
		_mm_store_si128(ssePointer+3, _mm_shuffle_epi8(alpha, mask));
		ssePointer += 4;
	}
}

@end
