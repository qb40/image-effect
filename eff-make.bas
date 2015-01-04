'procedure declaration
DECLARE FUNCTION crc (n%)
DECLARE FUNCTION nospc$ (s$)
DECLARE SUB setPalette ()
DECLARE FUNCTION addFileExt$ (file$, ext$)
DECLARE FUNCTION nearClr% (red%, green%, blue%)


'variable declaration
COMMON SHARED ClrPal() AS INTEGER


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


'color palette
'0-15    = same as default
'16-31   = shades black to white (16)
'32-55   = shades of brg..b
'56-79   = shades of light
'80-103  = shades of light
'104-127 = shades of dark
'128-151 = shades of dark
'152-175 = shades of dark


'basic init
OPTION BASE 0
ON ERROR GOTO errs
DIM ClrPal(256, 3) AS INTEGER
DIM bmpHdr AS BmpHeader
DIM pixel AS BmpPixel
null$ = CHR$(0)
setPalette


'main program
CLS
INPUT "Bitamp file"; fsrc$
fsrc$ = addFileExt$(fsrc$, ".bmp")
OPEN "B", #1, fsrc$
GET #1, , bmpHdr
CLOSE #1
xres% = bmpHdr.xres
yres% = bmpHdr.yres

INPUT "Output file"; fdst$
fdst$ = addFileExt$(fdst$, ".eff")
INPUT "Slides"; sldNum%
PRINT "1   - dark to bright"
PRINT "2   - bright to dark"
PRINT "3   - r1 way"
PRINT "3.5 - r2 way"
PRINT "4   - g1 way"
PRINT "4.5 - g2 way"
PRINT "5   - b1 way"
PRINT "5.5 - b2 way"
INPUT "Method"; method

OPEN "B", #2, fdst$
PUT #2, , sldNum%
'[bb] slides (+)

SEEK #2, 3
PUT #2, , xres%
PUT #2, , yres%

pdst& = 7
OPEN "B", #1, fsrc$
SCREEN 13
FOR sld% = 1 TO sldNum%
SELECT CASE method
CASE 1
rVal! = sld%
gVal! = sld%
bVal! = sld%
CASE 2
rVal! = sldNum% - sld%
gVal! = sldNum% - sld%
bVal! = sldNum% - sld%
CASE 3
rVal! = sld%
gVal! = 0
bVal! = 0
CASE 3.5
rVal! = sldNum% - sld%
gVal! = 0
bVal! = 0
CASE 4
rVal! = 0
gVal! = sld%
bVal! = 0
CASE 4.5
rVal! = 0
gVal! = sldNum% - sld%
bVal! = 0
CASE 5
rVal! = 0
gVal! = 0
bVal! = sld%
CASE 5.5
rVal! = 0
gVal! = 0
bVal! = sldNum% - sld%
CASE ELSE
END SELECT
rVal! = rVal! / sldNum%
gVal! = gVal! / sldNum%
bVal! = bVal! / sldNum%

CLS
psrc& = bmpHdr.dataOff + 1

FOR y% = 0 TO yres% - 1

SEEK #1, psrc&

FOR x% = 0 TO xres% - 1
GET #1, , pixel
psrc& = psrc& + 3
red% = INT(ASC(pixel.red) * rVal!)
green% = INT(ASC(pixel.green) * gVal!)
blue% = INT(ASC(pixel.green) * bVal!)
cl% = nearClr%(red%, green%, blue%)

x% = x% + 1
IF (x% >= xres%) THEN
x% = 0
pad% = (xres% * 3) MOD 4
IF pad% > 0 THEN psrc& = psrc& + (4 - pad%)
y% = y% + 1
END IF

PSET (x%, yres% - y%), cl%
wrt$ = CHR$(cl%)
PUT #2, pdst&, wrt$
pdst& = pdst& + 1
IF (y% < yy%) THEN GOTO cnt

NEXT

CLOSE #1

'check
PRINT "Check Output"
INPUT "Time gap"; t

