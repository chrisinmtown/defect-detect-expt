C NOTE TI-iAT YOU DO NOT NEED TO VERIFY THE ROUTINES
C      DRIVER, STREQ, WORDEQ,
C  NXTSTR, ARRCPY, CHARPT, BEFORE, CHAREQ, AND WRDBEF.
C       THEIR SOURCE
C  CODE IS DESCRIBED AND INCLUDED AT THE END FOR
C       COMPLETENESS.
C NOTE THAT FORMAT STATEMENTS FOR WRITE STATEMENTS
C       INCLUDE A LEADING
C   AND REQUIRED ' ' FOR CARRIAGE CONTROL
C THE SFORT LANGUAGE CONSTRUCT '.IF (EXPRESSION)' BEGINS
C       A BLOCKED
C  IF-THEN[-ELSE] STATEMENT, AND IT IS EQUNALENT TO
C       THE F77
C  'IF (EXPRESSION) THEN'.
C
      CALL DRIVER
      STOP
      END
C
C
      SUBROUTINE MAINSB
C
      LOGICAL*1 U$KEY(3),U$AUTH(11),U$TITL(58),U$YEAR(2),U$ACTN(1)
      LOGICAL*1 M$KEY(3),M$AUTH(11),M$TITL(58),M$YEAR(2)
      LOGICAL*1 ZZZ(3), LASTUK(3), LASTMK(3)
      LOGICAL*1 STREQ, CHAREQ, BEFORE, CHARPT
      INTEGER I
C
      LOGICAL*1 WORD(500,12), REFKEY(1000,3)
      INTEGER NUMWDS, NUMREF, PTR(500), NEXT(1000)
      COMMON /WORDS/ WORD, REFKEY, NUMWDS, NUMREF, PTR, NEXT
C
      WRITE(6,290)
 290  FORMAT(' ','        UPDATED LIST OF MASTER ENTRIES')
      DO 300 I = 1, 3
         LASTMK(I) = CHARPT(' ')
         LASTUK(I) = CHARPT(' ')
         ZZZ(I) = CHARPT('Z')
 300  CONTINUE
C     
      NLIMWDS = 0
      TIITNIREF = 0
      CALL GETNM(M$KEY,M$AUTH,M$TITL,M$YEAR,LASTMK)
      CALL GETNUP(U$KEY,U$AUTH,U$TITL,U$YFAR,U$ACTN,LASTUK)
C     
      DO WHILE ((.NOT.(STREQ(M$KEY,ZZZ,3)))
     &     .OR. (.NOT.(STREQ(U$KEY,ZZZ,3))))
      
         IF ( STREQ(U$KEY,M$KEY,3 ) ) THEN
            IF (.NOT.(CHAREQ(U$ACTN(1),'R'))) THEN
               WRITE(6,l00) U$KEY
 100           FORMAT(' ','KEY ',3A1,' IS ALREADY IN FILE')
            ENDIF
            CALL OUTPUT(U$KEY,U$AUTH,U$TITL,U$YEAR)
            CALL DICTUP(U$KEY,U$TITL,58)
            CALL GETNM(M$KEY,M$AUTH,M$TITL,M$YEAR,LASTMK)
            CALL GETNUP(U$KEY,U$AUTH,U$TITL,U$YEAR,U$ACTN,LASTUK)
         ENDIF
C     
         IF (BEFORE(M$KEY,3,U$KEY,3)) THEN
            CALL OUTPUT(M$KEY,M$AUTH,M$TITL,M$YEAR)
            CALL DICTUP(M$KEY,M$TITL,58)
            CALL GETNM(M$KEY,M$AUTH,M$TITL,M$YEAR,LASTMK)
         ENDIF
C
         IF (BEFORE(U$KEY,3,M$KEY,3)) THEN
            IF (CHAREQ(U$ACTN(1),'R')) THEN
               WRITE(6,110) U$KEY
 110           FORMAT(' ','UPDATE KEY ',3A1,' NOT FOUND')
            ENDIF
            CALL OUTPUT(U$KEY,U$AUTH,U$TITL,U$YEAR)
            CALL DICTUP(U$KEY,U$TITL,58)
            CALL GETNUP(U$KEY,U$AUTH,U$TITL,U$YEAR,U$ACTN,LASTUK)
         ENDIF
      ENDDO
