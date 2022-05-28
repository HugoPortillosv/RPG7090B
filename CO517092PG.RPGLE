000100210914       CTL-OPT THREAD(*SERIALIZE) DFTACTGRP(*NO);
000200211215       dcl-f CO517090FM Workstn Indds(Indicadores);
000201211215       dcl-f PFDTAKEY disk usage(*input:*update);
000202211215       //***********************************************************************
000203211215       dcl-ds Indicadores len(99);
000204211215              Aceptar Ind pos(01);
000205211215              salir   Ind pos(03);
000207211215       end-ds;
000300211130       //-----------------------------------------------
000600211130       // Valores de retorno, de la Clase
000700211130       //-----------------------------------------------
000800211130       dcl-s encryptRet OBJECT(*JAVA : 'java.lang.String');
000900211130       dcl-s JAVA_String object(*JAVA :'java.lang.String');
001000211202       dcl-s str  varchar(250);
001100211202       dcl-s str1 varchar(12);
001200211130       //-------------------------------------------------------------------------
001300211130       //   Declaracion de Parametros para la Clase Encripta
001500211130       //-------------------------------------------------------------------------
001600211130       dcl-s j_encryptParam0 OBJECT(*JAVA : 'java.lang.String' );
001700211130       dcl-s j_encryptParam1 OBJECT(*JAVA : 'java.lang.String' );
001800211130       //----------------------------------------------
001900211130       //  Declaracion de Prototipo : para la Clase
002000211130       //
002100211130       //----------------------------------------------
002200211130         dcl-pr JAVA_toString like( JAVA_String )
002300211130                       extproc( *JAVA :'java.lang.String':
002400211130                       *constructor );
002500211130          value varchar( 65535 ) const;
002600211130         end-pr;
002701211215       //-------------------------------------------------------------------------
002702211215       //
002703211215       //-------------------------------------------------------------------------
002800211130         dcl-pr getBytes char(250) extproc(*java:'java.lang.String':'getBytes');
002900211130
003000211130         end-pr;
003101211215       //-------------------------------------------------------------------------
003102211215       //
003103211215       //-------------------------------------------------------------------------
003200211130       dcl-pr encrypt OBJECT(*JAVA : 'java.lang.String' )
003300211130              EXTPROC(*JAVA : 'Encriptar' : 'encrypt' ) STATIC;
003400211130         arg0 OBJECT(*JAVA : 'java.lang.String' );
003500211130         arg1 OBJECT(*JAVA : 'java.lang.String' );
003600211130       end-pr ;
003701211215       //-------------------------------------------------------------------------
003702211215       //
003703211215       //-------------------------------------------------------------------------
003800211130       dcl-pr Java_ToStr object
003900211130                  extproc(*JAVA:'java.lang.String':*constructor);
004000211130       Val   varchar(120) const;
004100211130       end-pr;
004101211215       //-------------------------------------------------------------------------
004300211202       dcl-s  CVV1 varchar(12) inz('577');
004400211202       dcl-s  CVV  varchar(120) inz('577');
004500211130       dcl-s  Mainkey char(16) inz('.OMNICHA2021/AAA');
004600211130       //-------------------------------------
004700211130       // Call Java method:                  *
004800211130       //      encrypt in class Encriptado   *
004900211130       //-------------------------------------
005000211130
005100211202         dsply CVV1;
005200211202         dsply Mainkey;
005300211202
005400211202
005500211130         j_encryptParam1 = JAVA_toString(Mainkey);
005600211130         j_encryptParam0 = JAVA_toString(cvv);
005700211130         str = getBytes(j_encryptParam0);
005800211130
005900211130         encryptRet = encrypt( j_encryptParam0 : j_encryptParam1);
006000211130         clear str;
006100211130         str = getBytes(encryptRet);
006200211130
006300211202         str1 = %trim(STR);
006400211202
006500211202         dsply STR1;
006600211202
006700211202
006800211130       //dsply  encryptRet;
006900211130
007000210914         *inlr = *on;
007100210914
