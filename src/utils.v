module raylib


pub fn ptr_arr_to_varr[T] (data voidptr, size int) []T {
    assert data != voidptr(0) && size > 0
    arr := []T{cap: size}
    unsafe {
        arr.data  = data
        arr.len   = size
        arr.flags = .noshrink | .nogrow
    }
    return arr
}
