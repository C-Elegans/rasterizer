//
//  newVec.hpp
//  image playground
//
//  Created by Michael Nolan on 2/23/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#ifndef newVec_hpp
#define newVec_hpp
#include <stdint.h>
#include "vector.hpp"
#include <immintrin.h>
#include <smmintrin.h>
#include <xmmintrin.h>
//
//  vec3f.h
//  APCSCpp
//
//  Created by Michael Nolan on 2/22/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//


/*struct vconstu
{
	union { uint32_t u[4]; __m128 v; };
	inline operator __m128() const { return v; }
};*/

//vconstu vsignbits = { 0x80000000, 0x80000000, 0x80000000, 0x80000000 };
typedef union {
	__m128 v;    // SSE 4 x float Vec
	float a[4];  // scalar array of 4 floats
} mm_to_float;


struct vec3f{
public:
	__m128i m;
	inline vec3f(){
		m = _mm_setzero_ps();
	}
	inline vec3f(float x, float y, float z){
		m = _mm_set_ps(z, z, y, x);
	}
	inline vec3f(float* f){
		m = _mm_set_ps(f[2], f[2], f[1], f[0]);
	}
	inline vec3f(__m128 mnew){
		m = mnew;
	}
	inline vec3f(vec3 v){
		m = _mm_set_ps(v.z,v.z,v.y,v.x);
	}
	inline vec3f vec3fi(int x, int y, int z){
		return vec3f((float)x, (float) y, (float) z);
	}
	inline float x(){
		return _mm_cvtss_f32(m);
	}
	inline float y(){
		return _mm_cvtss_f32(_mm_shuffle_ps(m, m, _MM_SHUFFLE(1, 1, 1, 1)));
	}
	inline float z(){
		return _mm_cvtss_f32(_mm_shuffle_ps(m, m, _MM_SHUFFLE(2, 2, 2, 2)));
	}
	inline vec3f yzx(){
		return _mm_shuffle_ps(m, m, _MM_SHUFFLE(1, 1, 2, 0));
	}
	inline vec3f zxy(){
		return _mm_shuffle_ps(m, m, _MM_SHUFFLE(2, 2, 0, 1));
	}
	inline void store(float* f){
		f[0] = x(); f[1] = y(); f[2] = z();
	}
	void setX(float x)
	{
	m = _mm_move_ss(m, _mm_set_ss(x));
	}
	void setY(float y)
	{
	__m128 t = _mm_move_ss(m, _mm_set_ss(y));
	t = _mm_shuffle_ps(t, t, _MM_SHUFFLE(3, 2, 0, 0));
	m = _mm_move_ss(t, m);
	}
	void setZ(float z)
	{
	__m128 t = _mm_move_ss(m, _mm_set_ss(z));
	t = _mm_shuffle_ps(t, t, _MM_SHUFFLE(3, 0, 1, 0));
	m = _mm_move_ss(t, m);
	}
	
	inline vec3f normalize(){
		__m128 b = _mm_dp_ps(m, m, 0x7f);
		return _mm_mul_ps(m, _mm_rsqrt_ps(b));
	}
	inline float length(){
		__m128 b = _mm_dp_ps(m, m, 0x7f);
		return _mm_cvtss_f32(_mm_sqrt_ps(b));
	}
	inline float operator[] (size_t i) const {
		mm_to_float mm;
		mm.v = m;
		return mm.a[i];
		
	};
	
	
};

typedef vec3f Vec3b;
inline vec3f operator+ (vec3f a, vec3f b){
	return _mm_add_ps(a.m, b.m);
}
inline vec3f operator- (vec3f a, vec3f b){
	return _mm_sub_ps(a.m, b.m);
}
inline vec3f operator* (vec3f a, vec3f b){
	return _mm_mul_ps(a.m, b.m);
}
inline vec3f operator/ (vec3f a, vec3f b){
#ifdef FAST_DIV
	return _mm_mul_ps(a.m, _mm_rcp_ps(b));
#else
	return _mm_div_ps(a.m, b.m);
#endif
}
inline vec3f operator* (vec3f a, float b){
	return _mm_mul_ps(a.m, _mm_set1_ps(b));
}
inline vec3f operator/ (vec3f a, float b){
#ifdef FAST_DIV
	return _mm_mul_ps(a, _mm_rcp_ps( _mm_set1_ps(b)))
#else
	return _mm_div_ps(a.m, _mm_set1_ps(b));
#endif
}
inline vec3f operator* (float a, vec3f b){
	return _mm_mul_ps(_mm_set1_ps(a), b.m);
}
inline vec3f operator/ (float a, vec3f b){
#ifdef FAST_DIV
	return _mm_mul_ps(_mm_set1_ps(a), _mm_rcp_ps(b.m));
#else
	return _mm_div_ps(_mm_set1_ps(a), b.m);
#endif
}
inline vec3f& operator+= (vec3f& a, vec3f b){
	a = a + b; return a;
}
inline vec3f& operator-= (vec3f& a, vec3f b){
	a = a - b; return a;
}
inline vec3f& operator*= (vec3f& a, vec3f b){
	a = a * b; return a;
}
inline vec3f& operator/= (vec3f& a, vec3f b){
	a = a / b; return a;
}
inline vec3f& operator*= (vec3f& a, float b){
	a = a * b; return a;
}
inline vec3f& operator/= (vec3f& a, float b){
	a = a / b; return a;
}
inline Vec3b operator== (vec3f a, vec3f b){
	return _mm_cmpeq_ps(a.m, b.m);
}
inline Vec3b operator!= (vec3f a, vec3f b){
	return _mm_cmpneq_ps(a.m, b.m);
}