C
      CALL SRTWDS
      CALL PRTWDS
      RETURN
      END
C
C     
      SUBROUTINE GETNM(KEY,AUTH,TITL,YEAR,LASTMK)
      LOGICAL*1 KEY(3),AUTH(11),TITL(58),YEAR(2),LASTMK(3)
C
      LOGICAL*1 SEQ, INLINE(80)
      LOGICAL*1 BEFORE, CHARPT, CHAREQ
      LOGICAL*1 GO$M, GO$U
      COMMON /DRN/ GO$M, GO$U
C     
      SEQ = 1
      DO WHILE (SEQ)
         IF (GO$M) THEN
C     
C READ FROM THE MASTER FILE
C     
            READ(10,200,END=299) INLINE
         ELSE
C
C SEE REMARK ABOUT THE CHARACTER '%' LATER IN THE ROUTINE.
C     
            INLINE(1) = CHARPT('%')
         ENDIF
 200     FORMAT(80A1)
         DO 210 I = 1, 3
            KEY(I) = INLIINE(I)
 210     CONTINUE
         DO 220 I = 1, 11
            AUTH(I) = INLINE(3+I)
 220     CONTINUE
         DO 230 I = 1, 58
            TITL(I) = INLINE(14+I)
 230     CONTINUE
         DO 240 I = 1, 2
            YEAR(I) = INLINE(72+I)
 240     CONTINUE
C
C A METHOD OF SPECIFYING END-OF-FILE IN A FILE IS TO PUT
C     THE CHAR.ACTER '%'
C     AS THE FIRST CHARACTER ON A LINE.  THE DRIVER USES THIS
C         FOR MULTIPLE
C     SETS OF INPUT CASES.
C     
         IF ((.NOT.(CHAREQ(KEY(1),'%'))) .AND.
     &        (BEFORE(KEY,3,LASTMK,3)) ) THEN
            WRITE(6,250) KEY
 250        FORMAT(' ','KEY ',3A1,' OUT OF SEQUENCE')
         ELSE
            CALL ARRCPY(KEY,LASTMK,3)
            SEQ = 0
         ENDIF
         IF (CHAREQ(KEY(1),'%')) THEN
            SEQ = 0
            DO 270 I = 1, 3
               KEY(I) = CHARPT('Z')
 270        CONTINUE
         ENDIF
      ENDDO
      RETURN
 299  CONTINUE
      GO$M = 0
      DO 260 I = 1, 3
         KEY(I) = CHARPT('Z')
 260  CONTINUE
      RETURN
      END
C
C
      SUBROUTINE GETNUP(KEY,AUTH,TITL,YEAR,ACTN,LASTUK)
      LOGICAL*1 KEY(3),AUTH(11),TITL(58),YEAR(2),ACTN(1),LASTUK(3)
C
      LOGICAL*1 SEQ, INLINE(80)
      LOGICAL*1 BEFORE, CHARPT, CHAREQ
      LOGICAL*1 GO$M, GO$U
      COMMON /DRlV/ GO$M, GO$U
C
      SEQ = 1
      DO WHILE (SEQ)
         IF (GO$U) THEN
C     
C     READ FROM THE UPDATES FII,E
C     
            READ(11,200,END=299) INLINE
         ELSE
C     
C     SEE REMARK ABOUT THE CHARACTER '%' LATER IN THE ROUTINE.
C     
            INLINE(1) = CHARPT('%')
         ENDIF
 200     FORMAT(80A1)
         DO 210 I = 1, 3
            KEY(I) = INLINE(I)
 210     CONTINUE
         DO 220 I = 1, 11
            AUTH(I) = INLINE(3+I)
 220     CONTINUE
         DO 230 I = 1, 58
            TITL(I) = INLINE(14+I)
 230     CONTINUE
         DO 240 I = 1, 2
            YEAR(I) = INLINE(72+I)
 240     CONTINUE
         ACTN(1) = INLINE(75)
