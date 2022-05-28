000100210819      *?------------------------------------------------------------------ *
000200210816      *?PROGRAMA          : BA51007091                                     *
000300210816      *?AUTOR             : HAP                                            *
000400210816      *?FECHA DE CREACION : Julio 16 2021                                  *
000500210816      *?FUNCION           :                                                *
000600210816      *  ?                                                                 *
000700210728      *?------------------------------------------------------------------ *
000800190709      *
000900210729       Dcl-f Cntrlcnt  keyed;
001100201102     fdebito    if   e           k disk
001200201102     f                                     Include(TDR004)
001300210729     f                                     prefix(D)
001400210512      *
001500201101        dcl-s   xAPLICATION    char(1);
001600201101        dcl-s   xCODROUTINE    char(6);
001700201031        dcl-s   xTIPVALIDA1P   packed(1:0);
001800201031        dcl-s   xTIPVALIDA1S   zoned(1:0);
001900201101        dcl-s   xCARDNUMBER    char(16);
002000201101        dcl-s   xORIGFRANQUI   char(1);
002100201101        dcl-s   xPINBLOCK      char(16);
002200201101        dcl-s   xCODSERVICE    char(3);
002300201101        dcl-s   xISSUEDATE8S   zoned(8:0);
002400210819*****   dcl-s   xISSUEDATE     packed(8:0);
002500201101        dcl-s   xEXPDATMM      char(2);
002600201031        dcl-s   xEXPDATAA       char( 2 );
002700201031        dcl-s   xVALUEOFFS      char( 4 );
002800201031        dcl-s   xCURRENPIN      char( 4 );
002900201031        dcl-s   xCVV_VERIF      char( 3 );
003000201031        dcl-s   xARQC_VERIF     char( 8 );
003100201031        dcl-s   xATC            char( 2 );
003200201031        dcl-s   xMODARQC1S     zoned( 1:0);
003300201031        dcl-s   xMODARQC1P     PACKED(1:0);
003400210520        dcl-s   TokenVPr       char(19);
003500210521      *
003600210521      ***     INCORPORACION DE NUEVAS VARABLES
003700210521      *
003800201101        dcl-s  xTRDARQC      char(  3);
003900201101        dcl-s  xT55ARQC      char(255);
004000201101        dcl-s  xT55UN        char(  4);
004100201101        dcl-s  xPANseq       char(  3);
004200201031      *
004300201101        dcl-s  xSWITCH       char(  1);
004400201101        dcl-s  xINDCHIP      char(  1);
004500201101        dcl-s  xTEXTO_1ENCR  char(256);
004600201101        dcl-s  xTEXTO_2ENCR  char(256);
004700201101        dcl-s  xTEXTO_3ENCR  char(256);
004800201101        dcl-s  xTEXTO_4ENCR  char(256);
004900201101        dcl-s  xCODERROR     char(  4);
005000201101        dcl-s  xPIN_OK       char(  1);
005100201031        dcl-s  xPIN_BLOCK_O  char(   16);
005200201031        dcl-s  xARPC_OUT     char(    8);
005300201031        dcl-s  xCVV_OUT      char(    4);
005400201031        dcl-s  xPVV_OUT      char(    4);
005500201031        dcl-s  xINDLLAVR     char(    1);
005600210521        dcl-s  TPIN_BLOCK_O  char(   16);
005700210521      *
005800210521        dcl-s  CAl_PVVCode   char(    4);
005900210521        dcl-s  CAL_PINOffset char(    4);
006000210526        dcl-s  @FRANQUI      char(    1);
006001211229        dcl-s  WCVV2         char(    3);
006002211229        dcl-s  COUNT         PACKED(2:0);
006100210526      *
006200210521      ***     CRYPTOGRAFIA DE FISERV
006300210521      *
006400210521     d PGMCRYPTO       C                   CONST('TJTADEB/TDPRCRYPTO')
006500190718      *
006600210512      ***     PROGRAMA CRIPTOGRAFICO DE ITM
006700210512      *
006800210512     d PGMITMCRY       C                   CONST('ITMAPI015R')
006900210512      *
007000210512      ***     RUTINAS CRIPTOGRAFICAS DE ITM
007100210512      *
007200210512     d ITMRUTCRY01     C                   CONST('GetTCV')
007300210512      *
007400210512      *
007500210521      *
007600210521      ***     ESTRUCTURA DE PARAMETROS P/ENVIO A PGM.FACHADA TDPRCRYPTO
007700210521      ***     ( PARA CRYPTOGRAFIA, FISERV SFCryptO )
007800210521      *
007900201031     D                 DS
008000201030     D  @APLICATION                   1
008100201030     D  @CODROUTINE                   6
008200201030     D  @TIPVALIDA1S                  1S 0
008300201030     D  @CARDNUMBER                  16
008400201030     D  @ORIGFRANQUI                  1
008500201030     D  @PINBLOCK                    16
008600201030     D  @CODSERVICE                   3
008700201031     D  @ISSUEDATE8s                  8S 0
008800201030     D  @EXPDATMM                     2
008900201030     D  @EXPDATAA                     2
009000201030     D  @VALUEOFFS                    4
009100201030     D  @CURRENPIN                    4
009200201030     D  @CVV_VERIF                    3
009300201030     D  @ARQC_VERIF                   8
009400201030     D  @ATC                          2
009500201030     D  @MODARQC1S                    1S 0
009600210521      *
009700210521      ***     INCORPORACION DE NUEVAS VARABLES
009800210521      *
009900201030     D  @TRDARQC                      3
010000201030     D  @T55ARQC                    255
010100201030     D  @T55UN                        4
010200201030     D  @PANseq                       3
010300210521      *
010400201030     D  @SWITCH                       1
010500201030     D  @INDCHIP                      1
010600201030     D  @TEXTO_1ENCR                256
010700201030     D  @TEXTO_2ENCR                256
010800201030     D  @TEXTO_3ENCR                256
010900201030     D  @TEXTO_4ENCR                256
011000201030     D  @CODERROR                     4
011100201030     D  @PIN_OK                       1
011200201030     D  @PIN_BLOCK_O                 16
011300201030     D  @ARPC_OUT                     8
011400201030     D  @CVV_OUT                      4
011500201030     D  @PVV_OUT                      4
011600201030     D  @INDLLAVR                     1
011700210512      *
011800210512     D ITMLPARM        DS           383
011900210512     D  PrRutina                     14
012000210512     D  PrICCVCAV                    19
012100210512     D  PrITCVTAV                    19
012200210512     D  PrCreateAl                    1
012300210512     D  PrTokenTyp                    1
012400210512     d  PrTypReg                      1
012500210512     D  PrAcctType                    2
012600210512     D  PrFlagOp01                    1
012700210512     D  PrFlagOp02                    1
012800210512     D  PrFlagOp03                    1
012900210512     D  PrErr                         7
013000210512     D  PrMsg                       256
013100210512     D  PrFoundRec                    1
013200210512     D  PrMasked64                   19
013300210512     D  PrOCVVCAV                    19
013400210512     D  PrOTCVTAV                    19
013500210512     D  PrITMResp                     2
013600210512      *
013800191001      *
013900210526     d* Estructura Tarjeta
014000210526     d*
014100210526     d                 ds
014200210526     d  @NUMTAR                1     16  0
014300210526     d    FRANQUI              1      1
014400210526     d    BINT                 1      6  0
014500210526     d    TARJETA              7     16
014600210526      *
014700201101     c     *ENTRY        PLIST
014800201102     c                   PARM                    NUMTAR           16
014900201102     c                   PARM                    CVV2              3
015000210728     c                   PARM                    CACTUALIZO        1
015100201102     c                   PARM                    CODERROR          4
015200210524     c                   PARM                    CODROUTINE        6
015300210520      *
015400210524         clear TokenVPr;
015500210524         clear CODROUTINE;
015600201101      *
015700210524         setll *loval Cntrlcnt;
015800210524         read Cntrlcnt;
015900210521
016000210729         CACTUALIZO = 'N';
016100210729
016200210521      *?-- limpia variables
016300210521         exsr RCRYPTLIM;
016400210524      *?-- Valida que se una tarjeta de debito
016500210521         chain (%dec(numtar:16:0)) debito ;
016600210521         if %found(debito );
016700201102           Monitor;
016800210526      *?-- Determina la Franquisia
016900210526              exsr Exsfranqui;
017000210512      *?-- Calcular CVV2
017001211229         clear count;  //test
017002211229         clear wCVV2;  //test
017003211229         dow wCVV2 = *blank;  //test
017100210524              xCODROUTINE  = 'GENCV2';           //verificar cvv2
017200210524              xTIPVALIDA1P = 2 ;
017300210524              xCARDNUMBER  = numtar;
017400210526              xORIGFRANQUI = @FRANQUI;
017500210524              xISSUEDATE = (10000 * (2000 + CNTRDY)) +
017600210524                           (100 * CNTRDM) + CNTRDD;
017700210524              xEXPDATMM = %editc(DMESVEN:'X');
017800210524              xEXPDATAA = %subst(%char(DAÑOVEN):3:2);
017900210527              xSWITCH = ' ';
018000210524              xCODSERVICE = '000';
018100210524              EXSR      RCRYPT;
018200210728              CVV2 = %subst(XCVV_OUT:2:3) ;
018201211229
018202211229              wCVV2 = CVV2;         //test
018203211229              count = count + 1;    //test
018204211229              if count = 2;         //test
018205211229                 wCVV2 = 'XXX';     //test
018206211229              endif;                //test
018207211229         enddo;                     //test
018300210524      *
018400210524           On-error;
018500210524             coderror = '9999';
018700210524           EndMon;
018800201102         else;
018900210524             coderror = '0573';
019100210524             CODROUTINE = 'DEBITO';
019200201102         endif;
019300210524
019400190709       *inlr=*on;
019500190910      *--------------------------------------------*
019600201030     C*
019700201030     C*-------------------------------------------------------------------------
019800201030     C***     RUTINA DE CRYPTOGRAFICA
019900201030     C*-------------------------------------------------------------------------
020000210521      *
020100210816     C     RCRYPT        BEGSR
020200210521      *
020300210521      ***     LLAMADA A PROGRAMA DE FACHADA TCPRCRYPTO PARA EJECUTAR
020400210521      ***     PROGRAMA DE SERVCIO DE CRYPTOGRAFIA SFCryptO DE FISERV
020500210521      *
020600201030     C                   CALL      PGMCRYPTO     PLCRYP
020700210521      *
020800201030     C     PLCRYP        PLIST
020900210521      *
021000201031     C                   PARM                    xAPLICATION
021100201031     C                   PARM                    xCODROUTINE
021200201031     C                   PARM                    xTIPVALIDA1P
021300201031     C                   PARM                    xCARDNUMBER
021400201031     C                   PARM                    xORIGFRANQUI
021500201031     C                   PARM                    xPINBLOCK
021600201031     C                   PARM                    xCODSERVICE
021700201031     C                   PARM                    xISSUEDATE
021800201031     C                   PARM                    xEXPDATMM
021900201031     C                   PARM                    xEXPDATAA
022000201031     C                   PARM                    xVALUEOFFS
022100201031     C                   PARM                    xCURRENPIN
022200201031     C                   PARM                    xCVV_VERIF
022300201031     C                   PARM                    xARQC_VERIF
022400201031     C                   PARM                    xATC
022500201031     C                   PARM                    xMODARQC1P
022600210521      *
022700210521      ***     Incorporacion de Nuevos Parametros
022800210521      *
022900201031     C                   PARM                    xTRDARQC
023000201031     C                   PARM                    xT55ARQC
023100201031     C                   PARM                    xT55UN
023200201031     C                   PARM                    xPANseq
023300210521      *
023400201031     C                   PARM                    xSWITCH
023500201031     C                   PARM                    xINDCHIP
023600201031     C                   PARM                    xTEXTO_1ENCR
023700201031     C                   PARM                    xTEXTO_2ENCR
023800201031     C                   PARM                    xTEXTO_3ENCR
023900201031     C                   PARM                    xTEXTO_4ENCR
024000201031     C                   PARM                    xCODERROR
024100201031     C                   PARM                    xPIN_OK
024200201031     C                   PARM                    xPIN_BLOCK_O
024300201031     C                   PARM                    xARPC_OUT
024400201031     C                   PARM                    xCVV_OUT
024500201031     C                   PARM                    xPVV_OUT
024600201031     C                   PARM                    xINDLLAVR
024700210521      *
024800210816     C                   ENDSR
024900210521      *
025000210521     C*-------------------------------------------------------------------------
025100210816     C*       limpia variables para CRYPTOGRAFIA
025200210521     C*-------------------------------------------------------------------------
025300210521      *
025400210816     C     RCRYPTLIM     BEGSR
025500210521      *
025600210521     C                   clear                   xAPLICATION
025700210521     C                   clear                   xCODROUTINE
025800210521     C                   clear                   xTIPVALIDA1P
025900210521     C                   clear                   xCARDNUMBER
026000210521     C                   clear                   xORIGFRANQUI
026100210521     C                   clear                   xPINBLOCK
026200210521     C                   clear                   xCODSERVICE
026300210521     C                   clear                   xISSUEDATE
026400210521     C                   clear                   xEXPDATMM
026500210521     C                   clear                   xEXPDATAA
026600210521     C                   clear                   xVALUEOFFS
026700210521     C                   clear                   xCURRENPIN
026800210521     C                   clear                   xCVV_VERIF
026900210521     C                   clear                   xARQC_VERIF
027000210521     C                   clear                   xATC
027100210521     C                   clear                   xMODARQC1P
027200210521      *
027300210521      ***     Incorporacion de Nuevos Parametros
027400210521      *
027500210521     C                   clear                   xTRDARQC
027600210521     C                   clear                   xT55ARQC
027700210521     C                   clear                   xT55UN
027800210521     C                   clear                   xPANseq
027900210521     C                   clear                   xSWITCH
028000210521     C                   clear                   xINDCHIP
028100210521     C                   clear                   xTEXTO_1ENCR
028200210521     C                   clear                   xTEXTO_2ENCR
028300210521     C                   clear                   xTEXTO_3ENCR
028400210521     C                   clear                   xTEXTO_4ENCR
028500210521     C                   clear                   xCODERROR
028600210521     C                   clear                   xPIN_OK
028700210521     C                   clear                   xPIN_BLOCK_O
028800210521     C                   clear                   xARPC_OUT
028900210521     C                   clear                   xCVV_OUT
029000210521     C                   clear                   xPVV_OUT
029100210521     C                   clear                   xINDLLAVR
029200210521      *
029300210521      *
029400210816     C                   ENDSR
029500210526     C*-------------------------------------------------------------------------
029600210526     C***     Determina la Franquicia
029700210526     C*-------------------------------------------------------------------------
029800210526      *
029900210816     C     Exsfranqui    BEGSR
030000210526      *
030100210526     C                   clear                   @NUMTAR
030200210526     C                   MOVEL     NUMTAR        @NUMTAR
030300210526     C                   CLEAR                   @FRANQUI
030400210526     C                   SELECT
030500210526      *?-- Visa  FRANQUI = '4'
030600210526     C                   WHEN      FRANQUI = '4'
030700210526     C                   MOVE      'V'           @FRANQUI
030800210526     C                   WHEN      FRANQUI = '2' OR FRANQUI = '5'
030900210526     C                   MOVE      'M'           @FRANQUI
031000210526     C                   WHEN      FRANQUI = '6'
031100210526     C                   MOVE      'V'           @FRANQUI
031200210526     C                   ENDSL
031300210526      *
031400210816     C                   ENDSR
