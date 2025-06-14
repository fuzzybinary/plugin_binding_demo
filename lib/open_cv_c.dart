// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

class OpenCv {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  OpenCv(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  OpenCv.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void initializeOpenCV() {
    return _initializeOpenCV();
  }

  late final _initializeOpenCVPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('initializeOpenCV');
  late final _initializeOpenCV =
      _initializeOpenCVPtr.asFunction<void Function()>(isLeaf: true);

  void freeDecodeResult(
    ffi.Pointer<DecodeResult> result,
  ) {
    return _freeDecodeResult(
      result,
    );
  }

  late final _freeDecodeResultPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<DecodeResult>)>>(
          'freeDecodeResult');
  late final _freeDecodeResult = _freeDecodeResultPtr
      .asFunction<void Function(ffi.Pointer<DecodeResult>)>(isLeaf: true);

  ffi.Pointer<DecodeResult> decodeMarkers(
    ffi.Pointer<ffi.Uint8> imageData,
    int width,
    int height,
  ) {
    return _decodeMarkers(
      imageData,
      width,
      height,
    );
  }

  late final _decodeMarkersPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<DecodeResult> Function(
              ffi.Pointer<ffi.Uint8>, ffi.Int, ffi.Int)>>('decodeMarkers');
  late final _decodeMarkers = _decodeMarkersPtr.asFunction<
      ffi.Pointer<DecodeResult> Function(
          ffi.Pointer<ffi.Uint8>, int, int)>(isLeaf: true);
}

typedef __int8_t = ffi.SignedChar;
typedef Dart__int8_t = int;
typedef __uint8_t = ffi.UnsignedChar;
typedef Dart__uint8_t = int;
typedef __int16_t = ffi.Short;
typedef Dart__int16_t = int;
typedef __uint16_t = ffi.UnsignedShort;
typedef Dart__uint16_t = int;
typedef __int32_t = ffi.Int;
typedef Dart__int32_t = int;
typedef __uint32_t = ffi.UnsignedInt;
typedef Dart__uint32_t = int;
typedef __int64_t = ffi.LongLong;
typedef Dart__int64_t = int;
typedef __uint64_t = ffi.UnsignedLongLong;
typedef Dart__uint64_t = int;
typedef __darwin_intptr_t = ffi.Long;
typedef Dart__darwin_intptr_t = int;
typedef __darwin_natural_t = ffi.UnsignedInt;
typedef Dart__darwin_natural_t = int;
typedef __darwin_ct_rune_t = ffi.Int;
typedef Dart__darwin_ct_rune_t = int;

final class __mbstate_t extends ffi.Union {
  @ffi.Array.multi([128])
  external ffi.Array<ffi.Char> __mbstate8;

  @ffi.LongLong()
  external int _mbstateL;
}

typedef __darwin_mbstate_t = __mbstate_t;
typedef __darwin_ptrdiff_t = ffi.Long;
typedef Dart__darwin_ptrdiff_t = int;
typedef __darwin_size_t = ffi.UnsignedLong;
typedef Dart__darwin_size_t = int;
typedef __builtin_va_list = ffi.Pointer<ffi.Char>;
typedef __darwin_va_list = __builtin_va_list;
typedef __darwin_wchar_t = ffi.Int;
typedef Dart__darwin_wchar_t = int;
typedef __darwin_rune_t = __darwin_wchar_t;
typedef __darwin_wint_t = ffi.Int;
typedef Dart__darwin_wint_t = int;
typedef __darwin_clock_t = ffi.UnsignedLong;
typedef Dart__darwin_clock_t = int;
typedef __darwin_socklen_t = __uint32_t;
typedef __darwin_ssize_t = ffi.Long;
typedef Dart__darwin_ssize_t = int;
typedef __darwin_time_t = ffi.Long;
typedef Dart__darwin_time_t = int;
typedef u_int8_t = ffi.UnsignedChar;
typedef Dartu_int8_t = int;
typedef u_int16_t = ffi.UnsignedShort;
typedef Dartu_int16_t = int;
typedef u_int32_t = ffi.UnsignedInt;
typedef Dartu_int32_t = int;
typedef u_int64_t = ffi.UnsignedLongLong;
typedef Dartu_int64_t = int;
typedef register_t = ffi.Int64;
typedef Dartregister_t = int;
typedef user_addr_t = u_int64_t;
typedef user_size_t = u_int64_t;
typedef user_ssize_t = ffi.Int64;
typedef Dartuser_ssize_t = int;
typedef user_long_t = ffi.Int64;
typedef Dartuser_long_t = int;
typedef user_ulong_t = u_int64_t;
typedef user_time_t = ffi.Int64;
typedef Dartuser_time_t = int;
typedef user_off_t = ffi.Int64;
typedef Dartuser_off_t = int;
typedef user_addr_ut = user_addr_t;
typedef user_size_ut = user_size_t;
typedef user64_addr_t = __uint64_t;
typedef user64_size_t = __uint64_t;
typedef user64_ssize_t = __int64_t;
typedef user64_long_t = __int64_t;
typedef user64_ulong_t = __uint64_t;
typedef user64_time_t = __int64_t;
typedef user64_off_t = __int64_t;
typedef user32_addr_t = __uint32_t;
typedef user32_size_t = __uint32_t;
typedef user32_ssize_t = __int32_t;
typedef user32_long_t = __int32_t;
typedef user32_ulong_t = __uint32_t;
typedef user32_time_t = __int32_t;
typedef user32_off_t = __int64_t;
typedef syscall_arg_t = u_int64_t;
typedef int_least8_t = ffi.Int8;
typedef Dartint_least8_t = int;
typedef int_least16_t = ffi.Int16;
typedef Dartint_least16_t = int;
typedef int_least32_t = ffi.Int32;
typedef Dartint_least32_t = int;
typedef int_least64_t = ffi.Int64;
typedef Dartint_least64_t = int;
typedef uint_least8_t = ffi.Uint8;
typedef Dartuint_least8_t = int;
typedef uint_least16_t = ffi.Uint16;
typedef Dartuint_least16_t = int;
typedef uint_least32_t = ffi.Uint32;
typedef Dartuint_least32_t = int;
typedef uint_least64_t = ffi.Uint64;
typedef Dartuint_least64_t = int;
typedef int_fast8_t = ffi.Int8;
typedef Dartint_fast8_t = int;
typedef int_fast16_t = ffi.Int16;
typedef Dartint_fast16_t = int;
typedef int_fast32_t = ffi.Int32;
typedef Dartint_fast32_t = int;
typedef int_fast64_t = ffi.Int64;
typedef Dartint_fast64_t = int;
typedef uint_fast8_t = ffi.Uint8;
typedef Dartuint_fast8_t = int;
typedef uint_fast16_t = ffi.Uint16;
typedef Dartuint_fast16_t = int;
typedef uint_fast32_t = ffi.Uint32;
typedef Dartuint_fast32_t = int;
typedef uint_fast64_t = ffi.Uint64;
typedef Dartuint_fast64_t = int;
typedef intmax_t = ffi.Long;
typedef Dartintmax_t = int;
typedef uintmax_t = ffi.UnsignedLong;
typedef Dartuintmax_t = int;

