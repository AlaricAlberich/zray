const c = @cImport({
    @cInclude("raylib.h");
});
const main = @import("raylib.zig");
const Color = main.Color;
const Camera2D = main.Camera2D;
const Vector2 = main.Vector2;
const Key = main.Key;
const MouseButton = main.MouseButton;
const RenderTexture2D = main.RenderTexture2D;
// Window-related functions
/// Initialize window and OpenGL context
pub fn initWindow(screen_width: i32, screen_height: i32, title: []const u8) void {
    const t = @ptrCast([*c]const u8, title);
    c.InitWindow(screen_width, screen_height, t);
}
/// Check if KEY_ESCAPE pressed or Close icon pressed
pub fn windowShouldClose() bool {
    return c.WindowShouldClose();
}
/// Close window and unload OpenGL context
pub fn closeWindow() void {
    c.CloseWindow();
}
/// Check if window has been initialized successfully
pub fn isWindowReady() bool {
    return c.isWindowReady();
}
/// Check if window is currently fullscreen
pub fn isWindowFullscreen() bool {
    return c.isWindowFullscreen();
}
/// Check if window is currently hidden (only PLATFORM_DESKTOP)
pub fn isWindowHidden() bool {
    return c.isWindowHidden();
}
/// Check if window is currently minimized (only PLATFORM_DESKTOP)
pub fn isWindowMinimized() bool {
    return c.isWindowMinimized();
}
/// Check if window is currently maximized (only PLATFORM_DESKTOP)
pub fn isWindowMaximized() bool {
    return c.isWindowMaximized();
}
//    bool IsWindowFocused(void);                                 // Check if window is currently focused (only PLATFORM_DESKTOP)
//    bool IsWindowResized(void);                                 // Check if window has been resized last frame
//    bool IsWindowState(unsigned int flag);                      // Check if one specific window flag is enabled
//    void SetWindowState(unsigned int flags);                    // Set window configuration state using flags (only PLATFORM_DESKTOP)
//    void ClearWindowState(unsigned int flags);                  // Clear window configuration state flags
//    void ToggleFullscreen(void);                                // Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)
//    void MaximizeWindow(void);                                  // Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
//    void MinimizeWindow(void);                                  // Set window state: minimized, if resizable (only PLATFORM_DESKTOP)
//    void RestoreWindow(void);                                   // Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
//    void SetWindowIcon(Image image);                            // Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
//    void SetWindowIcons(Image *images, int count);              // Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
//    void SetWindowTitle(const char *title);                     // Set title for window (only PLATFORM_DESKTOP)
//    void SetWindowPosition(int x, int y);                       // Set window position on screen (only PLATFORM_DESKTOP)
//    void SetWindowMonitor(int monitor);                         // Set monitor for the current window (fullscreen mode)
//    void SetWindowMinSize(int width, int height);               // Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
//    void SetWindowSize(int width, int height);                  // Set window dimensions
//    void SetWindowOpacity(float opacity);                       // Set window opacity [0.0f..1.0f] (only PLATFORM_DESKTOP)
//    void *GetWindowHandle(void);                                // Get native window handle
/// Get current screen width
pub fn getScreenWidth() i32 {
    return c.GetScreenWidth();
}
//    int GetScreenHeight(void);                                  // Get current screen height
//    int GetRenderWidth(void);                                   // Get current render width (it considers HiDPI)
//    int GetRenderHeight(void);                                  // Get current render height (it considers HiDPI)
//    int GetMonitorCount(void);                                  // Get number of connected monitors
//    int GetCurrentMonitor(void);                                // Get current connected monitor
//    Vector2 GetMonitorPosition(int monitor);                    // Get specified monitor position
//    int GetMonitorWidth(int monitor);                           // Get specified monitor width (current video mode used by monitor)
//    int GetMonitorHeight(int monitor);                          // Get specified monitor height (current video mode used by monitor)
//    int GetMonitorPhysicalWidth(int monitor);                   // Get specified monitor physical width in millimetres
//    int GetMonitorPhysicalHeight(int monitor);                  // Get specified monitor physical height in millimetres
//    int GetMonitorRefreshRate(int monitor);                     // Get specified monitor refresh rate
//    Vector2 GetWindowPosition(void);                            // Get window position XY on monitor
//    Vector2 GetWindowScaleDPI(void);                            // Get window scale DPI factor
//    const char *GetMonitorName(int monitor);                    // Get the human-readable, UTF-8 encoded name of the primary monitor
//    void SetClipboardText(const char *text);                    // Set clipboard text content
//    const char *GetClipboardText(void);                         // Get clipboard text content
//    void EnableEventWaiting(void);                              // Enable waiting for events on EndDrawing(), no automatic event polling
//    void DisableEventWaiting(void);                             // Disable waiting for events on EndDrawing(), automatic events polling
//
//    // Custom frame control functions
//    // NOTE: Those functions are intended for advance users that want full control over the frame processing
//    // By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
//    // To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL
//    void SwapScreenBuffer(void);                                // Swap back buffer with front buffer (screen drawing)
//    void PollInputEvents(void);                                 // Register all input events
//    void WaitTime(double seconds);                              // Wait for some time (halt program execution)
//
//    // Cursor-related functions
//    void ShowCursor(void);                                      // Shows cursor
//    void HideCursor(void);                                      // Hides cursor
//    bool IsCursorHidden(void);                                  // Check if cursor is not visible
//    void EnableCursor(void);                                    // Enables cursor (unlock cursor)
//    void DisableCursor(void);                                   // Disables cursor (lock cursor)
//    bool IsCursorOnScreen(void);                                // Check if cursor is on the screen
//
//    // Drawing-related functions
/// Set background color (framebuffer clear color)
pub fn clearBackground(color: Color) void {
    c.ClearBackground(@bitCast(c.struct_Color, color));
}

