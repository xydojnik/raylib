module raylib

// NOTE: Not working.

// Trace log level
// NOTE: Organized by priority level
pub enum TraceLogLevel {
    log_all     = C.LOG_ALL     // Display all logs
    log_trace   = C.LOG_TRACE   // Trace logging, intended for internal use only
    log_debug   = C.LOG_DEBUG   // Debug logging, used for internal debugging, it should be disabled on release builds
    log_info    = C.LOG_INFO    // Info logging, used for program execution info
    log_warning = C.LOG_WARNING // Warning logging, used on recoverable failures
    log_error   = C.LOG_ERROR   // Error logging, used on unrecoverable failures
    log_fatal   = C.LOG_FATAL   // Fatal logging, used to abort program: exit(EXIT_FAILURE)
    log_none    = C.LOG_NONE    // Disable logging
}


// Logging: Redirect trace log messages
@[typedef]
pub struct C.va_list {
    gp_offset         u32
    fp_offset         u32
    overflow_arg_area voidptr
    reg_save_area     voidptr
}

pub fn C.va_start(voidptr, voidptr)
pub fn C.va_arg(voidptr, any) any
pub fn C.va_copy(voidptr, voidptr)
pub fn C.va_end(voidptr)

pub type TraceLogCallback = fn (int, charptr, voidptr)


fn C.SetTraceLogCallback(callback TraceLogCallback)
@[inline]
pub fn set_trace_log_callback(callback TraceLogCallback) {
	C.SetTraceLogCallback(callback)
}

// TODO: Not working
// fn C.TraceLog(log_level int, format charptr, C.va_list) // Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
fn C.TraceLog(log_level int, format charptr, voidptr) // Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
@[inline]
pub fn trace_log(log_level TraceLogLevel, format string, ... ) {
    mut arg_list := C.va_list{}

    C.va_start(arg_list, format.str)
    C.TraceLog(int(log_level), format.str, arg_list)
    C.va_end(arg_list)
}

fn C.SetTraceLogLevel(log_level int)               // Set the current threshold (minimum) log level
@[inline]
fn set_trace_log_level(log_level TraceLogLevel) {
    C.SetTraceLogLevel(int(log_level))
}
