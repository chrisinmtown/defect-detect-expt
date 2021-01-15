C     NOTE THAT YOU DO NOT NEED TO VERIFY THE FUNCTION 'MATCH'.
C     IT IS DESCRIBED THE FIRST TIME IT IS USED, AND ITS SOURCE CODE
C     IS INCLUDED AT THE END FOR COMPLETENESS.
C
C     NOTE THAT FORMAT STATEMENTS FOR WRITE STATEMENTS INCLUDE
C     A LEADING
C     AND REQUIR.ED ' ' FOR CARRIAGE CONTROL
      
C     VARIABLE USED IN FIRST, BUT NEEDS TO BE IMTIALIZED
C     INTEGER MOREIN

C     STORAGE USED BY GCHAR
      INTEGER BCOUNT
      CHARACTER*1 GBUFER(80)
      CHARACTER*80 GBUF
C     GBUFER AND GBUFSTR ARE EQLTNALENCED
      
C     STORAGE USED BY PCHAR
      INTEGER I
      CHARACTER*1 OUTLIN(31)
C     OUTLIN AND OUTLINST ARE EQUNALENCED
      
      CHARACTER*1 GCHAR
      
C     CONSTANT USED THROUGHOUT THE PROGRAM
      CHARACTER*1 EOTEXT, BLANK, LINEFD
      INTEGER MAXPOS
      
      COMMON /ALL/ MOREIN, BCOUNT, I, MAXPOS, OUTLIN,
     &     EOTEXT, BLANK, LINEFD, GBUFER, GBUF
      
      DATA EOTEXT, BLANK, LINEFD,
     &     MAXPOS / '/', ' ', '&', 31 /
      
      
      CALL FIRST
      END
      

      SUBROUTINE FIRST
      INTEGER K, FILL, BUFPOS
      CHARACTER*1 CW
      CHARACTER*1 BUFFER(31)

      INTEGER MOREIN, BCOUNT, I, MAXPOS
      CHARACTER*1 OUTLIN(31), GCHAR, EOTEXT, 
     &     BLANK, LINEFD, GBUFER(80)
      CHARACTER*80 GBUF

      COMMON /ALL/ MOREIN, BCOUNT, I,
     &     MAXPOS, OUTLIN, EOTEXT, BLANK, LINEFD, GBUFER, GBUF
      
      BUFPOS = 0
      FILL = 0
      CW  =  ' '
      
      MOREIN =1
      
      I = 1
      K = 1
      DO WHILE (K .LE. MAXPOS)
         OUTLIN(K) =  ' '
         K  =  K  + 1
      ENDDO

      BCOUNT =1
      K  = 1
      DO WHILE (K .LE. 80)
         GBUFER(K) = 'Z'
         K  =  K + 1
      ENDDO

      DO WHILE (MOREIN)
         CW = GCHAR()
         IF ((CW .EQ. BLANK) .OR. (CW .EQ. LINEFD)
     &        .OR. (CW .EQ. EOTEXT)) THEN
            IF (CW .EQ. EOTEXT)  THEN
               MOREIN = 0
            ENDIF
            IF ((FILL+1+BUFPOS) .LE. MAXXPOS)  THEN
               CALL PCHAR(BLANK)
               FILL = FILL + 1
            ELSE
               CALL PCHAR(LINEFD)
               FILL =0
            ENDIF
            K = 1
            DO WHILE (K .LE. BUFPOS)
               CALL PCHAR(BUFFER(K))
               K=K+1
            ENDDO
            FILL = FILL + BUFPOS
            BUFPOS = 0
         ELSE
            IF (BUFPOS .EQ. MAXPOS)  THEN
               WRITE(6,10)
 10            FORMAT(' ','***WORD TO LONG***')
               MOREIN =1
            ELSE
               BUFPOS = BUFPOS + 1
               BUFFER(BUFPOS) = CW
            ENDIF
         ENDIF
      ENDDO
      CALL PCHAR(LINEFD)
      END


      CHARACTER*1 FUNCTION GCHAR()
      INTEGER MATCH
      CHARACTER*80 GBUFSTR
      
      INTEGER MOREIN, BCOUNT, I, MAXPOS
      CHARACTER*1 OUTLIN(31), EOTEXT, BLANK, LINEFD, GBUFER(80)
      CHARACTER*80 GBUF
      COMMON /ALL/ MOREIN, BCOUNT, I, MAXPOS,
     &     OUTLIN, EOTEXT, BLANK, LINEFD, GBUFER, GBUF
      
      EQUIVALENCE (GBUFSTR,GBUFER)

      IF (GBUFER(1) .EQ. 'Z')  THEN
         READ(5,20) GBUF
 20      FORMAT(A80)
C     
C     MATCH(CARRAY,C) RETURNS 1 IF CHARACTER C IS IN
C     HARACTER ARRAY
C     CARRAY, RETURNS 0 OTHERWISE. ARSIZE IS THE SIZE OF CARRAY.
C     
         IF (MATCH(GBUF,EOTEXT) .EQ. 0)  THEN
            WRITE(6,30)
 30         FORMAT(' ','***NO END OF TEXT MAR.K***')
            GBUFER(2) = EOTEXT
         ELSE
C     GBUFER(1) = GBUF
            GBUFSTR = GBUF
         ENDIF
      ENDIF
      GCHAR = GBUFER(BCOUNT)
      BCOUNT = BCOUNT + 1
      END
      

      SUBROUTINE PCHAR (C)
      CHARACTER*1 C
      CHARACTER*31 SOUT, OUTLINST
      INTEGER K
      
      INTEGER MOREIN, BCOUNT, I, MAXPOS
      CHARACTER*1 OUTLIN(31), GCHAR, EOTEXT,
     &     BLANK, LINEFD, GBUFER(80)
      CHARACTER*80 GBUF
      COMMON /ALL/ MOREIN, BCOUNT, I, MAXPPOS,
     &     OUTLIN, EOTEXT, BLANK, LINEFD, GBUFER, GBUF

      EQUIVALENCE (OUTLINST,OUTLIN)

      IF (C .EQ. LINEFD)  THEN
         SOUT = OUTLINST
         WRITE(6,40) SOUT
 40      FORMAT(' ',A31)
         K = 1
         DOWHILE (K .LE. MAXPOS)
         OUTLIN(K) = ' '
         K  =  K + 1
      ENDDO
      I = 1
      ELSE
         OUTLIN(I) = C
         I=I+ 1
      ENDIF
      END