/// Setup canvas (framebuffer) to start drawing
pub fn beginDrawing() void {
    c.BeginDrawing();
}
/// End canvas drawing and swap buffers (double buffering)
pub fn endDrawing() void {
    c.EndDrawing();
}
/// Begin 2D mode with custom camera (2D)
pub fn beginMode2D(camera: Camera2D) void {
    c.BeginMode2D(@bitCast(c.struct_Camera2D, camera));
}
/// Ends 2D mode with custom camera
pub fn endMode2D() void {
    c.EndMode2D();
}
//    void BeginMode3D(Camera3D camera);                          // Begin 3D mode with custom camera (3D)
//    void EndMode3D(void);                                       // Ends 3D mode and returns to default 2D orthographic mode
/// Begin drawing to render texture
pub fn beginTextureMode(target: RenderTexture2D) void {
    c.BeginTextureMode(target.cCast());
}
/// Ends drawing to render texture
pub fn endTextureMode() void {
    c.EndTextureMode();
}
//    void BeginShaderMode(Shader shader);                        // Begin custom shader drawing
//    void EndShaderMode(void);                                   // End custom shader drawing (use default shader)
//    void BeginBlendMode(int mode);                              // Begin blending mode (alpha, additive, multiplied, subtract, custom)
//    void EndBlendMode(void);                                    // End blending mode (reset to default: alpha blending)
//    void BeginScissorMode(int x, int y, int width, int height); // Begin scissor mode (define screen area for following drawing)
//    void EndScissorMode(void);                                  // End scissor mode
//    void BeginVrStereoMode(VrStereoConfig config);              // Begin stereo rendering (requires VR simulator)
//    void EndVrStereoMode(void);                                 // End stereo rendering (requires VR simulator)
//
//    // VR stereo config functions for VR simulator
//    VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device);     // Load VR stereo config for VR simulator device parameters
//    void UnloadVrStereoConfig(VrStereoConfig config);           // Unload VR stereo config
//
//    // Shader management functions
//    // NOTE: Shader functionality is not available on OpenGL 1.1
//    Shader LoadShader(const char *vsFileName, const char *fsFileName);   // Load shader from files and bind default locations
//    Shader LoadShaderFromMemory(const char *vsCode, const char *fsCode); // Load shader from code strings and bind default locations
//    bool IsShaderReady(Shader shader);                                   // Check if a shader is ready
//    int GetShaderLocation(Shader shader, const char *uniformName);       // Get shader uniform location
//    int GetShaderLocationAttrib(Shader shader, const char *attribName);  // Get shader attribute location
//    void SetShaderValue(Shader shader, int locIndex, const void *value, int uniformType);               // Set shader uniform value
//    void SetShaderValueV(Shader shader, int locIndex, const void *value, int uniformType, int count);   // Set shader uniform value vector
//    void SetShaderValueMatrix(Shader shader, int locIndex, Matrix mat);         // Set shader uniform value (matrix 4x4)
//    void SetShaderValueTexture(Shader shader, int locIndex, Texture2D texture); // Set shader uniform value for texture (sampler2d)
//    void UnloadShader(Shader shader);                                    // Unload shader from GPU memory (VRAM)

