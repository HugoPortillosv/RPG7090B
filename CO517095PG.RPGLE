000100211227       CTL-OPT THREAD(*SERIALIZE);  //DFTACTGRP(*NO);
000200211227       dcl-f CO517095FM Workstn Indds(Indicadores);
000300211216       dcl-f PFDTAKEY disk usage(*input:*update:*output) keyed;
000400211215       //***********************************************************************
000500211215       dcl-ds Indicadores len(99);
000600211215              Aceptar Ind pos(01);
000700211215              salir   Ind pos(03);
000701211220              Ocultar Ind pos(05);
000702220119              Generar Ind pos(08);
000800211215       end-ds;
000802211220       //*************************************************
000803211220       // Prototipo para las funciones de Encriptacion HAP.
000804211220       //*************************************************
000805211220       dcl-ds pgmsts psds;
000806211220         name  char(10) pos(244);
000807211220         user  char(10) pos(254);
000808211220         Jobno char(10) pos(564);
000809211220       end-ds;
000900211220       //*************************************************
001000211227       // Prototipo para las funciones de Encriptacion HAP.
001100211215       //*************************************************
001200211220       dcl-pr JvEncrip varchar(250) ;
001300211227              Entrada varchar(250) ;
001400211227       end-pr;
001500211216       //*************************************************
001600211216       // Prototipo para las funciones de Encriptacion HAP.
001700211216       //*************************************************
001800211227       dcl-pr JvDecripK varchar(250) ;       //    JvDecripK
001900211227              Entrada   varchar(250) ;
002000211227       end-pr;
002001220119       //*************************************************
002002220119       //
002003220119       //*************************************************
002004220119       dcl-pr RamdomPass  varchar(250) ;
002005220119              //Porcion  varchar(08) ;
002006220119         end-pr;
002007220119       //*************************************************
002200211216       Dcl-pr Env   Extpgm('CL51007098');
002300211216       end-pr;
002400211215       //***********************************************************************
002500211202       dcl-s  CVV1 varchar(12) inz('577');
002600211202       dcl-s  CVV  varchar(120) inz('577');
002700211130       dcl-s  Mainkey char(16) inz('.OMNICHA2021/AAA');
002800211216
002900211216       dcl-s  Sw01 char(01) ;
003000211216       dcl-s  Sw02 char(01) ;
003100211216       dcl-s  longitud  packed(3:0);
003200211216       dcl-s  Nrec packed(4:0) inz(0001);
003300211220       dcl-s  wKey char(16);
003400211216       dcl-s  CompletKey varchar(250);
003500211216       dcl-s  wKriptoKey varchar(250);
003501211227       dcl-s  wKriptoK   varchar(250);
003600211215       //-----------------------------------------------------------------------
003700211220       //  .SECUREKEY-/2021   (.OMNICHANEL2021/)
003800211215       //-----------------------------------------------------------------------
003900211216        Callp Env();
004000211220        clear sw01;
004100211216        clear sw02;
004101211227        fdatr3 = x'27'; //ND
004102211220        //*in40 = *on;
004103211220        NOMBRE_PGM = name;
004200211220        Read pfdtakey;
004300211216        if not %eof();
004400211227           wclave02 = clave02 ;
004401211220           keyact   = kriptok;
004500211216        endif;
004600220119        if clave01 = ' ' and clave02 = ' ' ;
004700220119            // Nueva llave
004800220119        endif;
004900211216        if clave01 <> ' ' and clave02 = ' ';
005000211216            // En proceso de cambio, ya esta la llave1 , falta la 2
005001211227            wclave02 = clave02;
005002211220            //MENSAJE = 'Primera porcion de llave Existe se Actualiza';
005003211220            *in30 = *on;
005100211216           if clave02 <> ' ' and clave01 <> ' ';
005200211216              // CLave02 llena, no deberia pasar
005300211215           endif;
005400211215        endif;
005401220119         // --- Decifrado de la llave
005500220119        //if kriptok <> *blank;
005501220119        //   wKriptok = %trim(kriptok);
005502220119        //   mensaje = JvDecripK(wkriptok);
005503220119        //endif;
005600211215        Dow not salir ;
005700211220            exfmt src01;
005701211220            //write src01;
005702211227            //read  src01;
005800211216            *in30 = *off;
005801211227            fdatr1 = x'20';  //GRN
005802211227            fdatr2 = x'20';  //ND
005803211227            fdatr3 = x'27';
005804211220            *in25 = *off;
005805220119            //clear keyact;  ** ojo
005806211220            //*in40 = *off;
005807211220            //FDATR = x'20';
005900211216            clear mensaje;
005901211220             //
005902211220            if Ocultar ;
005903211220             if *in40 = *off;
005904211220               *in40 = *on;
005905211220               FDATR = x'27';
005906211220               else;
005907211227               *in40 = *off;
005908211220               FDATR = x'20';
005909211220             endif;
005912211220             iter;
005913211220            endif;
005914220119           //----------------------------------------
005915220119            if  Generar ;
005916220119                Wclave02 = RamdomPass();
005917220119                iter;
005918220119            endif;
005919220119           //----------------------------------------
005920220119            if not salir ;
006001211227                if Wclave02 = ' ';
006002211227                   MENSAJE = 'Segunda porcion de llave esta en blanco';
006003211220                   *in30  = *on;
006004211220                   fdatr1 = x'23';
006005211220                   iter;
006006211220                endif;
006007211227                if %len(%trim(Wclave02)) <> 8;
006008211227                   MENSAJE = 'Logitud incorrecta de Porcion 02 de la llave';
006009211220                   *in30 = *on;
006010211220                   fdatr1 = x'23';
006011211220                   iter;
006012211220                endif;
006100211220             if Aceptar ; // Validacion en el momento que hace la peticion
006200211227                if Wclave02 = ' ';
006300211227                   MENSAJE = 'Segunda porcion de llave esta en blanco';
006400211220                   *in30  = *on;
006401211220                   fdatr1 = x'23';
006500211216                   iter;
006600211216                endif;
006700211227                if %len(%trim(Wclave02)) <> 8;
006800211227                   MENSAJE = 'Logitud incorrecta de Porcion 02 de la llave';
006900211216                   *in30 = *on;
006901211220                   fdatr1 = x'23';
007000211216                   iter;
007100211216                endif;
007200211227                if clave01 <> ' ' and wclave02 <> *blanks;
007300211216                // Generar , la llave encriptada.
007400211227                 wkey = clave01 + wclave02;
007500211216                 CompletKey = %trim(wkey);
007600211216                 wKriptoKey = JvEncrip(CompletKey); // Encriptado
007700211216                 chain Nrec rcdtakey;
007800211216                  if %found();
008000211227                     clave01 = *blanks;
008001211227                     clave02 = *blanks;
008100211216                     Keydata = *blanks;
008200211216                     Kriptok = wKriptokey;
008300211227                     //user01  = user;
008400211227                     user02  = user;
008500211227                     //fecha01 = %timestamp();
008600211216                     fecha02 = %timestamp();
008700211216                     update rcdtakey %fields(Clave01:clave02:Keydata:kriptok
008800211216                                             :user01:user02:fecha01:fecha02);
008801220119                     clear wclave02;
008802220119                     keyact = kriptok;
008901211220                     MENSAJE = 'La Llave se Cifro con Exito';
008902211227                    *in30  = *on;
008903211227                    *in25  = *on;
008904211227                    keysec = Kriptok;
008905211227                    keyact = kriptok;
008906211227                    fdatr2 = x'21';
008907211227                    fdatr3 = x'38'; //Pink
009000211227                    else;
009100211216                      keynum  = Nrec;
009200211227                      clave02 = *blank;
009400211216                      keydata = *blank;
009501211227                      Kriptok = wKriptokey;
009600211227                      user02  = user;
009700211216                    //  user02  = *blank;
009800211227                      fecha02 = %timestamp();
010000220119                     write rcdtakey;
010001220119                     clear wclave02;
010002211227                     keyact = kriptok;
010003211227                     MENSAJE = 'La Llave se Cifro con Exito';
010004211227                    *in30 = *on;
010005211227                    *in25 = *on;
010006211227                    keysec = Kriptok;
010007211227                    keyact = kriptok;
010008211227                    fdatr2 = x'21';
010009211227                    fdatr3 = x'38'; //Pink
010100211216                  endif;
010200211216                endif;
010300220119                if %len(%trim(wclave02)) = 8 and clave01 = *blank;
010400211216                 chain Nrec rcdtakey;
010500211216                  if %found();
010600211227                     clave02 = wclave02;
010601211227                     user02  = user;
010603211227                     fecha02 = %timestamp();
010700211227                     update rcdtakey %fields(Clave02:user02:fecha02);
010701211227                     MENSAJE = 'Segunda porcion Actualizada';
010702211220                     *in30 = *on;
010703220119                    else;
010704220119                      keynum  = Nrec;
010705220119                      clave01 = *blank;
010706220119                      clave02 = wclave02;
010707220119                      keydata = *blank;
010708220119                      kriptok = *blank;
010709220119                      user02  = user;
010710220119                      //user01  = *blank;
010711220119                      fecha01 = %timestamp();
010712220119                      clear     fecha01;
010713220119                      write rcdtakey;
010714220119                      MENSAJE = 'Segunda porcion de llave se ingreso';
010715220119                     *in30 = *on;
010716220119                  endif;
012000211227                    iter;
012100211227                  endif;
012300211227                endif;
012400211215            endif;
012401220119        enddo;
012600211215        *inlr = *on;