final class Marker extends ffi.Struct {
  @ffi.Int()
  external int id;

  @ffi.Array.multi([8])
  external ffi.Array<ffi.Float> corners;
}

final class DecodeResult extends ffi.Struct {
  @ffi.Int()
  external int markersCount;

  external ffi.Pointer<Marker> markers;
}

const int __has_safe_buffers = 1;

const int __DARWIN_ONLY_64_BIT_INO_T = 0;

const int __DARWIN_ONLY_UNIX_CONFORMANCE = 0;

const int __DARWIN_ONLY_VERS_1050 = 0;

const int __DARWIN_UNIX03 = 0;

const int __DARWIN_64_BIT_INO_T = 0;

const int __DARWIN_VERS_1050 = 0;

const int __DARWIN_NON_CANCELABLE = 0;

const String __DARWIN_SUF_EXTSN = '\$DARWIN_EXTSN';

const int __DARWIN_C_ANSI = 4096;

const int __DARWIN_C_FULL = 900000;

const int __DARWIN_C_LEVEL = 900000;

const int __STDC_WANT_LIB_EXT1__ = 1;

const int __DARWIN_NO_LONG_LONG = 0;

const int __has_ptrcheck = 0;

const int USER_ADDR_NULL = 0;

const int __WORDSIZE = 64;

const int INT8_MAX = 127;

const int INT16_MAX = 32767;

const int INT32_MAX = 2147483647;

const int INT64_MAX = 9223372036854775807;

const int INT8_MIN = -128;

const int INT16_MIN = -32768;

const int INT32_MIN = -2147483648;

const int INT64_MIN = -9223372036854775808;

const int UINT8_MAX = 255;

const int UINT16_MAX = 65535;

const int UINT32_MAX = 4294967295;

const int UINT64_MAX = -1;

const int INT_LEAST8_MIN = -128;

const int INT_LEAST16_MIN = -32768;

const int INT_LEAST32_MIN = -2147483648;

const int INT_LEAST64_MIN = -9223372036854775808;

const int INT_LEAST8_MAX = 127;

const int INT_LEAST16_MAX = 32767;

const int INT_LEAST32_MAX = 2147483647;

const int INT_LEAST64_MAX = 9223372036854775807;

const int UINT_LEAST8_MAX = 255;

const int UINT_LEAST16_MAX = 65535;

const int UINT_LEAST32_MAX = 4294967295;

const int UINT_LEAST64_MAX = -1;

const int INT_FAST8_MIN = -128;

const int INT_FAST16_MIN = -32768;

const int INT_FAST32_MIN = -2147483648;

const int INT_FAST64_MIN = -9223372036854775808;

const int INT_FAST8_MAX = 127;

const int INT_FAST16_MAX = 32767;

const int INT_FAST32_MAX = 2147483647;

const int INT_FAST64_MAX = 9223372036854775807;

const int UINT_FAST8_MAX = 255;

const int UINT_FAST16_MAX = 65535;

const int UINT_FAST32_MAX = 4294967295;

const int UINT_FAST64_MAX = -1;

const int INTPTR_MAX = 9223372036854775807;

const int INTPTR_MIN = -9223372036854775808;

const int UINTPTR_MAX = -1;

const int INTMAX_MAX = 9223372036854775807;

const int UINTMAX_MAX = -1;

const int INTMAX_MIN = -9223372036854775808;

const int PTRDIFF_MIN = -9223372036854775808;

const int PTRDIFF_MAX = 9223372036854775807;

const int SIZE_MAX = -1;

const int RSIZE_MAX = 9223372036854775807;

const int WCHAR_MAX = 2147483647;

const int WCHAR_MIN = -2147483648;

const int WINT_MIN = -2147483648;

const int WINT_MAX = 2147483647;

const int SIG_ATOMIC_MIN = -2147483648;

const int SIG_ATOMIC_MAX = 2147483647;
