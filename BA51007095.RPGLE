000106210906       ctl-opt DFTACTGRP(*NO);
000107210906
000121210906      /copy qsysinc/qrpglesrc,qtqiconv
000122210906
000123211023       DCL-PI BA51007095;
000124210906         DataConv varchar(120);
000125210906         DataOut  varchar(120);
000126210906       end-pi;
000127210906
000128210906     dSetConvert       pr            10i 0
000129210906     d InputCCSID                    10i 0 value
000130210906     d OutputCCSID                   10i 0 value
000131210906
000132210906     dConvert          pr            10i 0
000133210906     d Input                           *   value
000134210906     d Len_Input                     10i 0 value
000135210906
000136210906     dEndConvert       pr            10i 0 extproc('iconv_close')
000137210906     d ConvDesc                            value like(cd)
000138210906
000139210906     dcd               ds
000140210906     d cdBins                        10i 0 dim(13)
000141210906
000142210906     dInput_Variable1  s             50    inz('Some variable data')
000143210906     dInput_Variable2  s             50    inz('More data')
000144210906     dOutput_Value     s           4096
000145210906     dLen_Output       s             10i 0
000146210906     dRtnCde           s             10i 0
000147210906     dwait             s              1
000148210906
000149210906      /free
000150210906       // Set the input CCSID to 37 and desired output as 819
000151211122       RtnCde = SetConvert(37 : 819);
000152210906
000153210906       if RtnCde = 0;    // no error found
000154210906          Len_Output = Convert( %addr(DataConv)
000155210906                               :%len(%trimr(DataConv)));
000156210906          if Len_Output = -1;
000157210906             DataOut = 'Error CVT';
000158210906          else;
000159210906             DataOut = %trim(Output_Value);
000160210906          // Output_Value now contains the converted field with a length of
000161210906          // Len_Output bytes
000162210906          endif;
000168210906          // Close the cd after all conversions are done
000169210906          RtnCde = EndConvert(cd);
000170210906        else;
000171210906             DataOut = 'Error CVT';
000173210906       endif;
000174210906       *inlr = *on;
000175210906       //return %trim(Output_Value);
000177210906      /end-free
000178210906
000179210906     pSetConvert       b
000180210906     dSetConvert       pi            10i 0
000181210906     d InputCCSID                    10i 0 value
000182210906     d OutputCCSID                   10i 0 value
000183210906
000184210906     dConvertOpen      pr            52a   extproc('QtqIconvOpen')
000185210906     d ToCode                          *   value
000186210906     d FromCode                        *   value
000187210906
000188210906     dToCode           ds                  likeds(qtqcode)
000189210906
000190210906     dFromCode         ds                  likeds(qtqcode)
000191210906
000192210906      /free
000193210906       FromCode = *loval;
000194210906       ToCode = *loval;
000195210906       FromCode.QTQCCSID = InputCCSID;
000196210906       ToCode.QTQCCSID = OutputCCSID;
000197210906       cd = ConvertOpen( %addr(ToCode) :%addr(FromCode));
000198210906       if cdBins(1) = -1;
000199210906          return -1;
000200210906       else;
000201210906          return 0;
000202210906       endif;
000203210906      /end-free
000204210906     pSetConvert       e
000205210906
000206210906     pConvert          b
000207210906     dConvert          pi            10i 0
000208210906     d Input_Pointer                   *   value
000209210906     d Input_Length                  10i 0 value
000210210906
000211210906     diconv            pr            10i 0 extproc('iconv')
000212210906     d ConvDesc                            value like(cd)
000213210906     d InputData                       *   value
000214210906     d InputDataLeft                 10u 0
000215210906     d OutputData                      *   value
000216210906     d OutputDataLeft                10u 0
000217210906
000218210906     dOutBufPtr        s               *
000219210906     dInBytesLeft      s             10u 0
000220210906     dOutBytesLeft     s             10u 0
000221210906
000222210906      /free
000223210906       // reset InBytesLeft, OutBytesLeft, and OutBufPtr each time as iconv
000224210906       // API updates these values
000225210906       InBytesLeft = Input_Length;
000226210906       OutBytesLeft = %len(Output_Value);
000227210906       OutBufPtr = %addr(Output_Value);
000228210906       RtnCde = iconv( cd :%addr(Input_Pointer) :InBytesLeft
000229210906                      :%addr(OutBufPtr) :OutBytesLeft);
000230210906       if RtnCde = -1;
000231210906          return -1;
000232210906       else;
000233210906          return (%len(Output_Value) - OutBytesLeft);
000234210906       endif;
000235210906      /end-free
000236210906     pConvert          e
