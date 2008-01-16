/* internal-flt.h -- common header file for the internal FLT API.
   Copyright (C) 2007
     National Institute of Advanced Industrial Science and Technology (AIST)
     Registration Number H15PRO112

   This file is part of the m17n library.

   The m17n library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License
   as published by the Free Software Foundation; either version 2.1 of
   the License, or (at your option) any later version.

   The m17n library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the m17n library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   02111-1307, USA.  */

#ifndef _M_INTERNAL_FLT_H
#define _M_INTERNAL_FLT_H

#define MAKE_COMBINING_CODE(base_y, base_x, add_y, add_x, off_y, off_x)	\
  (((off_y) << 16)							\
   | ((off_x) << 8)							\
   | ((base_x) << 6)							\
   | ((base_y) << 4)							\
   | ((add_x) << 2)							\
   | (add_y))

#define COMBINING_CODE_OFF_Y(code) ((((code) >> 16) & 0xFF) - 128)
#define COMBINING_CODE_OFF_X(code) ((((code) >> 8) & 0xFF) - 128)
#define COMBINING_CODE_BASE_X(code) (((code) >> 6) & 0x3)
#define COMBINING_CODE_BASE_Y(code) (((code) >> 4) & 0x3)
#define COMBINING_CODE_ADD_X(code) (((code) >> 2) & 0x3)
#define COMBINING_CODE_ADD_Y(code) ((code) & 0x3)

#define MAKE_COMBINING_CODE_BY_CLASS(class) (0x1000000 | class)

#define COMBINING_BY_CLASS_P(code) ((code) & 0x1000000)

#define COMBINING_CODE_CLASS(code) ((code) & 0xFFFFFF)

#define MAKE_PRECOMPUTED_COMBINDING_CODE() (0x2000000)

#define COMBINING_PRECOMPUTED_P(code) ((code) & 0x2000000)

extern MSymbol Mcombining;

#endif /* _M_INTERNAL_FLT_H */