// Screen-space-related functions
//    Ray GetMouseRay(Vector2 mousePosition, Camera camera);      // Get a ray trace from mouse position
//    Matrix GetCameraMatrix(Camera camera);                      // Get camera transform matrix (view matrix)
//    Matrix GetCameraMatrix2D(Camera2D camera);                  // Get camera 2d transform matrix
//    Vector2 GetWorldToScreen(Vector3 position, Camera camera);  // Get the screen space position for a 3d world space position
/// Get the world space position for a 2d camera screen space position
pub fn getScreenToWorld2D(position: Vector2, camera: Camera2D) Vector2 {
    const converted_position = @bitCast(c.struct_Vector2, position);
    const converted_camera = @bitCast(c.struct_Camera2D, camera);
    return @bitCast(Vector2, c.GetScreenToWorld2D(converted_position, converted_camera));
}
//    Vector2 GetWorldToScreenEx(Vector3 position, Camera camera, int width, int height); // Get size position for a 3d world space position
/// Get the screen space position for a 2d camera world space position
pub fn getWorldToScreen2D(position: Vector2, camera: Camera2D) Vector2 {
    const converted_position = @bitCast(c.struct_Vector2, position);
    const converted_camera = @bitCast(c.struct_Camera2D, camera);
    return @bitCast(Vector2, c.GetWorldToScreen2D(converted_position, converted_camera));
}

// Timing-related functions
/// Set target FPS (maximum)
pub fn setTargetFPS(fps: i32) void {
    c.SetTargetFPS(fps);
}
//    int GetFPS(void);                                           // Get current FPS
/// Get time in seconds for last frame drawn (delta time)
pub fn getFrameTime() f32 {
    return c.GetFrameTime();
}
/// Get elapsed time in seconds since InitWindow()
pub fn getTime() f64 {
    return c.GetTime();
}

//    // Misc. functions
/// Get a random value between min and max (both included)
pub fn getRandomValue(min: i32, max: i32) i32 {
    return c.GetRandomValue(min, max);
}
//    void SetRandomSeed(unsigned int seed);                      // Set the seed for the random number generator
//    void TakeScreenshot(const char *fileName);                  // Takes a screenshot of current screen (filename extension defines format)
//    void SetConfigFlags(unsigned int flags);                    // Setup init configuration flags (view FLAGS)

//    void TraceLog(int logLevel, const char *text, ...);         // Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
//    void SetTraceLogLevel(int logLevel);                        // Set the current threshold (minimum) log level
//    void *MemAlloc(unsigned int size);                          // Internal memory allocator
//    void *MemRealloc(void *ptr, unsigned int size);             // Internal memory reallocator
//    void MemFree(void *ptr);                                    // Internal memory free

//    void OpenURL(const char *url);                              // Open URL with default system browser (if available)

//    // Set custom callbacks
//    // WARNING: Callbacks setup is intended for advance users
//    void SetTraceLogCallback(TraceLogCallback callback);         // Set custom trace log
//    void SetLoadFileDataCallback(LoadFileDataCallback callback); // Set custom file binary data loader
//    void SetSaveFileDataCallback(SaveFileDataCallback callback); // Set custom file binary data saver
//    void SetLoadFileTextCallback(LoadFileTextCallback callback); // Set custom file text data loader
//    void SetSaveFileTextCallback(SaveFileTextCallback callback); // Set custom file text data saver

