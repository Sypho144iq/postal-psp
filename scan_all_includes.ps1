$incDirs = @(
    ".",
    "RSPiX",
    "RSPiX/Inc",
    "RSPiX/Src",
    "RSPiX/Src/BLUE",
    "RSPiX/Src/BLUE/unix",
    "RSPiX/Src/CYAN",
    "RSPiX/Src/CYAN/Unix",
    "RSPiX/Src/ORANGE",
    "RSPiX/Src/ORANGE/CDT",
    "RSPiX/Src/ORANGE/GameLib",
    "RSPiX/Src/ORANGE/File",
    "RSPiX/Src/ORANGE/Multigrid",
    "RSPiX/Src/GREEN/Image",
    "WishPiX",
    "WishPiX/Spry"
)

# Standard C / C++ / POSIX / PSP SDK headers
$knownHeaders = @(
    "stdio.h","stdlib.h","string.h","stdint.h","stdbool.h","stddef.h","ctype.h",
    "math.h","time.h","unistd.h","fcntl.h","sys/types.h","sys/stat.h","sys/time.h",
    "sys/param.h","dirent.h","limits.h","errno.h","assert.h","signal.h","stdarg.h",
    "iostream","vector","string","map","list","algorithm","cmath","cstring","cstdio",
    "memory","functional","utility","new","cstddef","cstdint","cstdlib","cassert",
    "SDL.h","SDL_audio.h","SDL_endian.h","SDL_error.h","SDL_events.h","SDL_joystick.h",
    "SDL_keyboard.h","SDL_mouse.h","SDL_mutex.h","SDL_rwops.h","SDL_stdinc.h","SDL_thread.h",
    "SDL_timer.h","SDL_video.h","SDL_version.h",
    "pspkernel.h","pspdisplay.h","pspgu.h","pspgum.h","pspctrl.h","psprtc.h","pspaudio.h",
    "psppower.h","psptypes.h","pspthreadman.h","psphprm.h","malloc.h"
)

$cppFiles = Get-ChildItem -Recurse -Include *.cpp, *.c, *.h | Where-Object { $_.FullName -notmatch '\.git' }

$suspiciousIncludes = @()

foreach ($file in $cppFiles) {
    $lines = Get-Content $file.FullName
    $lineNum = 0
    foreach ($line in $lines) {
        $lineNum++
        if ($line -match '^\s*#\s*include\s*[<"]([^>"]+)[>"]') {
            $inc = $matches[1]
            if ($knownHeaders -contains $inc -or $knownHeaders -contains [System.IO.Path]::GetFileName($inc)) {
                continue
            }
            # Check if file exists in any incDirs
            $found = $false
            foreach ($dir in $incDirs) {
                $check = Join-Path $dir $inc
                if (Test-Path $check) {
                    $found = $true
                    break
                }
            }
            if (-not $found) {
                $suspiciousIncludes += [PSCustomObject]@{
                    File = $file.FullName.Replace((Get-Location).Path + "\", "")
                    Line = $lineNum
                    Include = $inc
                    RawLine = $line.Trim()
                }
            }
        }
    }
}

Write-Output "=== TARAMA SONUCLARI: DISKTE VEYA STANDARTTA BULUNAMAYAN BASLIKLAR ==="
$suspiciousIncludes | Group-Object Include | ForEach-Object {
    Write-Output "Baslik: $($_.Name) ($($_.Count) yerde geciyor):"
    $_.Group | ForEach-Object {
        Write-Output "   -> $($_.File):$($_.Line) : $($_.RawLine)"
    }
}