C     
C     A METHOD OF SPECIFYING END-OF-FILE IN A FILE IS TO PUT
C     THE CHARACTER '%'
C     AS THE FIRST CHARACTER ON A LINE.  THE DRIVER USES THIS
C     FOR MLTLTIPLE
C     SETS OF INPUT CASES.
C     
         IF ((.NOT.(CHAREQ(KEY(1),'%'))) .AND.
     &       (BEFORE(KEY,3,LASTUK,3)) ) THEN
           WRITE(6,250) KEY
 250       FORMAT(' ','KEY ',3A1,' OUT OF SEQUENCE')
        ELSE
           CALL ARRCPY(KEY,LASTUK,3)
           SEQ = 0
        ENDIF
        IF (CHAREQ(KEY(1),'%')) THEN
           SEQ = 0
           DO 270 I = 1, 3
              KEY(I) = CHARPT('Z')
 270       CONTINUE
        ENDIF
      ENDDO
      RETURN
 299  CONTINUE
      GO$U = 0
      DO 260 I = 1, 3
         KEY(I) = CHARPT('Z')
 260  CONTINUE
      RETURN
      END
C
C
      SUBROUTINE OUTPUT(KEY,AUTH,TITL,YEAR)
      LOGICAL*1 KEY(3), AUTH(11), TITL(58), YEAR(2)
C
      WRITE(6,200) KEY, AUTH, TITL, YEAR
 200  FORMAT(' ',3A1,11A1,58A1,2A1)
      RETURN
      END
C
C     
      SUBROUTINE PRTWDS
C
      LOGICAL*1 WORD(500,12), REFKEY(1000,3)
      INTEGER NUMWDS, NLTMREF, PTR(500), NEXT(1000)
      COMMON /WORDS/ WORD, REFKEY, NUMWDS, NUMREF, PTR, NEXT
C
C     THE ABOVE GROUP OF DATA STRUCTURES SIMULATES A LIMSED
C     LIST.
C     WORD(I,J) IS A KEYWORD - J RANGING FROM 1 TO 12
C     REFKEY(PTR(I),K),K=1,3 IS THE FIRST 3 LETTER KEY THAT HAS
C     AS A
C     KEYWORD WORD(I,J),J=1,12
C     REFKEY(NEXT(PTR(I)),K),K=1,3 IS THE SECOND 3 LETTER KEY
C     THAT HAS
C     AS A KEYWORD WORD(I,J),J=1,12
C     REFKEY(NEXT{NEXT(PTR(I))),K),K=1,3 IS THE THgtD ... ETC.
C     NEXT(J) IS EQUAL TO -1 WHEN THERE ARE NO MORE 3 LETTER
C     KEYS FOR
C     THE PARTICULAR KEYWORD
C     
      INTEGER I, J
      LOGICAL*1 FLAG
C
      WRITE(6,200)
 200  FORMAT(' ','   KEYWORD REFERENCE LIST')
      DO 210 I = 1, NUMWDS
         FLAG = 1
         WRITE(6,220) (WORD(I,J),J=1,12)
 220     FORMAT(' ',12A1)
         LAST = PTR(I)
         DOWHILE (FLAG)
         WRITE(6,230) (REFKEY(LAST,J),J=1,3)
 230     FORMAT(' ','          ',3A1)
         LAST = NFXT(LAST)
         IF (LAST .EQ. -1) THEN
            FLAG = 0
         ENDIF
      ENDDO
 210  CONTINUE
      RETURN
      END
C
C
      SUBROUTINE DICTUP(KEY,STR,STRLEN)
      LOGICAL*1 KEY(3), STR(120)
      INTEGER STRLEN
C
      LOGICAL*1 WDLEFT, FLAG, OKLEN, NEXTWD(120), WORDEQ
      INTEGER LPTR, NXTSTR, LEN, LAB, I, K
C     
      LOGICAL*1 WORD(500,12), REFKEY(1000,3)
      INTEGER NUMWDS, NUMREF, PTR(500), NEXT(1000)
      COMMON /WORDS/ WORD, REFKEY, NUMWDS, NUMREF, PTR, NEXT