//    // Files management functions
pub const FilePathList = struct {
    capacity: u32,
    count: u32,
    paths: [*][*]u8,
};
//    unsigned char *LoadFileData(const char *fileName, unsigned int *bytesRead);       // Load file data as byte array (read)
//    void UnloadFileData(unsigned char *data);                   // Unload file data allocated by LoadFileData()
//    bool SaveFileData(const char *fileName, void *data, unsigned int bytesToWrite);   // Save data to file from byte array (write), returns true on success
//    bool ExportDataAsCode(const unsigned char *data, unsigned int size, const char *fileName); // Export data to code (.h), returns true on success
//    char *LoadFileText(const char *fileName);                   // Load text data from file (read), returns a '\0' terminated string
//    void UnloadFileText(char *text);                            // Unload file text data allocated by LoadFileText()
//    bool SaveFileText(const char *fileName, char *text);        // Save text data to file (write), string must be '\0' terminated, returns true on success
//    bool FileExists(const char *fileName);                      // Check if file exists
//    bool DirectoryExists(const char *dirPath);                  // Check if a directory path exists
//    bool IsFileExtension(const char *fileName, const char *ext); // Check file extension (including point: .png, .wav)
//    int GetFileLength(const char *fileName);                    // Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
//    const char *GetFileExtension(const char *fileName);         // Get pointer to extension for a filename string (includes dot: '.png')
//    const char *GetFileName(const char *filePath);              // Get pointer to filename for a path string
//    const char *GetFileNameWithoutExt(const char *filePath);    // Get filename string without extension (uses static string)
//    const char *GetDirectoryPath(const char *filePath);         // Get full path for a given fileName with path (uses static string)
//    const char *GetPrevDirectoryPath(const char *dirPath);      // Get previous directory path for a given path (uses static string)
//    const char *GetWorkingDirectory(void);                      // Get current working directory (uses static string)
//    const char *GetApplicationDirectory(void);                  // Get the directory if the running application (uses static string)
//    bool ChangeDirectory(const char *dir);                      // Change working directory, return true on success
//    bool IsPathFile(const char *path);                          // Check if a given path is a file or a directory
//    FilePathList LoadDirectoryFiles(const char *dirPath);       // Load directory filepaths
//    FilePathList LoadDirectoryFilesEx(const char *basePath, const char *filter, bool scanSubdirs); // Load directory filepaths with extension filtering and recursive directory scan
//    void UnloadDirectoryFiles(FilePathList files);              // Unload filepaths
/// Check if a file has been dropped into window
pub fn isFileDropped() bool {
    return c.IsFileDropped();
}
/// Load dropped filepaths
pub fn loadDroppedFiles() FilePathList {
    const c_files = c.LoadDroppedFiles();
    const result: FilePathList = .{ .capacity = c_files.capacity, .count = c_files.count, .paths = @ptrCast([*][*]u8, c_files.paths) };
    return result;
}
//    void UnloadDroppedFiles(FilePathList files);                // Unload dropped filepaths
pub fn unloadDroppedFiles(files: FilePathList) void {
    const c_ptr = @ptrCast([*c][*c]u8, files.paths);
    const c_files = .{ .capacity = files.capacity, .count = files.count, .paths = c_ptr };
    c.UnloadDroppedFiles(c_files);
}
//    long GetFileModTime(const char *fileName);                  // Get file modification time (last write time)

//    // Compression/Encoding functionality
//    unsigned char *CompressData(const unsigned char *data, int dataSize, int *compDataSize);        // Compress data (DEFLATE algorithm), memory must be MemFree()
//    unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize);  // Decompress data (DEFLATE algorithm), memory must be MemFree()
//    char *EncodeDataBase64(const unsigned char *data, int dataSize, int *outputSize);               // Encode data to Base64 string, memory must be MemFree()
//    unsigned char *DecodeDataBase64(const unsigned char *data, int *outputSize);                    // Decode Base64 string data, memory must be MemFree()

//------------------------------------------------------------------------------------
// Input Handling Functions (Module: core)
//------------------------------------------------------------------------------------

// Input-related functions: keyboard
/// Check if a key has been pressed once
pub fn isKeyPressed(key: Key) bool {
    const num = @enumToInt(key);
    return c.IsKeyPressed(num);
}
/// Check if a key is being pressed
pub fn isKeyDown(key: Key) bool {
    const num = @enumToInt(key);
    return c.IsKeyDown(num);
}
//    bool IsKeyReleased(int key);                            // Check if a key has been released once
//    bool IsKeyUp(int key);                                  // Check if a key is NOT being pressed
//    void SetExitKey(int key);                               // Set a custom key to exit program (default is ESC)
//    int GetKeyPressed(void);                                // Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
//    int GetCharPressed(void);                               // Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty

