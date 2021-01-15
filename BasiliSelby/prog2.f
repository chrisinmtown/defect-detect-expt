      PROGRAM PROG2

C     External Functions

      INTEGER SLASH, MAXELE, MINELE


      PARAMETER(WIDTH = 30,
     &     HEIGHT = 20,
     &     GRIDWD = 61,
     &     LARGENUM = 100000000,
     &     TICKS =
     $ "|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|")
C
C      

      CHARACTER GRID(61)
      CHARACTER STR*61
      INTEGER XVAL(100), YVAL(100)
      INTEGER I, J, NUMOBS, MAXY, MAXX, MINX, HORISP, VERTSP, VLINE

      I = 0
      DO WHILE ( .NOT. EOI )
         READ(*,*) XVAL(I),YVAL(I)
         I = I + 1
      ENDDO
      
      NUMOBS = I

      CALL SORT(YVAL,XVAL,NUMOBS)
      MAXY = YVAL(0)
      VERTSP = SLASH(MAXY,HEIGHT)

      MAXX = XVAL(MAXELE(XVAL,NUMOBS))
      NINX = XVAL(MINELE(XVAL,NUMOBS))
      IF (ABS(MINX) .GT. ABS(MAXX)) THEN
         HORISP = SLASH(ABS(MINX),WIDTH)
      ELSE
         HORISP = SLASH(ABS(MAXX),WIDTH)
      END IF

      STR = '                     X AXIS'
      WRITE (*,*) STR,SKIP
      I = 0
      VLINE = HEIGHT

      DO WHILE (VLINE .GT. 0)
         J = 0
         IF (MOD(VLINE,5) .EQ. 0) THEN
            CALL UNPACK(TICKS,GRID)
         ELSE
            DO WHILE (J .LT. GRIDWD)
               GRID(J) = " "
               J = J + 1
            ENDDO
         END IF

         VLINE = VLINE - 1

         DO WHILE (VLINE*VERTSP .LT. YVAL(I))
            IF (XVAL(I) .GE. 0) THEN
               GRID(WIDTH + SLASH(XVAL(I),HORISP)) = "*"
            ELSE
               GRID(WIDTH - SLASH(-XVAL(I),HORISP)) = "*"
            END IF
            I = I + 1
         ENDDO
         GRID(WIDTH) = "|"
         CALL PACK(GRID,STR)
         WRITE(*,*) STR,SKIP
      ENDDO

      STR =
     $ "|----|----|----|----|----|----|----|----|----|----|----|----|"

      CALL UNPACK (STR,GRID)
      DO WHILE ((0 .LT. YVAL(I)) .AND. (I .LT. NUMOBS))
         IF (XVAL(I) .GE. 0) THEN
            GRID(WIDTH + SLASH(XVAL(I),HORISP)) = "*"
         ELSE
            GRID(WIDTH - SLASH(-XVAL(I),HORISP)) = "*"
         END IF
         I = I + 1
      ENDDO

      CALL PACK(GRID,STR)
      WRITE(*,*) STR,SKIP
      STR = "                            Y AXIS"
      WRITE(*,*) STR,SKIP

      END
* Program


      SUBROUTINE SORT (KEYBUF,FREEBUF,N)

      INTEGER KEYBUF(*)
      INTEGER FREEBUF(*)
      INTEGER N

      INTEGER I, MAXP
      INTEGER SRTKEYB(100), SRTFREEB(100)


      I = 0
      DO WHILE (I .LT. N)
         SRTKEYB(I)  = KEYBUF(I)
         SRTFREEB(I) = FREEBUF(I)
         I = I + 1
      ENDDO

      I = N
      
      DO WHILE (I .GT. 0)
         MAXP         = MAXELE(SRTKEYB,I)
         KEYBUF(N-I)  = SRTKEYB(MAXP)
         FREEBUF(N-I) = SRTFREEB(MAXP)
         CALL REMOVE(SRTKEYB,MAXP,I)
         CALL REMOVE(SRTFREEB,MAXP,I)
         I = I - 1
      ENDDO

      END
*     SORT


      INTEGER FUNCTION MAXELE (BUF,N)

      INTEGER BUF(*)
      INTEGER N

      PARAMETER(WIDTH = 30,
     &     HEIGHT = 20,
     &     GRIDWD = 61,
     &     LARGENUM = 100000000,
     &     TICKS =
     $ "|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|")

      INTEGER I, MAXPTR, MAX


      MAXPTR = -1
      MAX    = -LARGENUM
      I      = 0
      DO WHILE (I .LT. N)
         IF (BUF(I) .GT. MAX) THEN
            MAX = BUF(I)
            MAXPTR = I
         END IF
         I= I + 1
      ENDDO
      MAXELE = MAXPTR
      END
*     MAXELE


      INTEGER FUNCTION MINELE (BUF,N)

      INTEGER BUF(*)
      INTEGER N

      PARAMETER(WIDTH = 30,
     &     HEIGHT = 20,
     &     GRIDWD = 61,
     &     LARGENUM = 100000000,
     &     TICKS =
     $ "|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|-  -|")

      INTEGER I, MINPTR, MIN

      MINPTR = -1
      MIN = LARGENUM
      I = 0
      DO WHILE (I .LT. N)
        IF (BUF(I) .LT. MIN) THEN
           MIN = BUF(I)
           MINPTR = I
        END IF
        I = I + 1
      ENDDO
      MINELE = MINPTR
      END
*     MINELE


      SUBROUTINE REMOVE (BUF,PTR,N)

      INTEGER BUF(*)
      INTEGER PTR
      INTEGER N

      INTEGER I

      I = PTR
      DO WHILE (I .LT. N-1)
         BUF(I) = BUF(I+1)
         I = I + 1
      ENDDO
      END
*     REMOVE



      INTEGER FUNCTION ABS (VAL)

      INTEGER VAL

      IF (VAL .LT. 0) THEN
         ABS = -VAL
      ELSE
         ABS = VAL
      END IF
      END
*     ABS



      INTEGER FUNCTION SLASH (TOP,BOT)

      INTEGER TOP
      INTEGER BOT

      INTEGER RES

      RES = TOP/BOT
      IF ((TOP .NE. RES*BOT) .AND. (TOP .GT. 0) .AND. (BOT .GT. 0)
     $     .OR. ((TOP .LT. 0) .AND. (BOT .GT. 0))) THEN
         RES = RES + 1
      END IF
      SLASH = RES
      END
*     SLASH



      INTEGER FUNCTION MOD (N,M)

      INTEGER N,M

      INTEGER VAL

      VAL = N-N/M*M
      IF (VAL .LT. 0) THEN
         VAL = VAL + M
      END IF
      MOD = VAL
      END
*     MOD

