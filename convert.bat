@echo off

REM Find Gimp in the registry
for /f "tokens=2*" %%a in ('reg query "HKCR\GIMP2.svg\shell\open\command" /ve 2^>^&1^|find "REG_"') do @set gimp=%%b

REM Calculate console exe
set gimp=%gimp:gimp-=gimp-console-%

REM Isolate exe
for %%i in (%gimp%) do (
    @set gimp=%%i
    goto :found
)

:found
echo Found Gimp console: %gimp%

REM Process files (change to "for /r %%i" for recursion)
for %%i in (*.heic) do (
    echo - Converting [ %%i --^> %%~ni.jpg ]
    %gimp% -i -b "(let* ((image (car (file-heif-load RUN-NONINTERACTIVE \"%%i\" \"%%i\"))) (drawable (car (gimp-image-get-active-layer image)))) (plug-in-autocrop RUN-NONINTERACTIVE image drawable) (gimp-file-save RUN-NONINTERACTIVE image drawable \"%%~ni.jpg\" \"%%~ni.jpg\") (gimp-image-delete image))" -b "(gimp-quit 0)"
)