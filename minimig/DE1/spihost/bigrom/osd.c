/*
Copyright 2005, 2006, 2007 Dennis van Weeren

This file is part of Minimig

Minimig is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

Minimig is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

This is the Minimig OSD (on-screen-display) handler.

29-12-2006		-created
30-12-2006		-improved and simplified

24-10-2007      -many changes for DE1 Port / TobiFlex
*/

#include "osd.h"
#include "hardware.h"

unsigned char c2;
unsigned short repeat;

/*character font*/
const unsigned char charfont[256][5]=
{
{0x00,0xfe,0x81,0xfe,0x00},         // 0 	[0x0]
{0x00,0xfe,0xc1,0xfe,0x00},         // 1 	[0x1]
{0x00,0xfe,0xe1,0xfe,0x00},         // 2 	[0x2]
{0x00,0xfe,0xf1,0xfe,0x00},         // 3 	[0x3]
{0x00,0xfe,0xf9,0xfe,0x00},         // 4 	[0x4]
{0x00,0xfe,0xfd,0xfe,0x00},         // 5 	[0x5]
{0x00,0xfe,0xff,0xfe,0x00},         // 6 	[0x6]
{0x18,0x1f,0xc1,0xf8,0x08},         // 7 	[0x7]
{0x18,0x42,0x3c,0x81,0x7e},         // 8 	[0x8]
{0x32,0x2a,0xe7,0x2a,0x32},         // 9 	[0x9]
{0xe2,0x51,0xe2,0x64,0x92},         // 10 	[0xa]
{0xf5,0x91,0x65,0x61,0x95},         // 11 	[0xb]
{0x5c,0x62,0x02,0x62,0x5c},         // 12 	[0xc]
{0xfa,0x00,0xf0,0x90,0xfe},         // 13 	[0xd]
{0x3e,0x3e,0x36,0x3e,0x3e},         // 14 	[0xe]
{0x38,0x44,0x44,0x28,0x28},         // 15 	[0xf]
{0x00,0xfe,0x7c,0x38,0x10},         // 16 	[0x10]
{0x10,0x38,0x7c,0xfe,0x00},         // 17 	[0x11]
{0x60,0xff,0xf9,0xdf,0x60},         // 18 	[0x12]
{0x0c,0x1f,0xfc,0x1f,0x0c},         // 19 	[0x13]
{0x88,0xcc,0xee,0xcc,0x88},         // 20 	[0x14]
{0x22,0x66,0xee,0x66,0x22},         // 21 	[0x15]
{0x38,0x7c,0x7c,0x7c,0x38},         // 22 	[0x16]
{0x20,0x70,0xa8,0x20,0x3e},         // 23 	[0x17]
{0x08,0x04,0xfe,0x04,0x08},         // 24 	[0x18]
{0x20,0x40,0xfe,0x40,0x20},         // 25 	[0x19]
{0x10,0x10,0x54,0x38,0x10},         // 26 	[0x1a]
{0x10,0x38,0x54,0x10,0x10},         // 27 	[0x1b]
{0x80,0x88,0x94,0xa2,0x80},         // 28 	[0x1c]
{0x80,0xa2,0x94,0x88,0x80},         // 29 	[0x1d]
{0x40,0x70,0x7c,0x70,0x40},         // 30 	[0x1e]
{0x04,0x1c,0x7c,0x1c,0x04},         // 31 	[0x1f]
{0x00,0x00,0x00,0x00,0x00},         // 32 	[0x20]
{0x00,0x00,0xbe,0x00,0x00},         // 33 	[0x21]
{0x00,0x0e,0x00,0x0e,0x00},         // 34 	[0x22]
{0x28,0xfe,0x28,0xfe,0x28},         // 35 	[0x23]
{0x48,0x54,0xfe,0x54,0x24},         // 36 	[0x24]
{0x46,0x26,0x10,0xc8,0xc4},         // 37 	[0x25]
{0x6c,0x92,0xaa,0x44,0xa0},         // 38 	[0x26]
{0x00,0x00,0x0a,0x06,0x00},         // 39 	[0x27]
{0x00,0x38,0x44,0x82,0x00},         // 40 	[0x28]
{0x00,0x82,0x44,0x38,0x00},         // 41 	[0x29]
{0x28,0x10,0x7c,0x10,0x28},         // 42 	[0x2a]
{0x10,0x10,0x7c,0x10,0x10},         // 43 	[0x2b]
{0x00,0xa0,0x60,0x00,0x00},         // 44 	[0x2c]
{0x10,0x10,0x10,0x10,0x10},         // 45 	[0x2d]
{0x00,0xc0,0xc0,0x00,0x00},         // 46 	[0x2e]
{0x40,0x20,0x10,0x08,0x04},         // 47 	[0x2f]
{0x7c,0xa2,0x92,0x8a,0x7c},         // 48 	[0x30]
{0x00,0x84,0xfe,0x80,0x00},         // 49 	[0x31]
{0x84,0xc2,0xa2,0x92,0x8c},         // 50 	[0x32]
{0x42,0x82,0x8a,0x96,0x62},         // 51 	[0x33]
{0x30,0x28,0x24,0xfe,0x20},         // 52 	[0x34]
{0x4e,0x8a,0x8a,0x8a,0x72},         // 53 	[0x35]
{0x78,0x94,0x92,0x92,0x60},         // 54 	[0x36]
{0x06,0x02,0xe2,0x12,0x0e},         // 55 	[0x37]
{0x6c,0x92,0x92,0x92,0x6c},         // 56 	[0x38]
{0x0c,0x92,0x92,0x52,0x3c},         // 57 	[0x39]
{0x00,0xcc,0xcc,0x00,0x00},         // 58 	[0x3a]
{0x00,0xac,0x6c,0x00,0x00},         // 59 	[0x3b]
{0x10,0x28,0x44,0x82,0x00},         // 60 	[0x3c]
{0x28,0x28,0x28,0x28,0x28},         // 61 	[0x3d]
{0x00,0x82,0x44,0x28,0x10},         // 62 	[0x3e]
{0x04,0x02,0xa2,0x12,0x0c},         // 63 	[0x3f]
{0x64,0x92,0xf2,0x82,0x7c},         // 64 	[0x40]
{0xf8,0x24,0x22,0x24,0xf8},         // 65 	[0x41]
{0xfe,0x92,0x92,0x92,0x6c},         // 66 	[0x42]
{0x7c,0x82,0x82,0x82,0x44},         // 67 	[0x43]
{0xfe,0x82,0x82,0x44,0x38},         // 68 	[0x44]
{0xfe,0x92,0x92,0x92,0x82},         // 69 	[0x45]
{0xfe,0x12,0x12,0x12,0x02},         // 70 	[0x46]
{0x7c,0x82,0x92,0x92,0xf4},         // 71 	[0x47]
{0xfe,0x10,0x10,0x10,0xfe},         // 72 	[0x48]
{0x00,0x82,0xfe,0x82,0x00},         // 73 	[0x49]
{0x40,0x80,0x82,0x7e,0x02},         // 74 	[0x4a]
{0xfe,0x10,0x28,0x44,0x82},         // 75 	[0x4b]
{0xfe,0x80,0x80,0x80,0x80},         // 76 	[0x4c]
{0xfe,0x04,0x18,0x04,0xfe},         // 77 	[0x4d]
{0xfe,0x08,0x10,0x20,0xfe},         // 78 	[0x4e]
{0x7c,0x82,0x82,0x82,0x7c},         // 79 	[0x4f]
{0xfe,0x12,0x12,0x12,0x0c},         // 80 	[0x50]
{0x7c,0x82,0xa2,0x42,0xbc},         // 81 	[0x51]
{0xfe,0x12,0x32,0x52,0x8c},         // 82 	[0x52]
{0x4c,0x92,0x92,0x92,0x64},         // 83 	[0x53]
{0x02,0x02,0xfe,0x02,0x02},         // 84 	[0x54]
{0x7e,0x80,0x80,0x80,0x7e},         // 85 	[0x55]
{0x3e,0x40,0x80,0x40,0x3e},         // 86 	[0x56]
{0xfe,0x40,0x30,0x40,0xfe},         // 87 	[0x57]
{0xc6,0x28,0x10,0x28,0xc6},         // 88 	[0x58]
{0x0e,0x10,0xe0,0x10,0x0e},         // 89 	[0x59]
{0xc2,0xa2,0x92,0x8a,0x86},         // 90 	[0x5a]
{0x00,0xfe,0x82,0x82,0x00},         // 91 	[0x5b]
{0x04,0x08,0x10,0x20,0x40},         // 92 	[0x5c]
{0x00,0x82,0x82,0xfe,0x00},         // 93 	[0x5d]
{0x08,0x04,0x02,0x04,0x08},         // 94 	[0x5e]
{0x80,0x80,0x80,0x80,0x80},         // 95 	[0x5f]
{0x00,0x02,0x04,0x08,0x00},         // 96 	[0x60]
{0x40,0xa8,0xa8,0xa8,0xf0},         // 97 	[0x61]
{0xfe,0x90,0x88,0x88,0x70},         // 98 	[0x62]
{0x70,0x88,0x88,0x88,0x40},         // 99 	[0x63]
{0x70,0x88,0x88,0x90,0xfe},         // 100 	[0x64]
{0x70,0xa8,0xa8,0xa8,0x30},         // 101 	[0x65]
{0x10,0xfc,0x12,0x02,0x04},         // 102 	[0x66]
{0x10,0xa8,0xa8,0xa8,0x78},         // 103 	[0x67]
{0xfe,0x10,0x08,0x08,0xf0},         // 104 	[0x68]
{0x00,0x90,0xfa,0x80,0x00},         // 105 	[0x69]
{0x40,0x80,0x88,0x7a,0x00},         // 106 	[0x6a]
{0x00,0xfe,0x20,0x50,0x88},         // 107 	[0x6b]
{0x00,0x82,0xfe,0x80,0x00},         // 108 	[0x6c]
{0xf8,0x08,0xf0,0x08,0xf8},         // 109 	[0x6d]
{0xf8,0x10,0x08,0x08,0xf0},         // 110 	[0x6e]
{0x70,0x88,0x88,0x88,0x70},         // 111 	[0x6f]
{0xf8,0x28,0x28,0x28,0x10},         // 112 	[0x70]
{0x08,0x14,0x14,0x18,0xfc},         // 113 	[0x71]
{0xf8,0x10,0x08,0x08,0x10},         // 114 	[0x72]
{0x90,0xa8,0xa8,0xa8,0x40},         // 115 	[0x73]
{0x08,0x7e,0x88,0x80,0x40},         // 116 	[0x74]
{0x78,0x80,0x80,0x40,0xf8},         // 117 	[0x75]
{0x38,0x40,0x80,0x40,0x38},         // 118 	[0x76]
{0x78,0x80,0x60,0x80,0x78},         // 119 	[0x77]
{0x88,0x50,0x20,0x50,0x88},         // 120 	[0x78]
{0x18,0xa0,0xa0,0xa0,0x78},         // 121 	[0x79]
{0x88,0xc8,0xa8,0x98,0x88},         // 122 	[0x7a]
{0x00,0x10,0x6c,0x82,0x00},         // 123 	[0x7b]
{0x00,0x00,0xfe,0x00,0x00},         // 124 	[0x7c]
{0x00,0x82,0x6c,0x10,0x00},         // 125 	[0x7d]
{0x04,0x02,0x04,0x08,0x04},         // 126 	[0x7e]
{0xf0,0x88,0x84,0x88,0xf0},         // 127 	[0x7f]
{0x00,0x00,0x00,0x00,0x00},         // 128 	[0x80]
{0xfe,0xff,0x33,0xff,0xfe},         // 129 	[0x81]
{0xff,0xff,0xdb,0xff,0x76},         // 130 	[0x82]
{0x7e,0xff,0xc3,0xc3,0xc3},         // 131 	[0x83]
{0xff,0xff,0xc3,0xff,0x7e},         // 132 	[0x84]
{0xff,0xff,0xdb,0xdb,0xc3},         // 133 	[0x85]
{0xff,0xff,0x1b,0x1b,0x03},         // 134 	[0x86]
{0x7e,0xff,0xd3,0xf7,0x76},         // 135 	[0x87]
{0xff,0xff,0x18,0xff,0xff},         // 136 	[0x88]
{0x00,0xff,0xff,0xff,0x00},         // 137 	[0x89]
{0x60,0xe0,0xc0,0xff,0x7f},         // 138 	[0x8a]
{0xff,0xff,0x3c,0xf7,0xe3},         // 139 	[0x8b]
{0xff,0xff,0xc0,0xc0,0xc0},         // 140 	[0x8c]
{0xff,0x07,0x1c,0x07,0xff},         // 141 	[0x8d]
{0xff,0x3f,0x7e,0xfc,0xff},         // 142 	[0x8e]
{0x7e,0xff,0xc3,0xff,0x7e},         // 143 	[0x8f]
{0xff,0xff,0x33,0x3f,0x1e},         // 144 	[0x90]
{0x7e,0xff,0xe3,0x7f,0xbe},         // 145 	[0x91]
{0xff,0xff,0x3b,0xef,0xc6},         // 146 	[0x92]
{0xce,0xdf,0xdb,0xfb,0x73},         // 147 	[0x93]
{0x03,0xff,0xff,0xff,0x03},         // 148 	[0x94]
{0x7f,0xff,0xc0,0xff,0x7f},         // 149 	[0x95]
{0x3f,0x7f,0xe0,0x7f,0x3f},         // 150 	[0x96]
{0xff,0xe0,0x38,0xe0,0xff},         // 151 	[0x97]
{0xc7,0xff,0x38,0xff,0xc7},         // 152 	[0x98]
{0x0f,0x1f,0xf0,0x1f,0x0f},         // 153 	[0x99]
{0xe3,0xf3,0xdb,0xcf,0xc7},         // 154 	[0x9a]
{0x00,0x00,0x00,0x00,0x00},         // 155 	[0x9b]
{0x00,0x00,0x00,0x00,0x00},         // 156 	[0x9c]
{0x00,0x00,0x00,0x00,0x00},         // 157 	[0x9d]
{0x00,0x00,0x00,0x00,0x00},         // 158 	[0x9e]
{0x00,0x00,0x00,0x00,0x00},         // 159 	[0x9f]
{0x00,0x00,0x00,0x00,0x00},         // 160 	[0xa0]
{0x00,0x00,0x00,0x00,0x00},         // 161 	[0xa1]
{0x00,0x00,0x00,0x00,0x00},         // 162 	[0xa2]
{0x00,0x00,0x00,0x00,0x00},         // 163 	[0xa3]
{0x00,0x00,0x00,0x00,0x00},         // 164 	[0xa4]
{0x00,0x00,0x00,0x00,0x00},         // 165 	[0xa5]
{0x00,0x00,0x00,0x00,0x00},         // 166 	[0xa6]
{0x00,0x00,0x00,0x00,0x00},         // 167 	[0xa7]
{0x00,0x00,0x00,0x00,0x00},         // 168 	[0xa8]
{0x00,0x00,0x00,0x00,0x00},         // 169 	[0xa9]
{0x00,0x00,0x00,0x00,0x00},         // 170 	[0xaa]
{0x00,0x00,0x00,0x00,0x00},         // 171 	[0xab]
{0x00,0x00,0x00,0x00,0x00},         // 172 	[0xac]
{0x00,0x00,0x00,0x00,0x00},         // 173 	[0xad]
{0x00,0x00,0x00,0x00,0x00},         // 174 	[0xae]
{0x00,0x00,0x00,0x00,0x00},         // 175 	[0xaf]
{0x00,0x00,0x00,0x00,0x00},         // 176 	[0xb0]
{0x00,0x00,0x00,0x00,0x00},         // 177 	[0xb1]
{0x00,0x00,0x00,0x00,0x00},         // 178 	[0xb2]
{0x00,0x00,0x00,0x00,0x00},         // 179 	[0xb3]
{0x00,0x00,0x00,0x00,0x00},         // 180 	[0xb4]
{0x00,0x00,0x00,0x00,0x00},         // 181 	[0xb5]
{0x00,0x00,0x00,0x00,0x00},         // 182 	[0xb6]
{0x00,0x00,0x00,0x00,0x00},         // 183 	[0xb7]
{0x00,0x00,0x00,0x00,0x00},         // 184 	[0xb8]
{0x00,0x00,0x00,0x00,0x00},         // 185 	[0xb9]
{0x00,0x00,0x00,0x00,0x00},         // 186 	[0xba]
{0x00,0x00,0x00,0x00,0x00},         // 187 	[0xbb]
{0x00,0x00,0x00,0x00,0x00},         // 188 	[0xbc]
{0x00,0x00,0x00,0x00,0x00},         // 189 	[0xbd]
{0x00,0x00,0x00,0x00,0x00},         // 190 	[0xbe]
{0x00,0x00,0x00,0x00,0x00},         // 191 	[0xbf]
{0x00,0x00,0x00,0x00,0x00},         // 192 	[0xc0]
{0x00,0x00,0x00,0x00,0x00},         // 193 	[0xc1]
{0x00,0x00,0x00,0x00,0x00},         // 194 	[0xc2]
{0x00,0x00,0x00,0x00,0x00},         // 195 	[0xc3]
{0x00,0x00,0x00,0x00,0x00},         // 196 	[0xc4]
{0x00,0x00,0x00,0x00,0x00},         // 197 	[0xc5]
{0x00,0x00,0x00,0x00,0x00},         // 198 	[0xc6]
{0x00,0x00,0x00,0x00,0x00},         // 199 	[0xc7]
{0x00,0x00,0x00,0x00,0x00},         // 200 	[0xc8]
{0x00,0x00,0x00,0x00,0x00},         // 201 	[0xc9]
{0x00,0x00,0x00,0x00,0x00},         // 202 	[0xca]
{0x00,0x00,0x00,0x00,0x00},         // 203 	[0xcb]
{0x00,0x00,0x00,0x00,0x00},         // 204 	[0xcc]
{0x00,0x00,0x00,0x00,0x00},         // 205 	[0xcd]
{0x00,0x00,0x00,0x00,0x00},         // 206 	[0xce]
{0x00,0x00,0x00,0x00,0x00},         // 207 	[0xcf]
{0x00,0x00,0x00,0x00,0x00},         // 208 	[0xd0]
{0x00,0x00,0x00,0x00,0x00},         // 209 	[0xd1]
{0x00,0x00,0x00,0x00,0x00},         // 210 	[0xd2]
{0x00,0x00,0x00,0x00,0x00},         // 211 	[0xd3]
{0x00,0x00,0x00,0x00,0x00},         // 212 	[0xd4]
{0x00,0x00,0x00,0x00,0x00},         // 213 	[0xd5]
{0x00,0x00,0x00,0x00,0x00},         // 214 	[0xd6]
{0x00,0x00,0x00,0x00,0x00},         // 215 	[0xd7]
{0x00,0x00,0x00,0x00,0x00},         // 216 	[0xd8]
{0x00,0x00,0x00,0x00,0x00},         // 217 	[0xd9]
{0x00,0x00,0x00,0x00,0x00},         // 218 	[0xda]
{0x00,0x00,0x00,0x00,0x00},         // 219 	[0xdb]
{0x00,0x00,0x00,0x00,0x00},         // 220 	[0xdc]
{0x00,0x00,0x00,0x00,0x00},         // 221 	[0xdd]
{0x00,0x00,0x00,0x00,0x00},         // 222 	[0xde]
{0x00,0x00,0x00,0x00,0x00},         // 223 	[0xdf]
{0x00,0x00,0x00,0x00,0x00},         // 224 	[0xe0]
{0x00,0x00,0x00,0x00,0x00},         // 225 	[0xe1]
{0x00,0x00,0x00,0x00,0x00},         // 226 	[0xe2]
{0x00,0x00,0x00,0x00,0x00},         // 227 	[0xe3]
{0x00,0x00,0x00,0x00,0x00},         // 228 	[0xe4]
{0x00,0x00,0x00,0x00,0x00},         // 229 	[0xe5]
{0x00,0x00,0x00,0x00,0x00},         // 230 	[0xe6]
{0x00,0x00,0x00,0x00,0x00},         // 231 	[0xe7]
{0x00,0x00,0x00,0x00,0x00},         // 232 	[0xe8]
{0x04,0x54,0x50,0x14,0x44},         // 233 	[0xe9]
{0x00,0x00,0x00,0x00,0x00},         // 234 	[0xea]
{0x00,0x00,0x00,0x00,0x00},         // 235 	[0xeb]
{0x10,0x22,0x10,0x22,0x10},         // 236 	[0xec]
{0x10,0x22,0x20,0x22,0x10},         // 237 	[0xed]
{0x20,0x22,0x20,0x22,0x20},         // 238 	[0xee]
{0x40,0x22,0x20,0x22,0x40},         // 239 	[0xef]
{0x00,0x00,0x00,0x00,0x00},         // 240 	[0xf0]
{0x00,0x00,0x00,0x00,0x00},         // 241 	[0xf1]
{0x00,0x00,0x00,0x00,0x00},         // 242 	[0xf2]
{0x00,0x00,0x00,0x00,0x00},         // 243 	[0xf3]
{0x00,0x00,0x00,0x00,0x00},         // 244 	[0xf4]
{0x00,0x00,0x00,0x00,0x00},         // 245 	[0xf5]
{0x00,0x00,0x00,0x00,0x00},         // 246 	[0xf6]
{0x00,0x00,0x00,0x00,0x00},         // 247 	[0xf7]
{0x00,0x00,0x00,0x00,0x00},         // 248 	[0xf8]
{0xfe,0x7b,0xff,0x7b,0xfe},         // 249 	[0xf9]
{0xfe,0x7a,0xfe,0x7a,0xfe},         // 250 	[0xfa]
{0xfc,0x78,0xfc,0x78,0xfc},         // 251 	[0xfb]
{0xf8,0x78,0xf8,0x78,0xf8},         // 252 	[0xfc]
{0xf0,0x70,0xf0,0x70,0xf0},         // 253 	[0xfd]
{0xe0,0x60,0xe0,0x60,0xe0},         // 254 	[0xfe]
{0xc0,0x40,0xc0,0x40,0xc0}          // 255 	[0xff]
};

