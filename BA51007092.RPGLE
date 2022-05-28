000100181017?   ? * ® COPYRIGHT BancoAgricola                                            *
000200181017      *   OMNICANAL                                                          */
000300181017      *                                                                      *
000400210726      *  Programa          : BA510007080  Copia de BA510000070               *
000500181017      *  Autor             : JER                                             *
000600210726      *  Creación          : Junio 26, 2021                                  *
000700210726      *  Función           : Validacion Pago Prestamos X BTC                 *
000800210726      *                    :                                                 *
000900181017      *  Programas relacionados: IBSPPRE-Pagar PRESTAMO con cargo a cuenta   *
001000181017      *                          TLRETS-cargo a cliente                      *
001100181017      *                          TLOTRS-abono a prestamo                     *
001200210824      *  Compilar con      : CALL PGM(BACUSRLIB/COMP207090) PARM(BA51007090) *
001300181017      *  Modificaciones    :                                                 *
001400181017      *                                                                      */
001500181017      *--Fecha--*  Usuario--*  Descripcion-----------------------------------*/
001700210726      *
001800090720      **********************************************************************/
001900210824       Dcl-f Debito Disk Usage(*Input)   Keyed include(TDR004);
001901210824       Dcl-f Bamensgf DISK Usage(*Input) KEYED ;
001902210824       Dcl-f Cntrlcnt Disk Usage(*Input) Keyed ;
001903210824       Dcl-f Cntrlint Disk Usage(*Input) Keyed ;
002600210824      *---------------------------------------------------*
002700210819      /include BYTESRC/QRPGLESRC,BYDS003
002800210819      /include BYTESRC/QRPGLESRC,BYMQDEFPUT
002900170627      *---------------------------------------------------*
003000170707      *  DATOS DE ENTRADA
003100170707      *--------------------------------------*
003200170707       Dcl-Ds INPUTCONS               INZ ;
003600210811         INumTdd    Char (16);
003800170707       End-Ds;
003900210730      *---------------------------------------------------*
004602210819       Dcl-pr Cvvfecha  Extpgm('CL51007090');
004603210824              cNumtar    char(16);
004605210824              cCvv       char(03);
004606210824              cActualizo char(03);
004607210824              cError     CHAR(04);
004609210811       end-pr;
004610210824       //*************************************************
004611210824       // Prototipo para las funciones de Encriptacion HAP.
004612210824       //*************************************************
004613210824       dcl-pr Encriptar char(60);
004615210824           Entrada char(60);
004616210824         end-pr;
004617210824       //*************************************************
004622210824       Dcl-s  cNumtar    char(16);
004623210811       Dcl-s  cCvv       char(03);
004624210811       Dcl-s  cActualizo char(03);
004625210824       Dcl-s  cError     CHAR(04);
004700170627      *--------------------------------------*
007500170707      *  DATOS DE SALIDA
007600170707      *--------------------------------------*
007700210802         Dcl-Ds oDtadi                  INZ;
008000210824          oCVV         Char (60) CCSID(1208) ; // ccsid-819,   Descripcion del Titular de Prestamo
008001210824          ofechaV      char (60) CCSID(1208) ; // ccsid-819,  Fecha de nacimiento de cliente
008100210824         End-Ds;
008101210811      *--------------------------------------*
008102210811      *                             ----
008103210824      *    TOTAL                    120
008104210811      *--------------------------------------*
008300170707      *  DATOS FIJOS DE SALIDA
008400170707       Dcl-Ds ODETALLE ;
008500170707         ODaheader    Char(36) ;
008600170707         ODarespuesta Char(106);
008700210819         ODetadiciona Char(120);
008800170707       End-Ds;
008900170707      *--------------------------------------*
009100210811      *- Nombre de modulo
009101210824      *--------------------------------------*
009200170707       Dcl-c  DESCRI1 'OMNI   ';
009400170707      *---------------------------------------------------*
009500170710    ? *  Declara variables de trabajo
009600170710      *---------------------------------------------------*
009700210727        Dcl-s    Ffind       Zoned(6:0)   ;
010300210727        Dcl-s    ffcodrsp    Like  (Cdmsgp) ;
010700210727        DCl-s    Cliente1    zoned(9:0);
010800210727        DCl-s    NOMclint    char(30);
011200210727        Dcl-s    IDscRsp     Char(60);
011201210824        Dcl-s    Wnumtar     zoned(16:0);
011202210824
011203210824        dcl-s    wCvv        char(60);
011204210824        dcl-s    wFecVen     char(60);
015000170710      *---------------------------------------------------*
015100170707    ? *PROCESO PRINCIPAL
015200170707      *---------------------------------------------------*
015400170719               exsr      Inicializar;
015500170719               exsr      Validar;
015700170719               exsr      Sbrovrf;
015800170719               exsr      Finalizar;
016000170707      *---------------------------------------------------*
016100170707    ? *- Poner mensaje en cola (putmsg)
016200170707      *---------------------------------------------------*
016300210819      /include BYTESRC/QRPGLESRC,BYMQPUTBYT
016500170707      *---------------------------------------------------*
016600170707    ? * Rutina Inicial (load)
016700170707      *---------------------------------------------------*
016800170719          Begsr  *Inzsr;
016900170707
017000210819      /include BYTESRC/QRPGLESRC,BYPARMCOMP
017100170707
017200170719          Endsr;
017300170627      *
017400170707      *---------------------------------------------------*
017500210811    ? *  Inicializar variables de trabajo
017600170707      *---------------------------------------------------*
017700210819          Begsr  Inicializar;
017800170719            //?Busca la fecha proceso
017900170719            Setll *loval cntrlcnt;
018000170719            Read cntrlcnt;
018100170627
018200190227            Setll *loval cntrlInt;
018300190227            Read cntrlInt;
018400170627
018500170719            CLEAR    FFIND;
018600170719      *     Reformatear datos recibidos
018700210727            //oPtmo  = *blanks;
018800170719            IBUFFER = %trim(ENTRADA);
018900170719            INPUTCONS = %trim(TDATA);
019000191219            Cliente1 = *zeros;
019100191219            NOMclint = *blanks;
019200170627      *-
019300170719          Endsr;
019400170627      *
019500170707      *---------------------------------------------------*
019600170710    ? *  Validar datos de entrada
019700170707      *---------------------------------------------------*
019800170719          Begsr   Validar;
019900170719             //Inicializar codigo de respuesta
020000210811              ffcodrsp = 0;
020001210811           if INumTdd = *blanks; //Validar-que entren datos
020002210811              eval  ffcodrsp = 573; // MSG-TDD no existe
020003210811              leavesr;
020004210811           endif;
020005210824           Wnumtar = %dec(InumTdd:16:0);
020006210824           chain Wnumtar debito;
020007210811           if not %found();
020008210811              eval  ffcodrsp = 573; // MSG-TDD no existe
020009210811              leavesr;
020012210811           endif;
020013210824           cNumtar = INumTdd;
020015210824           callp Cvvfecha(cNumtar:cCvv:cActualizo:cError);
020016210824           if cError = '9999' or cError = '0573';
020017210824              eval  ffcodrsp = 574; // CVV Invalido
020018210824           endif;
020019210824           wCVV    = cCvv;
020020210824           wfecVen = %editc(AÑOVEN:'X') + %editc(mesven:'X');
020021210824           oCVV    = %trim(Encriptar(wCvv));
020022210824           ofechaV = %trim(Encriptar(wFecVen));
029600170627      *
029700170719          Endsr;
037400170719      *------------------------------------*
037500170719    ? *  ENVIA MENSAJE
037600170719      *------------------------------------*
037700170719          Begsr      Sbrovrf;
037900170719                  Exsr    Sbrmen;
038000170719                  TCODIGO =   ffCodRsp ;
038200170719
038300170719             // Enviar mensaje
038400170719             Eval Tdescripcion = Descrp;
038500170719             Odaheader = %subst(Ibuffer: 01:36);
038600170719             Evalr Odarespuesta = Tcodigorespue ;
038700170719             Clear Buffer ;
038800170719             Clear Odetadiciona ;
039100210802             oDetAdiciona = oDtadi; // Pasa el Nombre de Titular como valor de salida
039200170830     C                   MOVEL     IBUFFER       ODAHEADER
039300170830     C                   MOVEL     TCODIGORESPUE ODARESPUESTA
039400170830     C                   MOVEL     ODETALLE      BUFFER
039500170830     C
039600170719             If Tcodigo > 0 And  Ffind = 0 ;
039700170719                Buflen=%Size(ODAHEADER)+%size(ODARESPUESTA);
039800210811             Else ;
039801210811                BUFLEN=%size(ODETALLE);
040200170719             Endif ;
040300170719             Exsr Putmsg ;
040400170719             //  Inicializar
040500170719             Eval      ffInd = 0;
040600170707
040700170719             If  Tcodigo =  0       ;
040800170719                 Eval  Salida = Odetalle ;
040900170719                 Resultado = 0           ;
041000170719             Endif;
041100170719
041200170719          Endsr;
041300170627      *
041400170719      *-----------------------------------------*
041500210727    ? *  Definir descripcion de mensaje
041600170719      *-----------------------------------------*
041700170719          Begsr Sbrmen;
041800170710
041900210824            if ffcodrsp = 0 ; //and icodrsp <> *blank;
042000180315                //?->I Wbalcacer
042100210824                //If %Int(icodrsp) > *Zeros;
042200210824                //   ffcodrsp = 9000 + %Int(icodrsp);
042300210824                //EndIf;
042400180315                //?->O Wbalcacer
042500180315                descrp   = %trim(idscrsp);
042600210824                //leavesr;
042700171020            endif;
042800171020
042900170720            Eval    Cdtrxp = Descri1;
043000170720            Evalr   descrp = *Blanks ;
043100170720            Eval    Cdmsgp = ffCodRsp;
043200170710            Chain  (Cdtrxp:Cdmsgp) Bamensgf ;
043300170719            If %found;
043400170830            Tdescripcion  =  %trim(Descrp);
043500170719            Endif;
043600170710
043700170710       Endsr ;
043800181105      *
043900170719      * ------------------------------*
044000170719    ? *  Finalizar programa
044100170719      * ------------------------------*
044200170719       Begsr Finalizar;
044300170719           *Inlr = '1';
044400170719           Return;
044500170719       Endsr;
044501210824