C     
C     THE ABOVE GROUP OF DATA STRUCTURES SIMULATES A
C     LINKED LIST.
C     WORD(I,J) IS A KEYWORD ~ J RANGING FROM 1 TO 12
C     REFKEY(PTR(I),K),K=1,3 IS THE FIRST 3 LETTER KEY THAT HAS AS A
C     KEYWORD WORD(I,J),J=1,12
C     REFKEY(NEXT(PTR(I)),K),K=1,3 IS THE SECOND 3 LETTER KEY THAT HAS
C     AS A KEYWORD WORD(I,J),J=1,12
C     REFKEY(NEXT(NþT(PTR(I))),K),K=1,3 IS THE THllþ.D ... ETC.
C     NEXT(J) IS EQUAL TO -1 WHENN THERE ARE NO MORE 3 LETTER KEYS FOR
C     THE PARTICULAR KEYWORD
C     
      WDLEFT = 1
      LPTR =1
C
      DO WHILE (WDLEFT)
         FLAG = 1
         OKLEN = 1
         LEN = NXTSTR(STR,STRLEN,LPTR,NEXTWD,120)
         IF (LEN .EQ. 0) THEN
            WDLEFT = 0
         ENDIF
C
         IF (LEN .LE. 2) THEN
            OKLEN = 0
         ENDIF
C
         IF (OKLEN) THEN
            I = 1
            DO WHILE ((I .LE. NLTMWDS).AND. FLAG )
               IF (WORDEQ(NEXTWD,I)) THEN
                  LAB = I
                  FLAG = 0
               ENDIF
               I=I+ 1
            ENDDO
            IF (FLAG) THEN
               NUMWDS = NUMWDS + 1
               NUMREF = NUMREF + 1
               DO 300 K = 1, 12
                  WORD(NUMWDS,K) = NEXTWD(K)
 300           CONTINUE
               PTR(NUMWDS) = NUMREF
               DO 310 K = 1, 3
                  REFKEY(NUMREF,K) = KEY(K)
 310           CONTINUE
               NEXT(NUMREF) = -1
            ELSE
               NUMREF = NUMREF + 1
               DO 320 K = 1, 3
                  REFKEY(NUMREF,K) = KEY(K)
 320           CONTINUE
               NEXT(MTMREF) = PTR(LAB)
               PTR(LAB) = NLTMREF
            ENDIF
         ENDIF
      ENDDO
C
      RETURN
      END
C
C
      SUBROUTINE SRTWDS
C
      LOGICAL*1 WORD(500,12), REFKEY(1000,3)
      INTEGER NLTMWDS, NUMREF, PTR(500), NEXT(1000)
      COMMON /WORDS/ WORD, REFKEY, NUMWDS, NUMREF, PTR, NEXT
C
C     THE ABOVE GROUP OF DATA STRUCTURES SlMULATES A LINKED LIST.
C     WORD(I,J) IS A KEYWORD ~ J RANGING FROM 1 TO 12
C     REFKEY(PTR(I),K),K=1,3 IS THE FIRST 3 LETTER KEY THAT HAS AS A
C     KEYWORD WORD(I,J),J=1,12
C     REFKEY(NF.XT(PTR(I)),K),K=1,3 IS THE SECOND 3 LETTER KEY THAT HAS
C     AS A KEYWORD WORD(I,J),J=1,12
C     REFKEY(NEXT(NEXT(PTR(I))),K),K=1,3 IS THE THIRD ... ETC.
C     NEXT(J) IS EQUAL TO -1 WHEN THERE AR.E NO MORE 3 LETTER KEYS FOR
C     THE PARTICULAR KEYWORD
C     
      INTEGER I, J, K, LAB, LOWERB, UPPERB
      LOGICAL*1 WRDBEF, NEXTWD(12)
C
      UPPERB = NLTMWDS - 1
      DO 400 I = 1, UPPERB
         LOWERB = I + 1
         DO 410 J = LOWERB, NUMWDS
            IF (WRDBEF(J,I)) THEN
               DO 300 K = 1, 12
                  NEXTWD(K) = WORD(I,K)
 300           CONTINUE
               LAB = PTR(I)
               DO 310 K = 1, 12
                  WORD(I,K) = WORD(J,K)
 310           CONTINUE
               PTR(I) = PTR(J)
               DO 320 K = 1, I2
                  WORD(J,K) = NEXTWD(K)
 320           CONTINUE
               PTR(J) = LAB
            ENDIF
 410     CONTINUE
 400  CONTINUE
C     
      RETURN
      END


