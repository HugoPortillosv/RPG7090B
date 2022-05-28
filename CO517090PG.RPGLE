000100211216       CTL-OPT THREAD(*SERIALIZE);  //DFTACTGRP(*NO);
000200211215       dcl-f CO517090FM Workstn Indds(Indicadores);
000300220118       dcl-f PFDTAKEY disk usage(*input:*update:*output) keyed;
000400211215       //***********************************************************************
000500211215       dcl-ds Indicadores len(99);
000600211215              Aceptar Ind pos(01);
000700211215              salir   Ind pos(03);
000701211220              Ocultar Ind pos(05);
000702220118              Generar Ind pos(08);
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
001000211215       // Prototipo para las funciones de Encriptacion HAP.
001100211215       //*************************************************
001200211220       dcl-pr JvEncrip varchar(250) ;
001300211216           Entrada varchar(250) ;
001400211220         end-pr;
001500211216       //*************************************************
001600211216       // Prototipo para las funciones de Encriptacion HAP.
001700211216       //*************************************************
001800211216       dcl-pr JvDecrypt varchar(250) ;
001900211216           Entrada1 varchar(250) ;
002000211216         end-pr;
002001220118       //*************************************************
002002220118       //
002003220118       //*************************************************
002004220118       dcl-pr RamdomPass  varchar(250) ;
002005220118              //Porcion  varchar(08) ;
002006220118         end-pr;
002100211216       //*************************************************
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
003600211215       //-----------------------------------------------------------------------
003700220118       //  .SECUREKEY-/2021   (.OMNICHANEL2021/)
003800211215       //-----------------------------------------------------------------------
003900211216        Callp Env();
004000211220        clear sw01;
004100211216        clear sw02;
004101220118        fdatr3 = x'27'; //ND
004102220118        //*in40 = *on;
004104211220        NOMBRE_PGM = name;
004200211220        Read pfdtakey;
004300211216        if not %eof();
004400211220           wclave01 = clave01 ;
004401211220           keyact   = kriptok;
004500211216        endif;
004600211215        if clave01 = ' ' and clave02 = ' ' ;
004700211215            // Nueva llave
004800211215        endif;
004900211216        if clave01 <> ' ' and clave02 = ' ';
005000211216            // En proceso de cambio, ya esta la llave1 , falta la 2
005001211220            wclave01 = clave01;
005002211220            //MENSAJE = 'Primera porcion de llave Existe se Actualiza';
005003211220            *in30 = *on;
005100211216           if clave02 <> ' ' and clave01 <> ' ';
005200211216              // CLave02 llena, no deberia pasar
005300211215           endif;
005400211215        endif;
005500211215
005600211215        Dow not salir ;
005700211220            exfmt src01;
005701211220            //write src01;
005702211220            //read  src01;
005800211216            *in30 = *off;
005801211220            fdatr1 = x'20';
005802211220            *in25 = *off;
005803211220            //*in40 = *off;
005804211220            //FDATR = x'20';
005900211216            clear mensaje;
005902220118           //----------------------------------------
005903211220            if Ocultar ;
005904211220             if *in40 = *off;
005905211220               *in40 = *on;
005906211220               FDATR = x'27';
005907211220               else;
005908211220               *in40 = *off;
005909211220               FDATR = x'20';
005910211220             endif;
005912211220             iter;
005913211220            endif;
005914220118           //----------------------------------------
005915220118            if  Generar ;
005916220118                Wclave01 = RamdomPass();
005917220118                iter;
005918220118            endif;
005919220118           //----------------------------------------
006000211220            if not salir ;
006001211220                if Wclave01 = ' ';
006002211220                   MENSAJE = 'Primera porcion de llave esta en blanco';
006003211220                   *in30  = *on;
006004211220                   fdatr1 = x'23';
006005211220                   iter;
006006211220                endif;
006007211220                if %len(%trim(Wclave01)) <> 8;
006008211220                   MENSAJE = 'Logitud incorrecta de Porcion 01 de la llave';
006009211220                   *in30 = *on;
006010211220                   fdatr1 = x'23';
006011211220                   iter;
006012211220                endif;
006100211220             if Aceptar ; // Validacion en el momento que hace la peticion
006200211220                if Wclave01 = ' ';
006300211216                   MENSAJE = 'Primera porcion de llave esta en blanco';
006400211220                   *in30  = *on;
006401211220                   fdatr1 = x'23';
006500211216                   iter;
006600211216                endif;
006700211220                if %len(%trim(Wclave01)) <> 8;
006800211216                   MENSAJE = 'Logitud incorrecta de Porcion 01 de la llave';
006900211216                   *in30 = *on;
006901211220                   fdatr1 = x'23';
007000211216                   iter;
007100211216                endif;
007200211220                if clave02 <> ' ' and wclave01 <> *blanks;
007300211216                // Generar , la llave encriptada.
007400211216                 wkey = wclave01 + clave02;
007500211216                 CompletKey = %trim(wkey);
007600211216                 wKriptoKey = JvEncrip(CompletKey); // Encriptado
007700211216                 chain Nrec rcdtakey;
007800211216                  if %found();
007900211216                     clave01 = *blanks;
008000211216                     clave02 = *blanks;
008100220118                     Keydata = *blanks;
008200211216                     Kriptok = wKriptokey;
008300211220                     user01  = user;
008301211220                     keydata = *blank;
008400211220                    // user02  = user;
008500211216                     fecha01 = %timestamp();
008600211220                    // fecha02 = %timestamp();
008700211220                     update rcdtakey %fields(clave01:clave02
008701211220                                             :Keydata:kriptok:fecha01:user01);
008702220118                     clear wclave01;
008900211216                     keyact = kriptok;
008901211220                     MENSAJE = 'La Llave se Cifro con Exito';
008902211220                    *in30 = *on;
008903211220                    *in25 = *on;
008904220118                    keysec = Kriptok;
008905220118                    keyact = kriptok;
008907220118                    fdatr2 = x'21';
008908220118                    fdatr3 = x'38'; //Pink
008909220118                    else;
009100220118                     keynum  = Nrec;
009200220118                     clave01 = *blank;
009300220118                     clave02 = *blank;
009400220118                     keydata = *blank;
009501220118                     Kriptok = wKriptokey;
009600220118                     user01  = user;
009700211216                    //  user02  = *blank;
009800220118                     fecha01 = %timestamp();
009801220118                     fecha02 = %timestamp();
010000220118                     write rcdtakey; // Ingreso de registro de Lleva
010001220118                     clear wclave01;
010002220118                     MENSAJE = 'La Llave se Cifro con Exito';
010003220118                     *in30 = *on;
010004220118                     *in25 = *on;
010005220118                     keysec = Kriptok;
010006220118                     keyact = kriptok;
010007220118                     fdatr2 = x'21';
010008220118                     fdatr3 = x'38'; //Pink
010009220118                  endif;
010200211216                endif;
010300211220                if %len(%trim(wclave01)) = 8 and clave02 = *blank;
010400211216                 chain Nrec rcdtakey;
010500211216                  if %found();
010600211220                     clave01 = wclave01;
010601211220                     user01  = user;
010603211220                     fecha01 = %timestamp();
010700211220                     update rcdtakey %fields(Clave01:user01:fecha01);
010701211220                     MENSAJE = 'Primera porcion Actualizada';
010702211220                     *in30 = *on;
010800211220                    else;
010900211216                      keynum  = Nrec;
011000211216                      clave01 = wclave01;
011100211216                      clave02 = *blank;
011200211216                      keydata = *blank;
011300211216                      kriptok = *blank;
011400211220                      user01  = user;
011500211220                   //   user02  = *blank;
011600211216                      fecha01 = %timestamp();
011700211216                      clear     fecha02;
011800211216                      write rcdtakey;
011801211220                      MENSAJE = 'Primera porcion de llave se ingreso';
011802211220                     *in30 = *on;
011900211216                  endif;
012000211216                  iter;
012100211216                endif;
012300211216             endif;
012400211215            endif;
012500211215        enddo;
012600211215        *inlr = *on;