inline Vec3b operator> (vec3f a, vec3f b){
	return _mm_cmpgt_ps(a.m, b.m);
}
inline Vec3b operator< (vec3f a, vec3f b){
	return _mm_cmplt_ps(a.m, b.m);
}
inline Vec3b operator>= (vec3f a, vec3f b){
	return _mm_cmpge_ps(a.m, b.m);
}
inline Vec3b operator<= (vec3f a, vec3f b){
	return _mm_cmple_ps(a.m, b.m);
}
inline vec3f min(vec3f a, vec3f b){
	return _mm_min_ps(a.m, b.m);
}
inline vec3f max(vec3f a, vec3f b){
	return _mm_max_ps(a.m, b.m);
}
inline vec3f operator- (vec3f a){
	return _mm_sub_ps(_mm_setzero_ps(), a.m);
}
//inline vec3f abs(vec3f a){
//return _mm_andnot_ps(vsignbits, a.m);
//}
inline vec3f cross(vec3f a, vec3f b){
	return vec3f(a.y()*b.z() - a.z()*b.y(), a.z()*b.x()-a.x()*b.z(), a.x()*b.y() - a.y()-b.x());
}
inline float dot(vec3f a, vec3f b){
	__m128 res = _mm_dp_ps(a.m, b.m, 0x7f);
	
	return _mm_cvtss_f32(res);
}
struct vec4f{
	
public:
	__m128i m;
	inline vec4f(float x, float y, float z,float w){
		m = _mm_set_ps(w, z, y, x);
	}
	inline vec4f(float* f){
		m = _mm_set_ps(f[3], f[2], f[1], f[0]);
	}
	inline vec4f(__m128 mnew){
		m = mnew;
	}
	inline vec4f(vec3f v){
		m = v.m;
		__m128 t = _mm_move_ss(m, _mm_set_ss(0));
		t = _mm_shuffle_ps(t, t, _MM_SHUFFLE(3, 0, 1, 0));
		m = _mm_move_ss(t, m);
	}
	inline vec4f vec4fi(int x, int y, int z, int w){
		return vec4f((float)x, (float) y, (float) z, (float) w);
	}
	inline float x(){
		return _mm_cvtss_f32(m);
	}
	inline float y(){
		return _mm_cvtss_f32(_mm_shuffle_ps(m, m, _MM_SHUFFLE(1, 1, 1, 1)));
	}
	inline float z(){
		return _mm_cvtss_f32(_mm_shuffle_ps(m, m, _MM_SHUFFLE(2, 2, 2, 2)));
	}
	inline float w(){
		return _mm_cvtss_f32(_mm_shuffle_ps(m, m, _MM_SHUFFLE(3, 3, 3, 3)));
	}
	
