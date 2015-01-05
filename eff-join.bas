'eff header
TYPE EffHeader
frames AS INTEGER
xres AS INTEGER
yres AS INTEGER
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
DIM eff1Hdr AS EffHeader
DIM eff2Hdr AS EffHeader
CLS


'get eff files
PRINT "EFF-JOIN"
PRINT "--------"
PRINT
INPUT "Img-Effect file-1"; fsrc1$
fsrc1$ = addFileExt$(fsrc1$, ".eff")
INPUT "Img-Effect file-2"; fsrc2$
fsrc2$ = addFileExt$(fsrc2$, ".eff")


'get eff headers
OPEN "B", #1, fsrc1$
GET #1, , eff1Hdr
OPEN "B", #2, fsrc2$
GET #2, , eff2Hdr
CLOSE #1, #2

'check if valid
IF eff1Hdr.xres <> eff2Hdr.xres THEN throw "resolution does not match!"
IF eff1Hdr.yres <> eff2Hdr.yres THEN throw "resolution does not match!"

'get eff info
frames1% = eff1Hdr.frames
frames2% = eff2Hdr.frames
xres% = eff1Hdr.xres
yres% = eff1Hdr.yres
effDataOff& = 7

'get output file
INPUT "Output file"; fdst$
fdst$ = addFileExt$(fdst$, ".eff")

'save details to eff file
OPEN "B", #3, fdst$
frames% = frames1% + frames2%
PUT #3, , frames%
PUT #3, , xres%
PUT #3, , yres%

'init
SCREEN 13
getPalette
picPalette
DIM dclr AS STRING * 1
OPEN "B", #1, fsrc1$
OPEN "B", #2, fsrc2$
SEEK #1, effDataOff&
SEEK #2, effDataOff&

'merge and display frames
FOR fr% = 1 TO frames%

'get the rows
FOR y% = 0 TO yres% - 1

'get the columns
FOR x% = 0 TO xres% - 1

IF fr% <= frames1% THEN GET #1, , dclr ELSE GET #2, , dclr
clr% = ASC(dclr)

'write the pixel
PSET (x%, yres% - 1 - y%), clr%
PUT #3, , dclr

NEXT

NEXT

NEXT

'end
CLOSE #1, #2, #3
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

