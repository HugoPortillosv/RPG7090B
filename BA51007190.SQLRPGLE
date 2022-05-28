000100181017?   ? * ® COPYRIGHT BancoAgricola                                            *
000200181017      *   OMNICANAL                                                          */
000300181017      *                                                                      *
000400210902      *  Programa          : BA510007090  Copia de BA510007080               *
000500210902      *  Autor             :                                                 *
000600210902      *  Creación          :                                                 *
000700210902      *  Función           :                                                 *
000800210726      *                    :                                                 *
000900181017      *  Programas relacionados: IBSPPRE-Pagar PRESTAMO con cargo a cuenta   *
001000181017      *                          TLRETS-cargo a cliente                      *
001100181017      *                          TLOTRS-abono a prestamo                     *
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
002101210902       Dcl-f hpcripto1 Disk Usage(*output);
002200210824      *---------------------------------------------------*
002300210819      /include BYTESRC/QRPGLESRC,BYDS003
002400210819      /include BYTESRC/QRPGLESRC,BYMQDEFPUT
002500170627      *---------------------------------------------------*
002600170707      *  DATOS DE ENTRADA
002700170707      *--------------------------------------*
002800170707       Dcl-Ds INPUTCONS               INZ ;
002900211013         InumTdd     Char (16);
002901211013         ItipoEnc    Char (01);
003000170707       End-Ds;
003100201125      *---------------------------------------------------*
003200210902       Dcl-pr Cvvfecha  Extpgm('CL51007090');
003300210824              cNumtar    char(16);
003400210824              cCvv       char(03);
003500210824              cActualizo char(03);
003600210824              cError     CHAR(04);
003700210811       end-pr;
003701211013      *---------------------------------------------------*
003702201125       Dcl-pr EncripRC4  Extpgm('BA51007094');
003703211013         wData       char(30); //Datos limpios
003704211013         wKey        char(16);  //Llave
003705211013         wEncrypted  char(10); //Valor cifrado
003706211013         wEncDec     char(01);  //Varible, 1=Encriptar 2=Decriptar
003707211013       end-pr;
003708211013
003709211013       dcl-s   wData       char(30); //Datos limpios
003710211013       dcl-s   wKey        char(16);  //Llave
003711211013       dcl-s   wEncrypted  char(10); //Valor cifrado
003712211013       dcl-s   wEncDec     char(01);  //Varible, 1=Encriptar 2=Decriptar
003713210902      *---------------------------------------------------*
003714201125       Dcl-pr Conv819   Extpgm('BA51007095');
003715210902              DataConv  varchar(120) ;
003716210902              DataOut   varchar(120) ;
003717210902       end-pr;
003800210824       //*************************************************
003900210824       // Prototipo para las funciones de Encriptacion HAP.
004000210824       //*************************************************
004100210902       dcl-pr Encriptar varchar(120) ;
004200210902           Entrada varchar(120) ;
004300210824         end-pr;
004401210902       //*************************************************
004402210902       // Prototipo para las funciones de Encriptacion HAP.
004403210902       //*************************************************
004404210902       dcl-pr SqlCript varchar(120) ;
004405210902           Entrada     varchar(120) ;
004406210902         end-pr;
004407210902       //*************************************************
004500210824       Dcl-s  cNumtar    char(16);
004600210811       Dcl-s  cCvv       char(03);
004700210811       Dcl-s  cActualizo char(03);
004800210824       Dcl-s  cError     CHAR(04);
004900170627      *--------------------------------------*
005000170707      *  DATOS DE SALIDA
005100170707      *--------------------------------------*
005200210802         Dcl-Ds oDtadi                  INZ;
005300211013          oCVV         Char (120);   //CCSID(65535); // ccsid-819,   Descripcion del Titular de Pres
005400211106          ofechaV      char (120);   //CCSID(65535); // ccsid-819,  Fecha de nacimiento de cliente
005401211013          oNoTdd       char (120);
005500210824         End-Ds;
005600210902      *--------------------------------------*
005700210811      *                             ----
005800210902      *    TOTAL  =                 120
005900210811      *--------------------------------------*
006000170707      *  DATOS FIJOS DE SALIDA
006100170707       Dcl-Ds ODETALLE ;
006200170707         ODaheader    Char(36) ;
006300170707         ODarespuesta Char(106);
006400211013         ODetadiciona Char(360);
006500170707       End-Ds;
006600170707      *--------------------------------------*
006700210811      *- Nombre de modulo
006800210824      *--------------------------------------*
006900210902       Dcl-c  DESCRI1 'OMNI   ';
007000170707      *---------------------------------------------------*
007100170710    ? *  Declara variables de trabajo
007200170710      *---------------------------------------------------*
007300210727        Dcl-s    Ffind       Zoned(6:0)   ;
007400210727        Dcl-s    ffcodrsp    Like  (Cdmsgp) ;
007500210727        DCl-s    Cliente1    zoned(9:0);
007600210727        DCl-s    NOMclint    char(30);
007700210727        Dcl-s    IDscRsp     Char(60);
007800210824        Dcl-s    Wnumtar     zoned(16:0);
007900210824
008000210902        dcl-s    wCvv        varchar(120) ;
008100210902        dcl-s    wFecVen     varchar(120) ;
008101210902        dcl-s    DCvv        varchar(120) CCSID(65535);
008102210902        dcl-s    DFecVen     varchar(120) CCSID(65535);
008103210902
008104210902        dcl-s    XCvv        varchar(120) ;
008105210902        dcl-s    XFecVen     varchar(120) ;
008106210902
008107210902        dcl-s    ExCvv       varchar(120) ;
008108210902        dcl-s    ExFecVen    varchar(120) ;
008109210902
008110210902        dcl-s    oCvvx       char(60);
008111210902        dcl-s    ofechaVx    char(60);
008112210902        dcl-s    CvvY        char(60);
008113210902        dcl-s    fecVenY     char(60);
008114210902
008115211013        dcl-s    Rcvv        char(30);    //Parametros para RC4
008116211013        dcl-s    Rfecven     char(30);
008117211013
008118211013        dcl-s   xEncripted  varchar(120);
008119211013        // Debit Card Number.. Chanel Return
008120211013        dcl-s   wNotdd      varchar(120);  // Clean Value
008121211013        dcl-s   DNotdd      varchar(120);  // Encripted Value
008122211013        dcl-s   ExNotdd     varchar(120);  // ExaDecimal Values
008123211013        dcl-s   xNotdd      varchar(120);  // Ascci value from EBCDIC
008124211013        dcl-s   RNotdd      char(30);  // Clean Value To RC4
008125211013
008200170710      *---------------------------------------------------*
008300170707    ? *PROCESO PRINCIPAL
008400170707      *---------------------------------------------------*
008500170719               exsr      Inicializar;
008600170719               exsr      Validar;
008700170719               exsr      Sbrovrf;
008800170719               exsr      Finalizar;
008900170707      *---------------------------------------------------*
009000170707    ? *- Poner mensaje en cola (putmsg)
009100170707      *---------------------------------------------------*
009200210819      /include BYTESRC/QRPGLESRC,BYMQPUTBYT
009300211013      *---------------------------------------------------*
009400170707    ? * Rutina Inicial (load)
009500170707      *---------------------------------------------------*
009600170719          Begsr  *Inzsr;
009700170707
009800210819      /include BYTESRC/QRPGLESRC,BYPARMCOMP
009900170707
010000170719          Endsr;
010100170627      *
010200170707      *---------------------------------------------------*
010300210811    ? *  Inicializar variables de trabajo
010400170707      *---------------------------------------------------*
010500210819          Begsr  Inicializar;
010600170719            //?Busca la fecha proceso
010700170719            Setll *loval cntrlcnt;
010800170719            Read cntrlcnt;
010900170627
011000190227            Setll *loval cntrlInt;
011100190227            Read cntrlInt;
011200170627
011300170719            CLEAR    FFIND;
011400170719      *     Reformatear datos recibidos
011500210727            //oPtmo  = *blanks;
011600170719            IBUFFER = %trim(ENTRADA);
011700170719            INPUTCONS = %trim(TDATA);
011800191219            Cliente1 = *zeros;
011900191219            NOMclint = *blanks;
012000170627      *-
012100170719          Endsr;
012200170627      *
012300170707      *---------------------------------------------------*
012400170710    ? *  Validar datos de entrada
012500170707      *---------------------------------------------------*
012600170719          Begsr   Validar;
012700170719             //Inicializar codigo de respuesta
012800210811              ffcodrsp = 0;
012900210811           if INumTdd = *blanks; //Validar-que entren datos
013000210811              eval  ffcodrsp = 573; // MSG-TDD no existe
013100210811              leavesr;
013200210811           endif;
013300210824           Wnumtar = %dec(InumTdd:16:0);
013400210824           chain Wnumtar debito;
013500210811           if not %found();
013600210811              eval  ffcodrsp = 573; // MSG-TDD no existe
013700210811              leavesr;
013800210811           endif;
013900210824           cNumtar = INumTdd;
014000210824           callp Cvvfecha(cNumtar:cCvv:cActualizo:cError);
014100210824           if cError = '9999' or cError = '0573';
014200210824              eval  ffcodrsp = 574; // CVV Invalido
014201211013              leavesr;
014300210824           endif;
014301211013
014302211013         if  ItipoEnc = 'A'; //Algoritmo AES
014303211013
014400210824           wCVV    = cCvv;
014500210824           wfecVen = %editc(AÑOVEN:'X') + %editc(mesven:'X');
014501211013           wNotdd  = INumTdd;
014502210902           //CVVY    = cCvv;
014503210902           //fecVenY = %editc(AÑOVEN:'X') + %editc(mesven:'X');
014600211013           DCVV     = %trim(Encriptar(wCvv));
014601211106           cvvenc   = %trim(dcvv); //Quitar despues de pruebas... ##
014700210902           DfecVen  = %trim(Encriptar(wFecVen));
014701211106           fecenc   = %trim(DFecVen); // ##
014702211013           DNotdd   = %trim(Encriptar(wNotdd));
014703210902
014704210902           Callp   Conv819(DCvv:XCvv); //Convertir CCSID-37 a CCSID-819
014705211106           Cvvdec  = %trim(Xcvv); //##
014706210902           Callp   Conv819(DFecVen:XFecVen);
014707211106           Fecdec  = %trim(XFecVen); //##
014708211013           Callp   Conv819(DNoTdd:XNoTdd);
014709210902           //ExCVV    = %trim(SqlCript(XCvv)); //Convertir a Exadecimal
014710210902           //ExFecVen = %trim(SqlCript(XFecVen));
014711211013           ExCVV    = %trim(SqlCript(XCvv)); //Convertir a Exadecimal
014712211013           ExFecVen = %trim(SqlCript(XFecVen));
014713211013           ExNoTdd  = %trim(SqlCript(XNoTdd));
014714210902
014715210902           oCVV    = %trim(EXCvv);
014716211013           ofechaV = %trim(EXFecVen);
014717211013           oNoTdd  = %trim(ExNoTdd);
014718210902
014719210902           cvvrec = cCvv; // Prueba
014720210902           fecven = wfecVen;// Prueba
014721210902
014722210902           //oCVV    = %trim(SqlCript(wCvv));
014723210902           //ofechaV = %trim(SqlCript(wFecVen));
014724210902
014725211106           //cvvenc = oCvv; //Prueba
014726211106           //fecenc = ofechaV; // Prueba
014729210902           write  RCHPCRIPT;
014730211106           clear    cvvdec; //prueba
014731211106           clear    fecdec; //Prueba
014732211013
014733211013         elseif ItipoEnc = 'R'; //Algoritmo RC4...
014734211013
014735211013           wCVV    = cCvv;
014736211013           wfecVen = %editc(AÑOVEN:'X') + %editc(mesven:'X');
014737211013           wNoTdd  = INumTdd;
014738211013
014739211013           Rcvv = wCVV;
014740211013           RfecVen = wfecVen; //Igualar Parametros ...
014741211013           RNoTdd  = wNoTdd; //Igualar Parametros ...
014742211013
014743211013           wEncDec = '1';
014744211013           //-- CVV Value
014745211013           callp  EncripRC4(Rcvv:wKey:wEncrypted:wEncDec); //Encriptado RC4
014746211106           cvvenc   = %trim(wEncrypted); //Quitar despues de pruebas... ##
014747211013           clear xEncripted;
014748211013           eval  xEncripted = wEncrypted;
014749211013           Callp   Conv819(xEncripted:XCvv); //Convertir CCSID-37 a CCSID-819
014750211106           Cvvdec  = %trim(Xcvv); //##
014751211013           ExCVV =  %trim(SqlCript(XCvv)); //Convertir a Exadecimal
014752211013           //--  Expiration Date
014753211013           callp  EncripRC4(RfecVen:wKey:wEncrypted:wEncDec); //Encriptado RC4
014754211106           fecenc   = %trim(wEncDec); // ##
014755211013           clear xEncripted;
014756211013           eval  xEncripted = wEncrypted;
014757211013           Callp   Conv819(xEncripted:XFecVen); //Convertir CCSID-37 a CCSID-819
014758211106           Fecdec  = %trim(XFecVen); //##
014759211013           ExFecVen =  %trim(SqlCript(XFecVen)); //Convertir a Exadecimal
014760211013           //-- Debit Card
014761211106           callp   EncripRC4(RNoTdd:wKey:wEncrypted:wEncDec); //Encriptado RC4
014762211106           clear   xEncripted;
014763211106           eval    xEncripted = wEncrypted;
014764211013           Callp   Conv819(xEncripted:XNoTdd); //Convertir CCSID-37 a CCSID-819
014765211106           ExNoTdd =  %trim(SqlCript(XNoTdd)); //Convertir a Exadecimal
014766211013
014767211013           oCVV    = %trim(EXCvv); //Pasar a capos de salida el valor ExaDecimal
014768211013           ofechaV = %trim(EXFecVen); //Pasar a capos de salida el valor ExaDecimal
014769211013           oNoTdd  = %trim(ExNoTdd);
014770211013
014771211013           cvvenc = oCvv; //Prueba
014772211013           fecenc = ofechaV; // Prueba
014773211013           clear    cvvdec; //prueba
014774211013           clear    fecdec; //Prueba
014775211013           write  RCHPCRIPT;
014776211013
014777211013         endif;
014900170719          Endsr;
015000170719      *------------------------------------*
015100170719    ? *  ENVIA MENSAJE
015200170719      *------------------------------------*
015300170719          Begsr      Sbrovrf;
015400170719                  Exsr    Sbrmen;
015500170719                  TCODIGO =   ffCodRsp ;
015600170719
015700170719             // Enviar mensaje
015800170719             Eval Tdescripcion = Descrp;
015900170719             Odaheader = %subst(Ibuffer: 01:36);
016000170719             Evalr Odarespuesta = Tcodigorespue ;
016100170719             Clear Buffer ;
016200170719             Clear Odetadiciona ;
016300210802             oDetAdiciona = oDtadi; // Pasa el Nombre de Titular como valor de salida
016400170830     C                   MOVEL     IBUFFER       ODAHEADER
016500170830     C                   MOVEL     TCODIGORESPUE ODARESPUESTA
016600170830     C                   MOVEL     ODETALLE      BUFFER
016700170830     C
016800170719             If Tcodigo > 0 And  Ffind = 0 ;
016900170719                Buflen=%Size(ODAHEADER)+%size(ODARESPUESTA);
017000210811             Else ;
017100210811                BUFLEN=%size(ODETALLE);
017200170719             Endif ;
017300170719             Exsr Putmsg ;
017400170719             //  Inicializar
017500170719             Eval      ffInd = 0;
017600170707
017700170719             If  Tcodigo =  0       ;
017800170719                 Eval  Salida = Odetalle ;
017900170719                 Resultado = 0           ;
018000170719             Endif;
018100170719
018200170719          Endsr;
018300170627      *
018400170719      *-----------------------------------------*
018500210727    ? *  Definir descripcion de mensaje
018600170719      *-----------------------------------------*
018700170719          Begsr Sbrmen;
018800170710
018900210824            if ffcodrsp = 0 ; //and icodrsp <> *blank;
019000180315                //?->I Wbalcacer
019100210824                //If %Int(icodrsp) > *Zeros;
019200210824                //   ffcodrsp = 9000 + %Int(icodrsp);
019300210824                //EndIf;
019400180315                //?->O Wbalcacer
019500180315                descrp   = %trim(idscrsp);
019600210824                //leavesr;
019700171020            endif;
019800171020
019900170720            Eval    Cdtrxp = Descri1;
020000170720            Evalr   descrp = *Blanks ;
020100170720            Eval    Cdmsgp = ffCodRsp;
020200170710            Chain  (Cdtrxp:Cdmsgp) Bamensgf ;
020300170719            If %found;
020400170830            Tdescripcion  =  %trim(Descrp);
020500170719            Endif;
020600170710
020700170710       Endsr ;
020800181105      *
020900170719      * ------------------------------*
021000170719    ? *  Finalizar programa
021100170719      * ------------------------------*
021200170719       Begsr Finalizar;
021300170719           *Inlr = '1';
021400170719           Return;
021500170719       Endsr;
021600210824
021601210902      * -------------------------------------------------------------------------------------------*
021602210902       // --------------------------------------------------
021603210902       // Procedure name: SqlCripto
021604210902       // Purpose:        Generated by Extract Procedure Wizard
021605210902       // Returns:
021606210902       // Parameter:      Text
021607210902       // --------------------------------------------------
021608210902       dcl-proc SqlCript;
021609210902         dcl-pi *N VARCHAR(120) ;
021610210902            Text   varchar(120) ;
021612210902         end-pi;
021613210902
021614210902         dcl-s ValCript varchar(120);
021615210902
021619210902         exec sql
021620210902         //select  HEX(ENCRYPT_AES(:Text,'OMNICHANEL_PER  ')) into :ValCript
021621210902         //  from SYSIBM.SYSDUMMY1;
021622210902           select  Hex(:Text) into :ValCript
021623210902            from SYSIBM.SYSDUMMY1;
021624210902
021625210902         if sqlcode = 0;
021626210902            //Codificacion de error , de encriptacion
021627210902         endif;
021628210902
021629210902
021630210902         return ValCript;
021631210902       end-proc;
021632210902
