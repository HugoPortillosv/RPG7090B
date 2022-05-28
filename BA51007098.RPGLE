000100211203       //***********************************************************************
000102211203       //
000103211203       //
000104211203       //
000105211203       //***********************************************************************
000106211203       ctl-opt nomain;
000107211206       ctl-opt thread(*SERIALIZE); // dftactgrp(*NO);
000200211203
000300211130       //-----------------------------------------------
000400211130       //
000500211130       //
000600211130       // Valores de retorno, de la Clase
000700211130       //-----------------------------------------------
000701211203
000702211206       Dcl-s Key  char(16)   dtaara('CLEARKEY');
000703211203
000704211203       //***********************************************************************
000705211206       dcl-proc JvEncrip Export;
000706211203         dcl-pi *N varchar(250) ;
000707211203          Entrada   varchar(250) ;
000708211203         end-pi;
000710211203       //***********************************************************************
000800211130       dcl-s encryptRet OBJECT(*JAVA : 'java.lang.String');
000900211130       dcl-s JAVA_String object(*JAVA :'java.lang.String');
001000211202       dcl-s str  varchar(250);
001100211206       dcl-s str1 varchar(120);
001200211130       //-------------------------------------------------------------------------
001300211130       //   Declaracion de Parametros para la Clase Encripta
001400211130       //
001500211130       //-------------------------------------------------------------------------
001600211130       dcl-s j_encryptParam0 OBJECT(*JAVA : 'java.lang.String' );
001700211130       dcl-s j_encryptParam1 OBJECT(*JAVA : 'java.lang.String' );
001800211130       //----------------------------------------------
001900211130       //  Declaracion de Prototipo : para la Clase
002000211130       //
002100211130       //----------------------------------------------
002200211203       dcl-pr JAVA_toString like( JAVA_String )
002300211130                       extproc( *JAVA :'java.lang.String':
002400211130                       *constructor );
002500211130          value varchar( 65535 ) const;
002600211203       end-pr;
002700211130
002800211203       dcl-pr getBytes char(250) extproc(*java:'java.lang.String':'getBytes');
002900211130
003000211203       end-pr;
003100211130
003200211130       dcl-pr encrypt OBJECT(*JAVA : 'java.lang.String' )
003300211130              EXTPROC(*JAVA : 'Encriptar' : 'encrypt' ) STATIC;
003400211203               arg0 OBJECT(*JAVA : 'java.lang.String' );
003500211203               arg1 OBJECT(*JAVA : 'java.lang.String' );
003600211130       end-pr ;
003700211130
003800211130       dcl-pr Java_ToStr object
003900211130                  extproc(*JAVA:'java.lang.String':*constructor);
004000211203            Val   varchar(120) const;
004100211130       end-pr;
004200211130
004600211130       //-------------------------------------
004700211203       //  Call Java method:                  *
004800211203       //  encrypt in class Encriptado        *
004900211203       //----------------------------------   *
005000211203         in Key;
005001211203
005500211203         j_encryptParam1 = JAVA_toString(Key);
005600211203         j_encryptParam0 = JAVA_toString(Entrada);
005700211130         str = getBytes(j_encryptParam0);
005800211130
005900211130         encryptRet = encrypt( j_encryptParam0 : j_encryptParam1);
006100211130         str = getBytes(encryptRet);
006300211202         str1 = %trim(STR);
006400211202
006900211203         return str1;
007001211203
007002211203       end-proc;
007100210914
