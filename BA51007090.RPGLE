000100181017?   ? * ® COPYRIGHT BancoAgricola                                            *
000200181017      *   OMNICANAL                                                          */
000300181017      *                                                                      *
000400220120      *  Programa          : BA510007090                                     *
000500220120      *  Autor             : HAP                                             *
000600210902      *  Creación          :                                                 *
000700210902      *  Función           :                                                 *
000800210726      *                    :                                                 *
000801220120      *                    :                                                 *
000802220120      *                    :                                                 *
000803220120      *                    :                                                 *
000804220120      *                    :                                                 *
001200210824      *  Compilar con      : CALL PGM(BACUSRLIB/COMP207090) PARM(BA51007090) *
001300181017      *  Modificaciones    :                                                 *
001400181017      *                                                                      */
001500181017      *--Fecha--*  Usuario--*  Descripcion-----------------------------------*/
001600210726      *
001700090720      **********************************************************************/
001800210824       Dcl-f Debito Disk Usage(*Input)   Keyed include(TDR004);
001900210902       Dcl-f Bamensgf  DISK Usage(*Input) KEYED ;
002000210902       Dcl-f Cntrlcnt  Disk Usage(*Input) Keyed ;
002100210902       Dcl-f Cntrlint  Disk Usage(*Input) Keyed ;
002101211230       dcl-f PFDTAKEY disk usage(*input:*update:*output) keyed USROPN;
002102211230
002200211203       //Dcl-f hpcripto1 Disk Usage(*output);
002300210824      *---------------------------------------------------*
002400210819      /include BYTESRC/QRPGLESRC,BYDS003
002500210819      /include BYTESRC/QRPGLESRC,BYMQDEFPUT
002600170627      *---------------------------------------------------*
002700170707      *  DATOS DE ENTRADA
002800170707      *--------------------------------------*
002900170707       Dcl-Ds INPUTCONS               INZ ;
003000211013         InumTdd     Char (16);
003100211013         ItipoEnc    Char (01);
003200170707       End-Ds;
003300201125      *---------------------------------------------------*
003400210902       Dcl-pr Cvvfecha  Extpgm('CL51007090');
003500210824              cNumtar    char(16);
003600210824              cCvv       char(03);
003700210824              cActualizo char(03);
003800210824              cError     CHAR(04);
003900210811       end-pr;
003901211206       //*************************************************
003902211206       // HAP.
003903211206       //*************************************************
003904211206       Dcl-pr Env   Extpgm('CL51007098');
003905211206       end-pr;
003906211206       //*************************************************
003907211206       // HAP.
003908211206       //*************************************************
003909211206       Dcl-pr EnvEnd   Extpgm('CL51007099');
003910211206       end-pr;
004000210824       //*************************************************
004100211230       // Prototipo para las funciones de Encriptacion HAP.
004200210824       //*************************************************
004201211230       // ---  Aumentar el camppo de parametro, para la llave Cifrada  ******
004300211203       dcl-pr JvEncrip varchar(250) ;
004400211203           Entrada varchar(250) ;
004500210824         end-pr;
004501211230       //*************************************************
004502211230       // Prototipo para las funciones de Encriptacion HAP.
004503211230       //*************************************************
004504211230       // ---  Aumentar el camppo de parametro, para la llave Cifrada  ******
004505211230       dcl-pr JvEncripDt varchar(250) ;
004506211230           Entrada varchar(250);
004507211230           Cipherk varchar(250);
004508211230         end-pr;
004509211230       //*************************************************
004510211230       // Prototipo para las funciones de Encriptacion HAP.
004511211230       //*************************************************
004512211230       dcl-pr JvDecripK varchar(250) ;       //    JvDecripK
004513211230              Entrada   varchar(250) ;
004514211230       end-pr;
004600210902       //*************************************************
004700210902       // Prototipo para las funciones de Encriptacion HAP.
004800210902       //*************************************************
004900211206       //dcl-pr SqlCript varchar(120) ;
005000211206       //    Entrada     varchar(120) ;
005100211206       //  end-pr;
005200210902       //*************************************************
005300210824       Dcl-s  cNumtar    char(16);
005400210811       Dcl-s  cCvv       char(03);
005500210811       Dcl-s  cActualizo char(03);
005600210824       Dcl-s  cError     CHAR(04);
005700170627      *--------------------------------------*
005800170707      *  DATOS DE SALIDA
005900170707      *--------------------------------------*
006000210802         Dcl-Ds oDtadi                  INZ;
006100211230          oCVV         Char (120);
006200211230          ofechaV      char (120);
006300211013          oNoTdd       char (120);
006400210824         End-Ds;
006500210902      *--------------------------------------*
006600210811      *                             ----
006700210902      *    TOTAL  =                 120
006800210811      *--------------------------------------*
006900170707      *  DATOS FIJOS DE SALIDA
007000170707       Dcl-Ds ODETALLE ;
007100170707         ODaheader    Char(36) ;
007200170707         ODarespuesta Char(106);
007300211013         ODetadiciona Char(360);
007400170707       End-Ds;
007500170707      *--------------------------------------*
007600210811      *- Nombre de modulo
007700210824      *--------------------------------------*
007800210902       Dcl-c  DESCRI1 'OMNI   ';
007900170707      *---------------------------------------------------*
008000170710    ? *  Declara variables de trabajo
008100170710      *---------------------------------------------------*
008200210727        Dcl-s    Ffind       Zoned(6:0)   ;
008300210727        Dcl-s    ffcodrsp    Like  (Cdmsgp) ;
008400210727        DCl-s    Cliente1    zoned(9:0);
008500210727        DCl-s    NOMclint    char(30);
008600210727        Dcl-s    IDscRsp     Char(60);
008700210824        Dcl-s    Wnumtar     zoned(16:0);
008800210824
008900211206        dcl-s    wCvv        varchar(250) ;
009000211206        dcl-s    wFecVen     varchar(250) ;
009100211206        dcl-s    DCvv        varchar(250) ;
009200211206        dcl-s    DFecVen     varchar(250) ;
009201211230        dcl-s    CipherK     varchar(250) ;
009202211230        dcl-s    PlainKey    varchar(250) ;
009300210902
009800211013        // Debit Card Number.. Chanel Return
009900211206        dcl-s   wNotdd      varchar(250);  // Clean Value
010000211206        dcl-s   DNotdd      varchar(250);  // Encripted Value
010100211013
010200170710      *---------------------------------------------------*
010300170707    ? *PROCESO PRINCIPAL
010400170707      *---------------------------------------------------*
010500170719               exsr      Inicializar;
010600170719               exsr      Validar;
010700170719               exsr      Sbrovrf;
010800170719               exsr      Finalizar;
010900170707      *---------------------------------------------------*
011000170707    ? *- Poner mensaje en cola (putmsg)
011100170707      *---------------------------------------------------*
011200210819      /include BYTESRC/QRPGLESRC,BYMQPUTBYT
011300211013      *---------------------------------------------------*
011400170707    ? * Rutina Inicial (load)
011500170707      *---------------------------------------------------*
011600170719          Begsr  *Inzsr;
011700170707
011800210819      /include BYTESRC/QRPGLESRC,BYPARMCOMP
011801211206
011802211206           Callp Env();
011803211230
011804211230           Cipherk = CipherKey(); //Get String Cipher Key
011805211230           PlainKey = JvDecripK(Cipherk); // Get Plain String Cipherkey
011900170707
012000170719          Endsr;
012100170627      *
012200170707      *---------------------------------------------------*
012300210811    ? *  Inicializar variables de trabajo
012400211230      *---------------------------------------------------*
012500210819          Begsr  Inicializar;
012600170719            //?Busca la fecha proceso
012700170719            Setll *loval cntrlcnt;
012800170719            Read cntrlcnt;
012900170627
013000190227            Setll *loval cntrlInt;
013100190227            Read cntrlInt;
013200170627
013300170719            CLEAR    FFIND;
013400170719      *     Reformatear datos recibidos
013500210727            //oPtmo  = *blanks;
013600170719            IBUFFER = %trim(ENTRADA);
013700170719            INPUTCONS = %trim(TDATA);
013800191219            Cliente1 = *zeros;
013900191219            NOMclint = *blanks;
014000170627      *-
014100170719          Endsr;
014200170627      *
014300170707      *---------------------------------------------------*
014400170710    ? *  Validar datos de entrada
014500170707      *---------------------------------------------------*
014600170719          Begsr   Validar;
014700170719             //Inicializar codigo de respuesta
014800210811              ffcodrsp = 0;
014900210811           if INumTdd = *blanks; //Validar-que entren datos
015000210811              eval  ffcodrsp = 573; // MSG-TDD no existe
015100210811              leavesr;
015200210811           endif;
015300210824           Wnumtar = %dec(InumTdd:16:0);
015400210824           chain Wnumtar debito;
015500210811           if not %found();
015600210811              eval  ffcodrsp = 573; // MSG-TDD no existe
015700210811              leavesr;
015800210811           endif;
015900210824           cNumtar = INumTdd;
016000210824           callp Cvvfecha(cNumtar:cCvv:cActualizo:cError);
016100210824           if cError = '9999' or cError = '0573';
016200210824              eval  ffcodrsp = 574; // CVV Invalido
016300211013              leavesr;
016400210824           endif;
016500211013
016600211013         if  ItipoEnc = 'A'; //Algoritmo AES
016700211013
016800210824           wCVV    = cCvv;
016900210824           wfecVen = %editc(AÑOVEN:'X') + %editc(mesven:'X');
017000211013           wNotdd  = INumTdd;
017100211230           // Get Cipher Key
017101211230
017200211230           DCVV     = %trim(JvEncripDt(wCvv:PlainKey));
017300211230           DfecVen  = %trim(JvEncripDt(wFecVen:PlainKey));
017400211230           DNotdd   = %trim(JvEncripDt(wNotdd:PlainKey));
017500210902
017600210902
017700211203           oCVV    = %trim(DCVV);
017800211203           ofechaV = %trim(DfecVen);
017900211203           oNoTdd  = %trim(DNotdd);
018000210902
018100211013         elseif ItipoEnc = 'R'; //Algoritmo RC4...
018200211203       //
018300211203       //    wCVV    = cCvv;
018400211203       //    wfecVen = %editc(AÑOVEN:'X') + %editc(mesven:'X');
018500211203       //    wNoTdd  = INumTdd;
018600211203       //
018700211203       //    Rcvv = wCVV;
018800211203       //    RfecVen = wfecVen; //Igualar Parametros ...
018900211203       //    RNoTdd  = wNoTdd; //Igualar Parametros ...
019000211203       //
019100211203       //    wEncDec = '1';
019200211203       //    //-- CVV Value
019300211203       //    callp  EncripRC4(Rcvv:wKey:wEncrypted:wEncDec); //Encriptado RC4
019400211203       //    cvvenc   = %trim(wEncrypted); //Quitar despues de pruebas... ##
019500211203       //    clear xEncripted;
019600211203       //    eval  xEncripted = wEncrypted;
019700211203       //    Callp   Conv819(xEncripted:XCvv); //Convertir CCSID-37 a CCSID-819
019800211203       //    Cvvdec  = %trim(Xcvv); //##
019900211203       //    ExCVV =  %trim(SqlCript(XCvv)); //Convertir a Exadecimal
020000211203       //    //--  Expiration Date
020100211203       //    callp  EncripRC4(RfecVen:wKey:wEncrypted:wEncDec); //Encriptado RC4
020200211203       //    fecenc   = %trim(wEncDec); // ##
020300211203       //    clear xEncripted;
020400211203       //    eval  xEncripted = wEncrypted;
020500211203       //    Callp   Conv819(xEncripted:XFecVen); //Convertir CCSID-37 a CCSID-819
020600211203       //    Fecdec  = %trim(XFecVen); //##
020700211203       //    ExFecVen =  %trim(SqlCript(XFecVen)); //Convertir a Exadecimal
020800211203       //    //-- Debit Card
020900211203       //    callp   EncripRC4(RNoTdd:wKey:wEncrypted:wEncDec); //Encriptado RC4
021000211203       //    clear   xEncripted;
021100211203       //    eval    xEncripted = wEncrypted;
021200211203       //    Callp   Conv819(xEncripted:XNoTdd); //Convertir CCSID-37 a CCSID-819
021300211203       //    ExNoTdd =  %trim(SqlCript(XNoTdd)); //Convertir a Exadecimal
021400211203       //
021500211203       //    oCVV    = %trim(EXCvv); //Pasar a capos de salida el valor ExaDecimal
021600211203       //    ofechaV = %trim(EXFecVen); //Pasar a capos de salida el valor ExaDecimal
021700211203       //    oNoTdd  = %trim(ExNoTdd);
021800211203       //
021900211203       //    cvvenc = oCvv; //Prueba
022000211203       //    fecenc = ofechaV; // Prueba
022100211203       //    clear    cvvdec; //prueba
022200211203       //    clear    fecdec; //Prueba
022300211203       //    write  RCHPCRIPT;
022400211203       //
022500211203           endif;
022600170719          Endsr;
022700170719      *------------------------------------*
022800170719    ? *  ENVIA MENSAJE
022900170719      *------------------------------------*
023000170719          Begsr      Sbrovrf;
023100170719                  Exsr    Sbrmen;
023200170719                  TCODIGO =   ffCodRsp ;
023300170719
023400170719             // Enviar mensaje
023500170719             Eval Tdescripcion = Descrp;
023600170719             Odaheader = %subst(Ibuffer: 01:36);
023700170719             Evalr Odarespuesta = Tcodigorespue ;
023800170719             Clear Buffer ;
023900170719             Clear Odetadiciona ;
024000210802             oDetAdiciona = oDtadi; // Pasa el Nombre de Titular como valor de salida
024100170830     C                   MOVEL     IBUFFER       ODAHEADER
024200170830     C                   MOVEL     TCODIGORESPUE ODARESPUESTA
024300170830     C                   MOVEL     ODETALLE      BUFFER
024400170830     C
024500170719             If Tcodigo > 0 And  Ffind = 0 ;
024600170719                Buflen=%Size(ODAHEADER)+%size(ODARESPUESTA);
024700210811             Else ;
024800210811                BUFLEN=%size(ODETALLE);
024900170719             Endif ;
025000170719             Exsr Putmsg ;
025100170719             //  Inicializar
025200170719             Eval      ffInd = 0;
025300170707
025400170719             If  Tcodigo =  0       ;
025500170719                 Eval  Salida = Odetalle ;
025600170719                 Resultado = 0           ;
025700170719             Endif;
025800170719
025900170719          Endsr;
026000170627      *
026100170719      *-----------------------------------------*
026200210727    ? *  Definir descripcion de mensaje
026300170719      *-----------------------------------------*
026400170719          Begsr Sbrmen;
026500170710
026600210824            if ffcodrsp = 0 ; //and icodrsp <> *blank;
026700180315                //?->I Wbalcacer
026800210824                //If %Int(icodrsp) > *Zeros;
026900210824                //   ffcodrsp = 9000 + %Int(icodrsp);
027000210824                //EndIf;
027100180315                //?->O Wbalcacer
027200180315                descrp   = %trim(idscrsp);
027300210824                //leavesr;
027400171020            endif;
027500171020
027600170720            Eval    Cdtrxp = Descri1;
027700211206            Evalr   descrp = *Blanks ;
027800170720            Eval    Cdmsgp = ffCodRsp;
027900170710            Chain  (Cdtrxp:Cdmsgp) Bamensgf ;
028000170719            If %found;
028100170830            Tdescripcion  =  %trim(Descrp);
028200170719            Endif;
028300170710
028400170710       Endsr ;
028500181105      *
028600170719      * ------------------------------*
028700170719    ? *  Finalizar programa
028800170719      * ------------------------------*
028900170719       Begsr Finalizar;
028901211206           Callp EnvEnd();
029000170719           *Inlr = '1';
029100170719           Return;
029200170719       Endsr;
029301211230       // --------------------------------------------------
029302211230       // Procedure name: CipherKey
029303211230       // Purpose:        Get Value Cipher Key to Decript
029304211230       // Returns:        Cipher String Key Value
029305211230       // --------------------------------------------------
029306211230       dcl-proc CipherKey Export;
029307211230         dcl-pi *N CHAR(250);
029308211230         end-pi;
029309211230                // Local fields
029310211230
029311211230         dcl-s wCipherKey CHAR(250);
029312211230                // Calculation specifications
029313211230         open pfdtakey;
029314211230         Read pfdtakey;
029315211230         if not %eof();
029316211230            wCipherKey = %trim(kriptok);
029317211230         endif;
029318211230         close pfdtakey;
029319211230         return wCipherKey;
029320211230       end-proc;