	inline void store(float* f){
		f[0] = x(); f[1] = y(); f[2] = z();
	}
	void setX(float x)
	{
	m = _mm_move_ss(m, _mm_set_ss(x));
	}
	void setY(float y)
	{
	__m128 t = _mm_move_ss(m, _mm_set_ss(y));
	t = _mm_shuffle_ps(t, t, _MM_SHUFFLE(3, 2, 0, 0));
	m = _mm_move_ss(t, m);
	}
	void setZ(float z)
	{
	__m128 t = _mm_move_ss(m, _mm_set_ss(z));
	t = _mm_shuffle_ps(t, t, _MM_SHUFFLE(3, 0, 1, 0));
	m = _mm_move_ss(t, m);
	}
	void setW(float w){
		__m128 t = _mm_move_ss(m, _mm_set_ss(w));
		t = _mm_shuffle_ps(t,t,_MM_SHUFFLE(0, 2, 1, 0));
		m = _mm_move_ss(t, m);
	}
	inline vec4f normalize(){
		__m128 b = _mm_dp_ps(m, m, 0xff);
		return _mm_mul_ps(m, _mm_rsqrt_ps(b));
	}
	inline float length(){
		__m128 b = _mm_dp_ps(m, m, 0xff);
		return _mm_cvtss_f32(_mm_sqrt_ps(b));
	}
	
};
typedef vec4f Vec4b;
inline vec4f operator+ (vec4f a, vec4f b){
	return _mm_add_ps(a.m, b.m);
}
inline vec4f operator- (vec4f a, vec4f b){
	return _mm_sub_ps(a.m, b.m);
}
inline vec4f operator* (vec4f a, vec4f b){
	return _mm_mul_ps(a.m, b.m);
}
inline vec4f operator/ (vec4f a, vec4f b){
#ifdef FAST_DIV
	return _mm_mul_ps(a.m, _mm_rcp_ps(b));
#else
	return _mm_div_ps(a.m, b.m);
#endif
}
inline vec4f operator* (vec4f a, float b){
	return _mm_mul_ps(a.m, _mm_set1_ps(b));
}
inline vec4f operator/ (vec4f a, float b){
#ifdef FAST_DIV
	return _mm_mul_ps(a, _mm_rcp_ps( _mm_set1_ps(b)))
#else
	return _mm_div_ps(a.m, _mm_set1_ps(b));
#endif
}
inline vec4f operator* (float a, vec4f b){
	return _mm_mul_ps(_mm_set1_ps(a), b.m);
}
inline vec4f operator/ (float a, vec4f b){
#ifdef FAST_DIV
	return _mm_mul_ps(_mm_set1_ps(a), _mm_rcp_ps(b.m));
#else
	return _mm_div_ps(_mm_set1_ps(a), b.m);
#endif
}
/*inline vec4f operator* (vec4f v, Matrix4 m){
	return vec4f(_mm_dot(v.m, m.m0, 0xff),_mm_dot(v.m, m.m1, 0xff), _mm_dot(v.m, m.m2, 0xff), _mm_dot(v.m, m.m3, 0xff));
}
inline vec4f operator* (Matrix4 m,vec4f v){
	return vec4f(_mm_dot(v.m, m.m0, 0xff),_mm_dot(v.m, m.m1, 0xff), _mm_dot(v.m, m.m2, 0xff), _mm_dot(v.m, m.m3, 0xff));
}
*/
inline vec4f& operator+= (vec4f& a, vec4f b){
	a = a + b; return a;
}
inline vec4f& operator-= (vec4f& a, vec4f b){
	a = a - b; return a;
}
inline vec4f& operator*= (vec4f& a, vec4f b){
	a = a * b; return a;
}
inline vec4f& operator/= (vec4f& a, vec4f b){
	a = a / b; return a;
}
inline vec4f& operator*= (vec4f& a, float b){
	a = a * b; return a;
}
inline vec4f& operator/= (vec4f& a, float b){
	a = a / b; return a;
}
inline Vec3b operator== (vec4f a, vec4f b){
	return _mm_cmpeq_ps(a.m, b.m);
}
inline Vec3b operator!= (vec4f a, vec4f b){
	return _mm_cmpneq_ps(a.m, b.m);
}

inline Vec3b operator> (vec4f a, vec4f b){
	return _mm_cmpgt_ps(a.m, b.m);
}
inline Vec3b operator< (vec4f a, vec4f b){
	return _mm_cmplt_ps(a.m, b.m);
}
inline Vec3b operator>= (vec4f a, vec4f b){
	return _mm_cmpge_ps(a.m, b.m);
}
inline Vec3b operator<= (vec4f a, vec4f b){
	return _mm_cmple_ps(a.m, b.m);
}
inline vec4f min(vec4f a, vec4f b){
	return _mm_min_ps(a.m, b.m);
}
inline vec4f max(vec4f a, vec4f b){
	return _mm_max_ps(a.m, b.m);
}
inline vec4f operator- (vec4f a){
	return _mm_sub_ps(_mm_setzero_ps(), a.m);
}

//inline vec4f abs(vec4f a){
//return _mm_andnot_ps(vsignbits, a.m);
//}

inline float dot(vec4f a, vec4f b){
	__m128 res = _mm_dp_ps(a.m, b.m, 0x7f);
	
	return _mm_cvtss_f32(res);
}




#endif /* newVec_hpp */
