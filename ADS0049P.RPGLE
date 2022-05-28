000001200403      *------------------------------------------------------------------------.
000002200511      *  ID       : 128730-Opción de IBS, para cargar lotes de cuentas ADS     |
000003200511      *             sin cobrar comisión                                        |
000004200403      *  Autor    : Hernán Coreas                                              |
000005200511      *  Creacion : 2020-mayo-11                                               |
000006200403      *  Funcion  : Capurar nombre de archivo a cargado desde FTP              |
000009200403      *------------------------------------------------------------------------'
000100200402
000101200403      *-------------------------------------------------------------------------.
000102200403      * OPCIONES DE COMPILACION                                                 |
000103200403      *-------------------------------------------------------------------------'
000104200403       Ctl-Opt Option(*nodebugio:*srcstmt) DftActGrp(*No);
000105200403      *-------------------------------------------------------------------------.
000106200403      * DEFINICION DE ARCHIVOS                                                  |
000107200403      *-------------------------------------------------------------------------'
000108200511       Dcl-F ADS0049FM Workstn Indds(FuncDs) ;
000109200511       Dcl-F GLMSTL0   Disk Usage(*Input) keyed;
000110200403
000111200403      *-------------------------------------------------------------------------.
000112200403      * PARAMETROS DE ENTRADA Y SALIDA                                          |
000113200403      *-------------------------------------------------------------------------'
000120200403      *-------------------------------------------------------------------------.
000121200403      * PROCEDIMIENTO EXTERNOS                                                  |
000122200403      *-------------------------------------------------------------------------'
000123200403
000124200511        Dcl-Pr ADS0050C ExtPgm('ADS0050C');
000125200511          p_ctaCont   Char(16) CONST ;
000126200511          p_Archivo   Char(20) CONST ;
000127200511          p_CodErr    Char(03);
000128200403          p_Respuesta Char(70);
000129200403        End-Pr;
000130200403
000131200403      *-------------------------------------------------------------------------.
000132200403      * VARIABLES DE TRABAJO                                                    |
000133200403      *-------------------------------------------------------------------------'
000134200511       Dcl-S VarCtaConta    Char(16) Inz('');
000135200511       Dcl-S VarNombArchivo Char(20) Inz('');
000136200511       Dcl-S varMensaje     Char(70) Inz('');
000137200511       Dcl-S varCodMsg      Char(03) Inz('');
000138200403
000139200403      *-------------------------------------------------------------------------.
000140200403      * ESTRUCTURAS DE DATOS                                                    |
000141200403      *-------------------------------------------------------------------------'
000142200403       Dcl-Ds FuncDs;
000143200403         Procesar    Ind Pos(1);
000144200403         Salir       Ind Pos(03);
000145200511         DscCtaCont  Ind Pos(35) Inz(*On);
000146200403       End-Ds;
000147200403
000148200511       Dcl-ds pgmDS PsDs NoOpt;
000149200403          PGMNAME  *PROC;
000150200403          WRUSUARIO Char(10) Pos(254);
000151200403       End-Ds;
000200200402
000201200403      *-------------------------------------------------------------------------.
000202200403      *      L O G I C A   P R I N C I P A L                                    |
000203200403      *-------------------------------------------------------------------------'
000204200403
000300200403           NOMBRE_PGM = PGMNAME ;
000301200403
000400200403           DoW Not Salir;
000500200402
000600200403              ExFmt FMCAPTURA;
000601200511              If Salir;
000602200511               Leave;
000603200511              EndIf;
000604200403
000605200511              MENSAJE        = '';
000606200511              GLMDSC         = '';
000607200511              varMensaje     = '';
000608200511              VarNombArchivo = NOMB_ARCHI;
000609200511              varCtaConta    = %EditC( Cta_cont : 'X' );
000610200511
000611200511              DscCtaCont = ValidarCtaContable( varCtaConta );
000700200402
000800200511              If Procesar;
000814200511               If VarNombArchivo = '';
000815200511
000816200511                 varMensaje = 'Nombre de archivo incorrecto';
000817200511                 MostrarMensaje( varMensaje ) ;
000818200511
000819200511               Else;
000820200511
000900200511                  ADS0050C( varCtaConta : VarNombArchivo :
000901200511                            varCodMsg   : varMensaje );
000902200511
000903200511                  MostrarMensaje( varMensaje ) ;
000904200511                  If varCodMsg = '000';
000905200511                   Clear NOMB_ARCHI ;
000906200511                   Clear CTA_CONT;
001000200511                  EndIf;
001001200511
001100200511               EndIf;
001101200511              EndIf;
001200200402
001300200403           EndDo;
001400200402
001700200403           *InLr = *On;
001900200402
002000200403      *-------------------------------------------------------------------------.
002100200403      *  Mostrar mensaje                                                        |
002200200403      *-------------------------------------------------------------------------'
002300200403       Dcl-Proc MostrarMensaje;
002400200403        Dcl-pi *N;
002500200403           prm_txt Char(70) CONST;
002600200403        End-pi;
002700200403         Dcl-S varPosTxt Zoned(3:0) Inz(0);
002800200403         Dcl-S varDifTxt Zoned(3:0) Inz(0);
002900200403         Dcl-S varLenTxt Zoned(3:0) Inz(0);
003000200403
003100200403         varLenTxt = %Len(%TrimL(%TrimR(prm_txt)));
003200200403         varPosTxt = 70 - varLenTxt;
003300200403         Eval(H) varDifTxt = varPosTxt / 2;
003400200403         MENSAJE = '';
003500200511         MENSAJE = %REPLACE( %Trim(prm_txt) : MENSAJE: varDifTxt + 1 );
003800200403
003900200511       End-Proc;
003901200511      *-------------------------------------------------------------------------.
003902200511      *  Validar cuenta contable                                                |
003903200511      *-------------------------------------------------------------------------'
003904200511       Dcl-Proc ValidarCtaContable;
003905200511        Dcl-pi *N Ind;
003906200511           prm_cta Char(16) CONST;
003908200511        End-pi;
003909200511         Dcl-S varRespuesta Ind Inz(*Off);
003910200511         Dcl-S varGlnNum Zoned(16:0) Inz(0);
003911200511
003912200511         varGlnNum = %Dec( prm_cta : 16 : 0 );
003913200511         If  varGlnNum = 0;
003914200511           varRespuesta = *On;
003915200511           varMensaje = 'Cuenta contable invalida';
003916200511         Else;
003917200511           Chain ('01' : 'USD' : varGlnNum ) GLMSTL0;
003918200511           If Not %Found( GLMSTL0 ) ;
003919200511              varRespuesta = *On;
003920200511              varMensaje   = 'Cuenta contable no existe';
003922200511           EndIf;
003923200511         EndIf;
003924200511         If varRespuesta ;
003925200511           MostrarMensaje( varMensaje ) ;
003926200511           Procesar = *Off;
003927200511         EndIf;
003928200511
003929200511         Return varRespuesta;
003930200511
004000200511       End-Proc;