/*some constants*/
#define OSDNLINE		8			/*number of lines of OSD*/
#define	OSDLINELEN		128			/*single line length in bytes*/
#define	OSDCMDREAD		0x00		//OSD read controller/key status
#define	OSDCMDWRITE		0x20		//OSD write video data command
#define	OSDCMDENABLE	0x60		//OSD enable command
#define	OSDCMDDISABLE	0x40		//OSD disable command
#define	OSDCMDRESET		0x80		//OSD reset command
#define REPEATTIME		50			/*repeat delay in 10ms units*/
#define REPEATRATE		5			/*repeat rate in 10ms units*/


/*write a null-terminated string <s> to the OSD buffer starting at line <n>*/
void OsdWrite(unsigned char n,const unsigned char *s)
{
	unsigned char b;
	const unsigned char *p;
	
	/*select OSD SPI device*/
	EnableOsd();

	/*select buffer and line to write to*/
	SPIOSD((char)(OSDCMDWRITE|n));

	/*send all characters in string to OSD*/
	while(1)
	{
		b=*(s++);
		
		if(b==0)/*end of string*/
			break;
		else if(b==0x0d || b==0x0a)//cariage return / linefeed, go to next line
		{
			/*increment line counter*/
			if(++n>=OSDNLINE)
				n=0;
			/*send new line number to OSD*/	
			DisableOsd();
			EnableOsd();
			SPIOSD((char)(OSDCMDWRITE|n));
		}
		else/*normal character*/
		{
			SPIOSD(0x00);
			p=&charfont[b][0];
			SPIOSD(*(p++));	
			SPIOSD(*(p++));	
			SPIOSD(*(p++));	
			SPIOSD(*(p++));	
			SPIOSD(*(p++));
		}
	}
	/*deselect OSD SPI device*/
	DisableOsd();
}
	