//    // Input-related functions: gamepads
//    bool IsGamepadAvailable(int gamepad);                   // Check if a gamepad is available
//    const char *GetGamepadName(int gamepad);                // Get gamepad internal name id
//    bool IsGamepadButtonPressed(int gamepad, int button);   // Check if a gamepad button has been pressed once
//    bool IsGamepadButtonDown(int gamepad, int button);      // Check if a gamepad button is being pressed
//    bool IsGamepadButtonReleased(int gamepad, int button);  // Check if a gamepad button has been released once
//    bool IsGamepadButtonUp(int gamepad, int button);        // Check if a gamepad button is NOT being pressed
//    int GetGamepadButtonPressed(void);                      // Get the last gamepad button pressed
//    int GetGamepadAxisCount(int gamepad);                   // Get gamepad axis count for a gamepad
//    float GetGamepadAxisMovement(int gamepad, int axis);    // Get axis movement value for a gamepad axis
//    int SetGamepadMappings(const char *mappings);           // Set internal gamepad mappings (SDL_GameControllerDB)

//    // Input-related functions: mouse
/// Check if a mouse button has been pressed once
pub fn isMouseButtonPressed(button: MouseButton) bool {
    const num = @enumToInt(button);
    return c.IsMouseButtonPressed(num);
}
//    bool IsMouseButtonDown(int button);                     // Check if a mouse button is being pressed
//    bool IsMouseButtonReleased(int button);                 // Check if a mouse button has been released once
//    bool IsMouseButtonUp(int button);                       // Check if a mouse button is NOT being pressed
//    int GetMouseX(void);                                    // Get mouse position X
//    int GetMouseY(void);                                    // Get mouse position Y
/// Get mouse position XY
pub fn getMousePosition() Vector2 {
    const p = c.GetMousePosition();
    return @bitCast(Vector2, p);
}
//    Vector2 GetMouseDelta(void);                            // Get mouse delta between frames
//    void SetMousePosition(int x, int y);                    // Set mouse position XY
//    void SetMouseOffset(int offsetX, int offsetY);          // Set mouse offset
//    void SetMouseScale(float scaleX, float scaleY);         // Set mouse scaling
/// Get mouse wheel movement for X or Y, whichever is larger
pub fn getMouseWheelMove() f32 {
    return c.GetMouseWheelMove();
}
//    Vector2 GetMouseWheelMoveV(void);                       // Get mouse wheel movement for both X and Y
//    void SetMouseCursor(int cursor);                        // Set mouse cursor

//    // Input-related functions: touch
//    int GetTouchX(void);                                    // Get touch position X for touch point 0 (relative to screen size)
//    int GetTouchY(void);                                    // Get touch position Y for touch point 0 (relative to screen size)
//    Vector2 GetTouchPosition(int index);                    // Get touch position XY for a touch point index (relative to screen size)
//    int GetTouchPointId(int index);                         // Get touch point identifier for given index
//    int GetTouchPointCount(void);                           // Get number of touch points

//    //------------------------------------------------------------------------------------
//    // Gestures and Touch Handling Functions (Module: rgestures)
//    //------------------------------------------------------------------------------------
//    void SetGesturesEnabled(unsigned int flags);      // Enable a set of gestures using flags
//    bool IsGestureDetected(int gesture);              // Check if a gesture have been detected
//    int GetGestureDetected(void);                     // Get latest detected gesture
//    float GetGestureHoldDuration(void);               // Get gesture hold time in milliseconds
//    Vector2 GetGestureDragVector(void);               // Get gesture drag vector
//    float GetGestureDragAngle(void);                  // Get gesture drag angle
//    Vector2 GetGesturePinchVector(void);              // Get gesture pinch delta
//    float GetGesturePinchAngle(void);                 // Get gesture pinch angle

//    //------------------------------------------------------------------------------------
//    // Camera System Functions (Module: rcamera)
//    //------------------------------------------------------------------------------------
//    void UpdateCamera(Camera *camera, int mode);      // Update camera position for selected mode
//    void UpdateCameraPro(Camera *camera, Vector3 movement, Vector3 rotation, float zoom); // Update camera movement/rotation
