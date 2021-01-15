C     NOTE THAT YOU DO NOT NEED TO VERIFY THE FUNCTIONS
C     DRIVER, GETARG,
C     CHAREQ, CODE, AND PRINT. THEIR SOURCE CODE IS
C     DESCRIBED AND
C     INCLUDED AT THE END FOR COMPLETENESS.
C     NOTE THAT FORMAT STATEMENTS FOR WRITE STATEMENTS
C     INCLUDE A LEADING
C     AND REQUIRED ' ' FOR CARRIAGE CONTROL
C
      INTEGER POOL(7), LSTEND
      INTEGER LISTSZ
C
      COMMON /ALL/ LISTSZ
C
C
      LISTSZ = 5
      CALL DRIVER (POOL, LSTEND)
      STOP
      END
C
C     
      FUNCTION ADFRST (POOL, LSTEND, I)
      INTEGER ADFRST
      INTEGER POOL(7), LSTEND, I
      INTEGER LISTSZ
      COMMON /ALL/ LISTSZ
C     
      INTEGER A
C     
      IF (LSTEND .GT. LISTSZ) THEN
         LSTEND = LISTSZ -1
      ENDIF
      LSTEND = LSTEND + 1
      A = LSTEND
      DO WHILE (A .GE.1)
         POOL(A+1) = POOL(A)
         A = A - 1
      ENDDO
C     
      POOL(1) = I
      ADFRST = LSTEND
      RETURN
      END
C     
C     
      FUNCTION ADLAST (POOL, LSTEND, I)
      INTEGER ADLAST
      INTEGER POOL(7), LSTEND, I
      INTEGER LISTSZ
      COMMON /ALL/ LISTSZ
C     
      IF (LSTEND .LE. LISTSZ) THEN
         LSTEND = LSTEND + 1
         POOL(LSTEND) = I
      ENDIF
      ADLAST = LSTEND
      RETURN
      END
C     
C     
      FUNCTION DELFST (POOL, LSTEND)
      INTEGER DELFST
      INTEGER POOL(7), LSTEND
      INTEGER LISTSZ
      COMMON /ALL/ LISTSZ
C     
      INTEGER A
      IF (LSTEND .GT.1) THEN
         A  = 1
         LSTEND = LSTEND -1
         DO WHILE (A .LE. LSTEND)
            POOL(A) = POOL(A+1)
            A = A -t- 1
         ENDDO
      ENDIF
      DELFST = LSTEND
      RETURN
      END
C     
C     
      FUNCTION DELLST (LSTEND)
      INTEGER DELLST
      INTEGER LSTEND
C     
      IF (LSTEND .GE. 1) THEN
         LSTEND = LSTEND - 1
      ENDIF
      DELLST = LSTEND
      RETURN
      END
C
C
       FUNCTION FIRST (POOL, LSTEND)
       INTEGER FIRST
       INTEGER POOL(7), LSTEND
C
       IF (LSTEND .LE. 1) THEN
            FIRST = 0
          ELSE
            FIRST = POOL(1)
       ENDIF
       RETURN
       END
C
C
       FUNCTION EMPTY (LSTEND)
       INTEGER EMPTY
       INTEGER LSTEND
C
       IF (LSTEND .LE. 1) THEN
            EMPTY = 1
          ELSE
             EMPTY = 0
       ENDIF
       RETURN
       END
C
C
       FUNCTION LSTLEN  (LSTEND)
       INTEGER LSTLEN
       INTEGER LSTEND
C
       LSTLEN = LSTEND -1
       RETURN
       END
C
C
       FUNCTION NEWLST (LSTEND)
       INTEGER NEWLST
       INTEGER LSTEND
C
       NEWLST = 0
       RETURN
       END
C
C
      SUBROUTINE REVERS (POOL, LSTEND)
      INTEGER POOL(7), LSTEND
C
      INTEGER I, N
C     
      N = LSTEND
      I = 1
      DO WHILE (I .LE. N)
           POOL(I) = POOL(N)
           N=N-1
           I = I + 1
      ENDDO
      RETURN
      END