OPEN "B", #3, fdst$
SEEK #3, 1
read$ = INPUT$(2, #3)
ss = ASC(LEFT$(read$, 1)) + ASC(RIGHT$(read$, 1))

SEEK #3, 3
read$ = INPUT$(2, #3)
xx = ASC(LEFT$(read$, 1)) + ASC(RIGHT$(read$, 1))
SEEK #3, 5
read$ = INPUT$(2, #3)
yy = ASC(LEFT$(read$, 1)) + ASC(RIGHT$(read$, 1))

CLS
SCREEN 13

FOR i = 1 TO ss
FOR y = yy TO 0 STEP -1
FOR x = 0 TO xx
cl = ASC(INPUT$(1, #3) + null$)
LINE (x, y)-(x, y), cl
NEXT
NEXT
SOUND 21000, t
NEXT

CLOSE #3
SYSTEM


' error handler
errs: RESUME NEXT

FUNCTION addFileExt$ (file$, ext$)
IF RIGHT$(file$, LEN(ext$)) = ext$ THEN addFileExt$ = file$ ELSE addFileExt$ = file$ + ext$
END FUNCTION

DEFLNG P
FUNCTION crc (n%)
IF (n% < 0) THEN crc = 0 ELSE crc = n%
END FUNCTION

DEFSNG P
FUNCTION nearClr% (r%, g%, b%)
SHARED ClrPal() AS INTEGER

'init
cl% = 0
min% = 1000

'find nearest color
FOR i% = 0 TO 255
del% = ABS(r% - ClrPal(i%, 1)) + ABS(g% - ClrPal(i%, 2)) + ABS(b% - ClrPal(i%, 3))

IF (del% < min%) THEN
min% = ddel%
cl% = i%
END IF

NEXT


nearClr% = cl%
END FUNCTION

DEFLNG P
FUNCTION nospc$ (in$)
ans$ = ""
FOR i = 1 TO LEN(in$)
c$ = MID$(in$, i, 1)
IF (c$ <> " ") THEN ans$ = ans$ + c$
NEXT
nospc$ = ans$
END FUNCTION

DEFSNG P
SUB setPalette
SHARED ClrPal() AS INTEGER

'0-7 standard colors
FOR i% = 0 TO 7
FOR j% = 0 TO 2
ClrPal(i%, j%) = 127 * (i% AND (2 ^ j%))
NEXT
NEXT

'8-15 extended colors
FOR i% = 0 TO 7
FOR j% = 0 TO 2
ClrPal(i% + 8, j%) = ClrPal(i%, j%) + 128
NEXT
NEXT

'8 is darker
ClrPal(8, 0) = 64
ClrPal(8, 1) = 64
ClrPal(8, 2) = 64

'16-31 black->white
FOR i% = 16 TO 31
FOR j% = 0 TO 2
ClrPal(i%, j%) = 10 + (15 * (i% - 16))
NEXT
NEXT

'32-35 blue->magenta
FOR i% = 32 TO 35
ClrPal(i%, 0) = (i% - 32) * 20
ClrPal(i%, 1) = 0
ClrPal(i%, 2) = 160
NEXT

'36-39 magenta->red
FOR i% = 36 TO 39
ClrPal(i%, 0) = 160
ClrPal(i%, 1) = 0
ClrPal(i%, 2) = (39 - i%) * 20
NEXT

'40-43 red->yellow
FOR i% = 40 TO 43
ClrPal(i%, 0) = 160
ClrPal(i%, 1) = (i% - 40) * 20
ClrPal(i%, 2) = 0
NEXT

'44-47 yellow->green
FOR i% = 44 TO 47
ClrPal(i%, 0) = (47 - i%) * 20
ClrPal(i%, 1) = 160
ClrPal(i%, 2) = 0
NEXT
FOR i = 48 TO 51  'g - c
ClrPal(i, 1) = 0
ClrPal(i, 2) = 160
ClrPal(i, 3) = (i - 48) * 20
NEXT
FOR i = 52 TO 55   'c - b
ClrPal(i, 1) = 0
ClrPal(i, 2) = (55 - i) * 20
ClrPal(i, 3) = 160
NEXT
'b shades
FOR i = 56 TO 79
FOR j = 1 TO 3
ClrPal(i, j) = ClrPal(i - 24, j) + 40
NEXT
NEXT
FOR i = 80 TO 103
FOR j = 1 TO 3
ClrPal(i, j) = ClrPal(i - 48, j) + 80
NEXT
NEXT

'd shades
FOR i = 104 TO 127
FOR j = 1 TO 3
ClrPal(i, j) = INT(ClrPal(i - 72, j) * .5)
NEXT
NEXT
FOR i = 128 TO 151
FOR j = 1 TO 3
ClrPal(i, j) = INT(ClrPal(i - 72, j) * .5)
NEXT
NEXT
FOR i = 152 TO 175
FOR j = 1 TO 3
ClrPal(i, j) = INT(ClrPal(i - 72, j) * .5)
NEXT
NEXT

'dd shades
FOR i = 176 TO 199
FOR j = 1 TO 3
ClrPal(i, j) = INT(ClrPal(i - 72, j) * .5)
NEXT
NEXT
FOR i = 200 TO 223
FOR j = 1 TO 3
ClrPal(i, j) = INT(ClrPal(i - 72, j) * .5)
NEXT
NEXT
FOR i = 224 TO 247
FOR j = 1 TO 3
ClrPal(i, j) = INT(ClrPal(i - 72, j) * .5)
NEXT
NEXT

END SUB

