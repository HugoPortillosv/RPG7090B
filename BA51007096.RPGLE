000100210906       ctl-opt DFTACTGRP(*NO);
000200210906
000300210906      /copy qsysinc/qrpglesrc,qtqiconv
000400210906
000500211118       DCL-PI BA51007096;
000600211118         DataConv varchar(120);
000700211118         DataOut  varchar(120);
000800210906       end-pi;
000900210906
001000210906     dSetConvert       pr            10i 0
001100210906     d InputCCSID                    10i 0 value
001200210906     d OutputCCSID                   10i 0 value
001300210906
001400210906     dConvert          pr            10i 0
001500210906     d Input                           *   value
001600210906     d Len_Input                     10i 0 value
001700210906
001800210906     dEndConvert       pr            10i 0 extproc('iconv_close')
001900210906     d ConvDesc                            value like(cd)
002000210906
002100210906     dcd               ds
002200210906     d cdBins                        10i 0 dim(13)
002300210906
002400210906     dInput_Variable1  s             50    inz('Some variable data')
002500210906     dInput_Variable2  s             50    inz('More data')
002600210906     dOutput_Value     s           4096
002700210906     dLen_Output       s             10i 0
002800210906     dRtnCde           s             10i 0
002900210906     dwait             s              1
003000210906
003100210906      /free
003200210906       // Set the input CCSID to 37 and desired output as 819
003300210906       RtnCde = SetConvert(37 :437);
003400210906
003500210906       if RtnCde = 0;    // no error found
003600210906          Len_Output = Convert( %addr(DataConv)
003700210906                               :%len(%trimr(DataConv)));
003800210906          if Len_Output = -1;
003900210906             DataOut = 'Error CVT';
004000210906          else;
004100210906             DataOut = %trim(Output_Value);
004200210906          // Output_Value now contains the converted field with a length of
004300210906          // Len_Output bytes
004400210906          endif;
004500210906          // Close the cd after all conversions are done
004600210906          RtnCde = EndConvert(cd);
004700210906        else;
004800210906             DataOut = 'Error CVT';
004900210906       endif;
005000210906       *inlr = *on;
005100210906       //return %trim(Output_Value);
005200210906      /end-free
005300210906
005400210906     pSetConvert       b
005500210906     dSetConvert       pi            10i 0
005600210906     d InputCCSID                    10i 0 value
005700210906     d OutputCCSID                   10i 0 value
005800210906
005900210906     dConvertOpen      pr            52a   extproc('QtqIconvOpen')
006000210906     d ToCode                          *   value
006100210906     d FromCode                        *   value
006200210906
006300210906     dToCode           ds                  likeds(qtqcode)
006400210906
006500210906     dFromCode         ds                  likeds(qtqcode)
006600210906
006700210906      /free
006800210906       FromCode = *loval;
006900210906       ToCode = *loval;
007000210906       FromCode.QTQCCSID = InputCCSID;
007100210906       ToCode.QTQCCSID = OutputCCSID;
007200210906       cd = ConvertOpen( %addr(ToCode) :%addr(FromCode));
007300210906       if cdBins(1) = -1;
007400210906          return -1;
007500210906       else;
007600210906          return 0;
007700210906       endif;
007800210906      /end-free
007900210906     pSetConvert       e
008000210906
008100210906     pConvert          b
008200210906     dConvert          pi            10i 0
008300210906     d Input_Pointer                   *   value
008400210906     d Input_Length                  10i 0 value
008500210906
008600210906     diconv            pr            10i 0 extproc('iconv')
008700210906     d ConvDesc                            value like(cd)
008800210906     d InputData                       *   value
008900210906     d InputDataLeft                 10u 0
009000210906     d OutputData                      *   value
009100210906     d OutputDataLeft                10u 0
009200210906
009300210906     dOutBufPtr        s               *
009400210906     dInBytesLeft      s             10u 0
009500210906     dOutBytesLeft     s             10u 0
009600210906
009700210906      /free
009800210906       // reset InBytesLeft, OutBytesLeft, and OutBufPtr each time as iconv
009900210906       // API updates these values
010000210906       InBytesLeft = Input_Length;
010100210906       OutBytesLeft = %len(Output_Value);
010200210906       OutBufPtr = %addr(Output_Value);
010300210906       RtnCde = iconv( cd :%addr(Input_Pointer) :InBytesLeft
010400210906                      :%addr(OutBufPtr) :OutBytesLeft);
010500210906       if RtnCde = -1;
010600210906          return -1;
010700210906       else;
010800210906          return (%len(Output_Value) - OutBytesLeft);
010900210906       endif;
011000210906      /end-free
011100210906     pConvert          e
