'bmp header
TYPE BmpHeader
id AS STRING * 2
bmpSize AS LONG
res1 AS INTEGER
res2 AS INTEGER
dataOff AS LONG
hdrSize AS LONG
xres AS LONG
yres AS LONG
planes AS INTEGER
pixSize AS INTEGER
packed AS LONG
dataSize AS LONG
viewx AS LONG
viewy AS LONG
numClr AS LONG
impClr AS LONG
END TYPE


'bmp pixel
TYPE BmpPixel
r AS STRING * 1
g AS STRING * 1
b AS STRING * 1
END TYPE

'float pixel
TYPE FloatPixel
r AS SINGLE
g AS SINGLE
b AS SINGLE
END TYPE

'int pixel
TYPE IntPixel
r AS INTEGER
g AS INTEGER
b AS INTEGER
END TYPE


'global variable
COMMON SHARED ClrPal() AS IntPixel


'procedure declaration
DECLARE SUB throw (msg$)
DECLARE SUB picPalette ()
DECLARE SUB getPalette ()
DECLARE SUB defPalette ()
DECLARE FUNCTION bmpRowSize& (xres&)
DECLARE FUNCTION addFileExt$ (file$, ext$)
DECLARE FUNCTION paletteClr% (pix AS IntPixel)
DECLARE SUB colorLevel (lvl AS FloatPixel, method$, frames%, fr%)


'basic init
OPTION BASE 0
ON ERROR GOTO errs
DIM ClrPal(256) AS IntPixel
DIM bmpHdr AS BmpHeader
DIM pixel AS BmpPixel
null$ = CHR$(0)
CLS


'get bmp file
INPUT "Bitamp file"; fsrc$
fsrc$ = addFileExt$(fsrc$, ".bmp")

'get bmp header
OPEN "B", #1, fsrc$
GET #1, , bmpHdr
CLOSE #1

'check if valid
IF bmpHdr.id <> "BM" THEN throw "not a bitmap file!"
IF bmpHdr.planes <> 1 THEN throw "multi-plane bitmap not supported"
IF bmpHdr.pixSize <> 24 THEN throw "only 24-bit bitmap is supported"

'get bmp info
xres% = bmpHdr.xres
yres% = bmpHdr.yres
bmpDataOff& = bmpHdr.dataOff + 1

'get output file
INPUT "Output file"; fdst$
fdst$ = addFileExt$(fdst$, ".eff")

'get effect info
INPUT "Frames"; frames%
PRINT "db - Dark to Bright"
PRINT "bd - Bright to Dark"
PRINT "r1 - Red Shift 1"
PRINT "r2 - Red Shift 2"
PRINT "g1 - Green Shift 1"
PRINT "g2 - Green Shift 2"
PRINT "b1 - Blue Shift 1"
PRINT "b2 - Blue Shift 2"
INPUT "Method"; method$

'save details to eff file
OPEN "B", #2, fdst$
PUT #2, , frames%
PUT #2, , xres%
PUT #2, , yres%

'init
SCREEN 13
getPalette
picPalette
DIM spix AS BmpPixel
DIM dpix AS IntPixel
DIM lvl AS FloatPixel
DIM dclr AS STRING * 1
OPEN "B", #1, fsrc$

'generate frames
FOR fr% = 1 TO frames%
colorLevel lvl, method$, frames%, fr%
psrc& = bmpHdr.dataOff + 1

'get the rows
FOR y% = 0 TO yres% - 1
SEEK #1, psrc&
psrc& = psrc& + bmpRowSize&(bmpHdr.xres)

'get the columns
FOR x% = 0 TO xres% - 1
GET #1, , spix
dpix.r = INT(ASC(spix.r) * lvl.r)
dpix.g = INT(ASC(spix.g) * lvl.g)
dpix.b = INT(ASC(spix.b) * lvl.b)
clr% = paletteClr%(dpix)

'write the pixel
PSET (x%, yres% - 1 - y%), clr%
dclr = CHR$(clr%)
PUT #2, , dclr

NEXT

NEXT

NEXT

'end
CLOSE #1, #2
SCREEN 1
defPalette
PRINT "Press a key to exit"
k$ = INPUT$(1)
SYSTEM


' error handler
errs:
throw "Unknown!"
RESUME NEXT

FUNCTION addFileExt$ (file$, ext$)
IF RIGHT$(file$, LEN(ext$)) = ext$ THEN addFileExt$ = file$ ELSE addFileExt$ = file$ + ext$
END FUNCTION

FUNCTION bmpRowSize& (xres&)
ans& = 3 * xres&
occupy& = ans& MOD 4
IF occupy& > 0 THEN occupy& = 4 - occupy&
bmpRowSize& = ans& + occupy&
END FUNCTION

SUB colorLevel (lvl AS FloatPixel, method$, frames%, fr%)

SELECT CASE method$
CASE "db"
lvl.r = fr%
lvl.g = fr%
lvl.b = fr%
CASE "bd"
lvl.r = frames% - fr%
lvl.g = frames% - fr%
lvl.b = frames% - fr%
CASE "r1"
lvl.r = fr%
lvl.g = 0
lvl.b = 0
CASE "r2"
lvl.r = frames% - fr%
lvl.g = 0
lvl.b = 0
CASE "g1"
lvl.r = 0
lvl.g = fr%
lvl.b = 0
CASE "g2"
lvl.r = 0
lvl.g = frames% - fr%
lvl.b = 0
CASE "b1"
lvl.r = 0
lvl.g = 0
lvl.b = fr%
CASE "b2"
lvl.r = 0
lvl.g = 0
lvl.b = frames% - fr%
CASE ELSE
END SELECT
lvl.r = lvl.r / frames%
lvl.g = lvl.g / frames%
lvl.b = lvl.b / frames%

END SUB

SUB defPalette
SHARED ClrPal() AS IntPixel

OUT &H3C8, 0
FOR clr% = 0 TO 255
OUT &H3C9, ClrPal(clr%).r
OUT &H3C9, ClrPal(clr%).g
OUT &H3C9, ClrPal(clr%).b
NEXT

END SUB

SUB getPalette
SHARED ClrPal() AS IntPixel

FOR clr% = 0 TO 255
OUT &H3C7, clr%
ClrPal(clr%).r = INP(&H3C9)
ClrPal(clr%).g = INP(&H3C9)
ClrPal(clr%).b = INP(&H3C9)
NEXT

END SUB

FUNCTION paletteClr% (pix AS IntPixel)

r% = pix.r \ 64
g% = pix.g \ 32
b% = pix.b \ 32
paletteClr% = r% * 64 + g% * 8 + b%

END FUNCTION

SUB picPalette

'color palette = rrgggbbb
OUT &H3C8, 0
FOR clr% = 0 TO 255
OUT &H3C9, (clr% \ 64) * 16        'red
OUT &H3C9, ((clr% \ 8) AND 7) * 8  'green
OUT &H3C9, (clr% AND 7) * 8        'blue
NEXT

END SUB

SUB throw (msg$)

SCREEN 1
defPalette
COLOR 15
PRINT "ERROR: "; msg$
PRINT "Press any key to exit ..."
k$ = INPUT$(1)
SYSTEM

END SUB

