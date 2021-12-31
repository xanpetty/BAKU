/**************************** REXX *********************************/
/* This exec illustrates the use of "EXECIO 0 ..." to open, empty, */
/* or close a file. It reads records from file indd, allocated     */
/* to 'sams.input.dataset', and writes selected records to file    */
/* outdd, allocated to 'sams.output.dataset'. In this example, the */
/* data set 'smas.input.dataset' contains variable-length records  */
/* (RECFM = VB).                                                   */
/*******************************************************************/
"FREE FI(outdd)"
"FREE FI(indd)"
"ALLOC FI(indd)  DA('&SYSUID.BAKU.CUST16')  SHR REUSE"
"ALLOC FI(outdd) DA('&SYSUID.BAKU.BAD-LIST') SHR REUSE"
eofflag = 2                 /* Return code to indicate end-of-file */
return_code = 0                /* Initialize return code           */
in_ctr = 0                     /* Initialize # of lines read       */
out_ctr = 0                    /* Initialize # of lines written    */

/*******************************************************************/
/* Open the indd file, but do not read any records yet.  All       */
/* records will be read and processed within the loop body.        */
/*******************************************************************/

"EXECIO 0 DISKR indd (OPEN"   /* Open indd                         */

/*******************************************************************/
/* Now read all lines from indd, starting at line 1, and copy      */
/* selected lines to outdd.                                        */
/*******************************************************************/

DO WHILE (return_code \= eofflag) /* Loop while not end-of-file   */
  'EXECIO 1 DISKR indd'           /* Read 1 line to the data stack */
  return_code = rc                /* Save execio rc                */
  IF return_code = 0 THEN         /* Get a line ok?                */
   DO                             /* Yes                           */
      in_ctr = in_ctr + 1         /* Increment input line ctr      */
      PARSE PULL line.1           /* Pull line just read from stack*/
      IF LENGTH(line.1) > 10 then /* If line longer than 10 chars  */
       DO
         cc_digits = SUBSTR(line.1,6,16)
         cc_tally = 0

         prntstat = INSPECT()
         if (prntstat==PASS) then
          do
            "EXECIO 1 DISKW outdd (STEM line."    /* Write to file */
            out_ctr = out_ctr + 1     /* Increment output line ctr */
          end
       END
   END
END
"EXECIO 0 DISKR indd (FINIS"   /* Close the input file, indd   */
IF out_ctr > 0 THEN             /* Were any lines written to outdd?*/
  DO                               /* Yes.  So outdd is now open   */
   /****************************************************************/
   /* Since the outdd file is already open at this point, the      */
   /* following "EXECIO 0 DISKW ..." command will close the file,  */
   /* but will not empty it of the lines that have already been    */
   /* written. The data set allocated to outdd will contain out_ctr*/
   /* lines.                                                       */
   /****************************************************************/

  "EXECIO 0 DISKW outdd (FINIS" /* Closes the open file, outdd     */
  SAY 'File outdd now contains ' out_ctr' lines.'
END
ELSE                         /* Else no new lines have been        */
                             /* written to file outdd              */
  DO                         /* Erase any old records from the file*/

   /****************************************************************/
   /* Since the outdd file is still closed at this point, the      */
   /* following "EXECIO 0 DISKW " command will open the file,      */
   /* write 0 records, and then close it.  This will effectively   */
   /* empty the data set allocated to outdd.  Any old records that */
   /* were in this data set when this exec started will now be     */
   /* deleted.                                                     */
   /****************************************************************/

   "EXECIO 0 DISKW outdd (OPEN FINIS"  /*Empty the outdd file      */
   SAY 'File outdd is now empty.'
   END
"FREE FI(indd)"
"FREE FI(outdd)"
EXIT

INSPECT:
  payload = SUBSTR(cc_digits,1,15)
  checksum = SUBSTR(cc_digits,16,1)

  DO number = 1 TO 15
    int = SUBSTR(cc_digits,number,1)
    /* digits in even positions are added to tally */
    if (number // 2 = 0) then cc_tally = cc_tally + int
    /* digits in odd positions are mangled */
    else
      do
        odd = int * 2
        if (odd > 9) then odd = (odd - 10) + 1
        cc_tally = cc_tally + odd
      end
  END

  /* get the remainder when cc_tally is divided by 10  */
  /* then subtract from 10 which should match checksum */
  tallyrem = cc_tally // 10
  tallychk = 10 - tallyrem
  if (tallychk == 10) then tallychk = 0

  if (tallychk = checksum) then
    prnt = "PASS"
  else
    do
      prnt = "FAIL"
      say 'failed: ' cc_digits '   tally check: ' tallychk
      say line.1
    end

RETURN prnt
