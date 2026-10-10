@echo off
title Postal 1 PSP - GitHub Yukleme Araci
cd /d "%~dp0"

echo ========================================================
echo POSTAL 1 PSP PROJESI GITHUB'A YUKLENIYOR...
echo ========================================================
echo.
echo Tarayicinizda GitHub oturum acma penceresi acilirsa
echo lutfen onaylayin (Authorize).
echo.

git push -u origin main

echo.
echo ========================================================
if %ERRORLEVEL% EQU 0 (
    echo BASARILI: Tum kodlar GitHub'a yuklendi!
    echo Simdi GitHub reporunuzdaki 'Actions' sekmesine gidebilirsiniz.
) else (
    echo Bir hata olustu.
)
echo ========================================================
echo.
pause