/*clear buffer <c>*/
void OsdClear(void)
{
	unsigned short n;
	
	/*select OSD SPI device*/
	EnableOsd();
	
	/*select buffer to write to*/
	SPIOSD(OSDCMDWRITE);
	
	/*clear buffer*/
	for(n=0;n<(OSDLINELEN*OSDNLINE);n++)
		SPIOSD(0x00);
		
	/*deselect OSD SPI device*/
	DisableOsd();
}

/*enable displaying of OSD*/
void OsdEnable(void)
{
	/*send command*/
	EnableOsd();
	SPIOSD(OSDCMDENABLE);
	DisableOsd();
}

/*disable displaying of OSD*/
void OsdDisable(void)
{
	/*send command*/
	EnableOsd();
	SPIOSD(OSDCMDDISABLE);
	DisableOsd();
}

/*get key status*/
unsigned char OsdGetCtrl(void)
{
//	static unsigned char c2;
//	static unsigned short repeat;
	unsigned char c1,c;

	/*send command and get current ctrl status*/
	EnableOsd();
	c1=SPIOSD(OSDCMDREAD);
	DisableOsd();
	c1|=OsdGetKey();
	
	/*add front menu button*/
//	if(CheckButton())
//		c1|=OSDCTRLMENU;	

	/*generate normal "key-pressed" event*/
	c=c1&(~c2);
	c2=c1;
	
	/*generate repeat "key-pressed" events
	do not for menu button*/
	if(!c1)
		repeat=GetTimer(REPEATTIME);
	else if(CheckTimer(repeat))
	{
		repeat=GetTimer(REPEATRATE);
//		c=c1&(~OSDCTRLMENU);
	}
	
	/*return events*/
	return(c);	
}
	
	
