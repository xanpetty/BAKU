#!/usr/bin/env bash
echo 'What is your z/OS UserID?'
    read userid
userid=${userid^^}
DS=$userid.BAKU
zowe zos-files create data-set-partitioned "$DS"

# Job 1: Upload some test data files
zowe zos-files upload file-to-data-set "CUST16.txt"   "$DS(CUST16)"
zowe zos-files upload file-to-data-set "CUSTRECS.txt" "$DS(CUSTRECS)"

# Job 2: COBOL file
zowe zos-files upload file-to-data-set "TOP.CBL" "$DS(TOPCBL)"

# Job 3: JCL for COBOL file
zowe zos-files upload stdin-to-data-set "$DS(BADCC)" <<EOF
Run TOPJCL!
EOF

zowe zos-files upload stdin-to-data-set "$DS(TOPJCL)" <<EOF
//TOPJCL  JOB 1,NOTIFY=&SYSUID
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..BAKU(TOPCBL),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..BAKU(TOPJCL),DISP=SHR
//***************************************************/
// IF RC = 0 THEN
//***************************************************/
//RUN     EXEC PGM=TOPCBL
//STEPLIB   DD DSN=&SYSUID..BAKU,DISP=SHR
//PRTIN     DD DSN=&SYSUID..BAKU(CUSTRECS),DISP=SHR,OUTLIM=15000
//PRTOUT    DD DSN=&SYSUID..BAKU(BADCC),DISP=SHR,OUTLIM=15000
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
EOF

# Job 4: REXX file
zowe zos-files upload file-to-data-set "BAD.rexx" "$DS(BADREXX)"


# Job 5: JCL for REXX file
zowe zos-files upload stdin-to-data-set "$DS(BADJCL)" <<EOF
//MYJOB    JOB ,,CLASS=1,MSGCLASS=H,NOTIFY=&SYSUID
//*-------------------------------------------------------------------
//RUNPROG  EXEC PGM=IRXJCL,PARM='BADREXX'
//*
//*        RUN OUR REXX PROGRAM CALLED BADREXX
//*
//SYSEXEC  DD DSN=&SYSUID.USER.EXEC,DISP=SHR
//SYSTSIN  DD DUMMY
//SYSTSPRT DD SYSOUT=*
//*-------------------------------------------------------------------
EOF

# Job 6: README
zowe zos-files upload file-to-data-set "README.md" "$DS(README)"

