////////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 RWS Inc, All Rights Reserved
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of version 2 of the GNU General Public License as published by
// the Free Software Foundation
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
//
///////////////////////////////////////////////////////////////////////////////
//
//	btime.cpp
// 
// History:
//		06/03/04 RCG	Started.
//
//////////////////////////////////////////////////////////////////////////////
//
// Does all SDL specific time stuff.
//
//////////////////////////////////////////////////////////////////////////////

#include "Blue.h"
#include "SDL.h"

#ifdef __PSP__
#include <psptypes.h>
#include <psprtc.h>
#include <pspthreadman.h>
static u64 psp_time_base = 0;
static u64 psp_app_start = 0;
#endif

static Uint32 MicrosecondsBase = 0;

//////////////////////////////////////////////////////////////////////////////
// Functions.
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//
// Initializes the time module.
//
//////////////////////////////////////////////////////////////////////////////
extern void Time_Init(void)
	{
#ifdef __PSP__
    psp_time_base = sceKernelGetSystemTimeWide();
    psp_app_start = psp_time_base;
#endif
    MicrosecondsBase = SDL_GetTicks();
	}



//////////////////////////////////////////////////////////////////////////////
//
// Get the current Windows' time.
// Returns the time in a long.
//
//////////////////////////////////////////////////////////////////////////////
extern int32_t rspGetMilliseconds(void)
	{
#ifdef __PSP__
        return (int32_t)(sceKernelGetSystemTimeWide() / 1000);
#else
        return (int32_t) (SDL_GetTicks());
#endif
	}

extern int32_t rspGetMicroseconds(	// Returns microseconds between now and
											// last
	int16_t sReset /*= FALSE*/)		// Set to TRUE to reset timer.  If you never
											// reset the timer, it will wrap within
											// just over 35 minutes.
	{
#ifdef __PSP__
    u64 now = sceKernelGetSystemTimeWide();
    int32_t lTime = (int32_t)(now - psp_time_base);
    if (sReset != FALSE)
        psp_time_base = now;
    return lTime;
#else
    Uint32 microsecs = SDL_GetTicks();
    int32_t lTime = (int32_t) (microsecs - MicrosecondsBase);

		// If reset requested . . .
	if (sReset != FALSE)
		MicrosecondsBase = microsecs;

	return lTime * 1000;
#endif
	}

extern S64 rspGetAppMicroseconds()
	{
#ifdef __PSP__
        return (S64)(sceKernelGetSystemTimeWide() - psp_app_start);
#else
        return ((S64) SDL_GetTicks()) * 1000;
#endif
	}


//////////////////////////////////////////////////////////////////////////////
// EOF
//////////////////////////////////////////////////////////////////////////////
