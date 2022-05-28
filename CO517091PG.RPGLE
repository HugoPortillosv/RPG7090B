000100211203       //***********************************************************************
000102211203       //
000103211203       //
000104211203       //
000105211203       //***********************************************************************
000106211203       ctl-opt nomain;
000107211206       ctl-opt thread(*SERIALIZE); // dftactgrp(*NO);
000200211216       dcl-f PFDTAKEY disk usage(*input:*update:*output) keyed usropn;
000300211130       //-----------------------------------------------
000400211130       //
000500211130       //
000600211130       // Valores de retorno, de la Clase
000700211130       //-----------------------------------------------
000701211203
000702211216       //Dcl-s Key  char(16)   dtaara('CLEARKEY');
000703211216       Dcl-s Key  char(16);
000704211203
000705211203       //***********************************************************************
000706211216       //
000707211216       //
000708211216       //***********************************************************************
000709211206       dcl-proc JvEncrip Export;
000710211203         dcl-pi *N varchar(250) ;
000711211203          Entrada   varchar(250) ;
000712211203         end-pi;
000713211203       //***********************************************************************
000800211130       dcl-s encryptRet OBJECT(*JAVA : 'java.lang.String');
000900211130       dcl-s JAVA_String object(*JAVA :'java.lang.String');
001000211202       dcl-s str  varchar(250);
001100211206       dcl-s str1 varchar(120);
001101211216       dcl-s CipherKey varchar(250);
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
003800211216       //dcl-pr Java_ToStr object
003900211216       //           extproc(*JAVA:'java.lang.String':*constructor);
004000211216       //     Val   varchar(120) const;
004100211216       //end-pr;
004200211130
004600211130       //-------------------------------------
004700211203       //  Call Java method:                  *
004800211203       //  encrypt in class Encriptado        *
004900211203       //----------------------------------   *
005000211216         //in Key;
005001211216         Key = '.SECUREKEY-/2021';
005004211216
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
007101211216       //***********************************************************************
007102211216       // Key Decript Values.
007103211216       // Only for Key decripted
007104211216       //***********************************************************************
007105211216       dcl-proc JvDecripK Export;
007106211216         dcl-pi *N  varchar(250) ;
007107211216          Entrada   varchar(250) ;
007108211216         end-pi;
007109211216       //***********************************************************************
007110211216       dcl-s DecryptRet OBJECT(*JAVA : 'java.lang.String');
007111211216       dcl-s JAVA_String object(*JAVA :'java.lang.String');
007112211216       dcl-s str  varchar(250);
007113211216       dcl-s str1 varchar(120);
007114211216       //-------------------------------------------------------------------------
007115211216       //   Declaracion de Parametros para la Clase Encripta
007116211216       //
007117211216       //-------------------------------------------------------------------------
007118211216       dcl-s j_DecryptParam0 OBJECT(*JAVA : 'java.lang.String' );
007119211216       dcl-s j_DecryptParam1 OBJECT(*JAVA : 'java.lang.String' );
007120211216       //----------------------------------------------
007121211216       //  Declaracion de Prototipo : para la Clase
007122211216       //
007123211216       //----------------------------------------------
007124211216       dcl-pr JAVA_toString like( JAVA_String )
007125211216                       extproc( *JAVA :'java.lang.String':
007126211216                       *constructor );
007127211216          value varchar( 65535 ) const;
007128211216       end-pr;
007129211216
007130211216       dcl-pr getBytes char(250) extproc(*java:'java.lang.String':'getBytes');
007131211216
007132211216       end-pr;
007133211216
007134211216       dcl-pr decrypt OBJECT(*JAVA : 'java.lang.String' )
007135211216              EXTPROC(*JAVA : 'Encriptar' : 'decrypt' ) STATIC;
007136211216               arg0 OBJECT(*JAVA : 'java.lang.String' );
007137211216               arg1 OBJECT(*JAVA : 'java.lang.String' );
007138211216       end-pr ;
007139211216
007140211216       //dcl-pr Java_ToStr object
007141211216       //           extproc(*JAVA:'java.lang.String':*constructor);
007142211216       //     Val   varchar(120) const;
007143211216       //end-pr;
007144211216
007145211216       //-------------------------------------
007146211216       //  Call Java method:                  *
007147211216       //  encrypt in class Encriptado        *
007148211216       //----------------------------------   *
007150211216         //Entrada = CipherKey();
007151211216         //key = %trim(JvDecrypt(CipherK));
007152211216         Key = '.SECUREKEY-/2021';
007153211216
007154211216         j_decryptParam1 = JAVA_toString(Key);
007155211216         j_decryptParam0 = JAVA_toString(Entrada);
007156211216         str = getBytes(j_decryptParam0);
007157211216
007158211216         DecryptRet = decrypt( j_decryptParam0 : j_decryptParam1);
007159211216         str = getBytes(decryptRet);
007160211216         str1 = %trim(STR);
007161211216
007162211216         return str1;
007163211216
007164211216       end-proc;
007229211216                              // aqui
007230211216       //**********************************************************************
007231211216       //
007232211216       //**********************************************************************
007233211216       dcl-proc JvEncripDt Export;
007234211216         dcl-pi *N varchar(250) ;
007235211216          Entrada   varchar(250);
007236211216          Cipherk   varchar(250);
007237211216         end-pi;
007238211216       //***********************************************************************
007239211216       dcl-s encryptRet OBJECT(*JAVA : 'java.lang.String');
007240211216       dcl-s JAVA_String object(*JAVA :'java.lang.String');
007241211216       dcl-s str  varchar(250);
007242211216       dcl-s str1 varchar(120);
007243220120       //dcl-s CipherK varchar(250);
007244211216       //-------------------------------------------------------------------------
007245211216       //   Declaracion de Parametros para la Clase Encripta
007246211216       //
007247211216       //-------------------------------------------------------------------------
007248211216       dcl-s j_encryptParam0 OBJECT(*JAVA : 'java.lang.String' );
007249211216       dcl-s j_encryptParam1 OBJECT(*JAVA : 'java.lang.String' );
007250211216       //----------------------------------------------
007251211216       //  Declaracion de Prototipo : para la Clase
007252211216       //
007253211216       //----------------------------------------------
007254211216       dcl-pr JAVA_toString like( JAVA_String )
007255211216                       extproc( *JAVA :'java.lang.String':
007256211216                       *constructor );
007257211216          value varchar( 65535 ) const;
007258211216       end-pr;
007259211216
007260211216       dcl-pr getBytes char(250) extproc(*java:'java.lang.String':'getBytes');
007261211216
007262211216       end-pr;
007263211216
007264211216       dcl-pr encrypt OBJECT(*JAVA : 'java.lang.String' )
007265211216              EXTPROC(*JAVA : 'Encriptar' : 'encrypt' ) STATIC;
007266211216               arg0 OBJECT(*JAVA : 'java.lang.String' );
007267211216               arg1 OBJECT(*JAVA : 'java.lang.String' );
007268211216       end-pr ;
007269211216
007274211216       //-------------------------------------
007275211216       //  Call Java method:                  *
007276211216       //  encrypt in class Encriptado        *
007277211216       //----------------------------------   *
007278211216         //in Key;
007280211216         //CipherK = CipherKey();
007281211216         //Key = '.SECUREKEY-/2021';
007282211216         key = JvDecripK(CipherK);
007283211216
007284211216         j_encryptParam1 = JAVA_toString(Key);
007285211216         j_encryptParam0 = JAVA_toString(Entrada);
007286211216         str = getBytes(j_encryptParam0);
007287211216
007288211216         encryptRet = encrypt( j_encryptParam0 : j_encryptParam1);
007289211216         str = getBytes(encryptRet);
007290211216         str1 = %trim(STR);
007291211216
007292211216         return str1;
007293211216
007294211216       end-proc;
007295211216       // --------------------------------------------------
007296211216       // Procedure name: CipherKey
007297211216       // Purpose:        Get Value Cipher Key to Decript
007298211216       // Returns:        Cipher String Key Value
007299211216       // --------------------------------------------------
007300211216       dcl-proc CipherKey Export;
007301211216         dcl-pi *N CHAR(250);
007302211216         end-pi;
007303211216                // Local fields
007304211216
007305211216         dcl-s wCipherKey CHAR(250);
007306211216                // Calculation specifications
007307211216         open pfdtakey;
007308211216         Read pfdtakey;
007309211216         if not %eof();
007310211216            wCipherKey = %trim(kriptok);
007311211216         endif;
007312211216         close pfdtakey;
007313211216         return wCipherKey;
007314211216       end-proc;
007315211216
