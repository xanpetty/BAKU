       IDENTIFICATION DIVISION.
       PROGRAM-ID.    TOPACCTS.
       AUTHOR.        UNKNOWN.
      *
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRT-IN  ASSIGN TO PRTIN.
           SELECT PRT-OUT ASSIGN TO PRTOUT.
      *
       DATA DIVISION.
       FILE SECTION.
       FD  PRT-IN RECORD CONTAINS 80 CHARACTERS RECORDING MODE F.
       01  IN-REC.
           05 FNAME     PIC X(11) VALUE SPACES.
           05 LNAME     PIC X(22) VALUE SPACES.
           05 STARTDATE PIC X(8)  VALUE SPACES.
           05 FILLER    PIC X(3)  VALUE SPACES.
           05 ENDDATE   PIC X(8)  VALUE SPACES.
           05 FILLER    PIC X(9)  VALUE SPACES.
           05 MONEY     PIC X(12) VALUE SPACES.
           05 FILLER    PIC X(7)  VALUE SPACES.

       FD  PRT-OUT RECORD CONTAINS 80 CHARACTERS RECORDING MODE F.
       01  OUT-REC    PIC X(80) VALUE SPACES.

       WORKING-STORAGE SECTION.

       01 REAL-MONEY PIC 9(9)V99 VALUE 0.
       01 TEMP-REC   PIC X(80) VALUE SPACES.
       01 WS-TABLE.
           05 TAB-REC PIC X(80) OCCURS 1000 TIMES VALUE SPACES.
       01 EOF         PIC X(1)  VALUE 'N'.
       01 I           PIC 9(4)  VALUE 1.

       01 TOTAL-ACCT  PIC 9(4)  VALUE 0.
       01 DISP-TOT    PIC Z(04)9.

       01 YYYYMMDD.
           03 yyyy      pic 9(4).
           03 mm        pic 9(2).
           03 dd        pic 9(2).

       01 MM-DD-YYYY.
           03 month     pic 99.
           03 FILLER    pic x VALUE '.'.
           03 days       pic 99.
           03 FILLER    pic x VALUE '.'.
           03 year      pic 9(4).

       PROCEDURE DIVISION.

       A000-START.
           OPEN INPUT  PRT-IN.
           OPEN OUTPUT PRT-OUT.

           PERFORM A100-TABLE-WRITE UNTIL EOF = 'Y'.
           PERFORM A200-HEADER-WRITE.
           MOVE 1 TO I.
           PERFORM A300-ACCNT-WRITE UNTIL I > TOTAL-ACCT.

           CLOSE PRT-IN.
           CLOSE PRT-OUT.
           STOP RUN.

       A100-TABLE-WRITE.
           MOVE SPACES TO IN-REC.
           MOVE SPACES TO OUT-REC.
           MOVE SPACES TO TEMP-REC.

           READ PRT-IN
              AT END
                MOVE 'Y' TO EOF
              NOT AT END
                COMPUTE REAL-MONEY = FUNCTION NUMVAL-C(MONEY)
                IF REAL-MONEY > 8500000
                    MOVE FNAME TO TEMP-REC(1:11)
                    MOVE LNAME TO TEMP-REC(13:22)
                    MOVE MONEY TO TEMP-REC(27:12)
                    MOVE TEMP-REC TO TAB-REC(I)
                    COMPUTE I = I + 1
                    COMPUTE TOTAL-ACCT = TOTAL-ACCT + 1
                END-IF.

       A200-HEADER-WRITE.
           MOVE SPACES TO IN-REC.
           MOVE SPACES TO OUT-REC.

           MOVE "REPORT OF TOP ACCOUNT BALANCE HOLDERS" TO OUT-REC.
           WRITE OUT-REC.

           MOVE SPACES TO OUT-REC.

           MOVE "PREPARED FOR THE DEMENTORS ON" TO OUT-REC(1:29).

           MOVE FUNCTION CURRENT-DATE TO YYYYMMDD
           MOVE yyyy to year
           MOVE mm   to month
           MOVE dd   to days

           MOVE MM-DD-YYYY TO OUT-REC(31:10)
           WRITE OUT-REC.

           MOVE SPACES TO OUT-REC.

           MOVE "# OF RECORDS: " TO OUT-REC(1:14).
      *    REMOVES LEADING ZEROS WHEN DISPLAYED
           MOVE TOTAL-ACCT TO DISP-TOT.
           MOVE DISP-TOT TO OUT-REC(15:5).
           WRITE OUT-REC.

           MOVE "=====================================" TO OUT-REC.
           WRITE OUT-REC.

       A300-ACCNT-WRITE.
           MOVE SPACES TO OUT-REC.
           MOVE TAB-REC(I) TO OUT-REC.
           WRITE OUT-REC.
           COMPUTE I = I + 1.
