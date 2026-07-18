@echo off
setlocal


echo ==============================================
echo STEP 1: CLEANING BUILD DIRECTORY
echo ==============================================

if exist build (
    echo Deleting existing build folder...
    rmdir /s /q build
)

echo.
echo ==========================================
echo STEP 2: CONFIGURING PROJECT WITH CMAKE
echo ==========================================

cmake -S . -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-none-eabi.cmake
if %ERRORLEVEL% neq 0 (
    echo CMake configuration failed!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo STEP 3: COMPILING FIRMWARE WITH NINJA
echo ==========================================

Ninja -C build
if %ERRORLEVEL% neq 0 (
    echo BUILD failed!
    pause
    exit /b 1
)


echo.
echo ==========================================
echo STEP 4: FLASHING FIRMWARE TO TARGET MCU
echo ==========================================

STM32_Programmer_CLI ^
-c port=SWD ^
-w build\week04.bin 0x08000000 ^
-v ^
-rst

if errorlevel 1 (
    echo.
    echo Flash failed!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo BUILD AND FLASH COMPLETED SUCCESSFULLY
echo ==========================================

pause
endlocal 

