@echo off
cls
echo ################################################################################
echo # Simple script to create a bootable Windows on external usb for Macbook Pro   #
echo # superkhung@vnsecurity.net                                                    #
echo ################################################################################
echo.
set /p Answer=This script will erease all your partition and data. Do you want to continue (y/n) ? 
if "%Answer%" == "y" goto begin
exit

:begin
echo > %Temp%\listdisk list disk
diskpart /s %Temp%\listdisk
set /p Disk=Select disk to partition: 
if "%Disk%" == "" goto begin
if "%Disk%" == "0" goto printerror
goto dopart

:printerror
echo You can not use current boot Windows disk
pause
goto begin

:dopart
echo > %Temp%\dopart select disk %Disk%
echo >>  %Temp%\dopart clean
echo >> %Temp%\dopart convert mbr
echo >> %Temp%\dopart create partition primary size=200
echo >> %Temp%\dopart active
echo >> %Temp%\dopart format quick fs=fat32 label="EFI"
echo >> %Temp%\dopart assign letter="Y"
set /p Size=Enter your Windows partition size (MB): 
if "%Size%" == "" goto dopartall
echo >> %Temp%\dopart create partition primary size=%Size%
echo >> %Temp%\dopart format quick fs=ntfs label="Win10"
echo >> %Temp%\dopart assign letter="Z"
goto deploywin

:dopartall
echo >> %Temp%\dopart create partition primary
echo >> %Temp%\dopart format quick fs=ntfs label="Win10"
echo >> %Temp%\dopart assign letter="Z"

:deploywin
diskpart /s %Temp%\dopart
set /p imgpath=Enter windows image path (install.wim): 
dism /apply-image /imagefile:%imgpath% /index:1 /applydir:Z:\
bcdboot Z:\Windows /f all /s Y:
pause