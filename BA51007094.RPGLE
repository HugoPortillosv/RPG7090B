000100211005      **************************************************************************
000200211005      *  BAC.
000300211005      *  OMNICANAL PERSONAS
000400211005      *  Hugo Alexander Portillo ..
000500211005      *
000600211005      **************************************************************************
000700211005     H DFTACTGRP(*NO) BNDDIR('QC2LE') option(*SRCSTMT: *NODEBUGIO)
000800211005     H ACTGRP(*NEW)
000900211005
001000211005     D* data            s             30A   inz('Prueba De Encriptacion')
001100211005     D* key             s             16A   varying inz('llaveSecreta')
001200211005     D* encrypted       s             10A
001300211005
001400211005     D RC4_Controls    ds                  qualified
001500211005     D   funct_id                     2A
001600211005     D   datalen                      5I 0
001700211005     D   operation                    1A
001800211005     D   reserved                    11A
001900211005     D   p_key_ctx                     *
002000211005
002100211005     D key_ctx         ds                  qualified
002200211005     D   stream                     256A
002300211005     D   len                          5U 0
002400211005     D   reserved                     6A
002500211005
002600211005     D cipher          PR                  extproc('_CIPHER')
002700211005     D  receiver                       *
002800211005     D  control                      32A
002900211005     D  source                         *
003000211005
003100211005     D p_recv          s               *
003200211005     D p_src           s               *
003300211005
003400211005      /free
003500211005       Dcl-s Key  char(16)   dtaara('CLEARKEY');
003600211005
003700211023       dcl-pi BA51007094;
003800211005         wData       char(30); //Datos limpios
003900211005         wKey        char(16);  //Llave
004000211005         wEncrypted  char(10); //Valor cifrado
004100211005         wEncDec     char(01);  //Varible, 1=Encriptar 2=Decriptar
004200211005       end-pi;
004300211005
004400211005       in Key; // Recuperar la LLave para el sifrado...
004500211005
004600211005        wKey = Key;
004700211005        if wEncDec = '1';
004800211005          key_ctx = *ALLx'00';
004900211005          %subst(key_ctx.stream:1:%len(wkey)) = wkey;
005000211005          key_ctx.len = %len(wkey);
005100211005
005200211005          RC4_Controls = *ALLx'00';
005300211005          RC4_Controls.funct_id = x'0013';
005400211005          RC4_Controls.datalen  = %size(wdata);
005500211005          RC4_Controls.operation = x'00';         // 0=Encrypt,1=Decrypt
005600211005          RC4_Controls.p_key_ctx = %addr(key_ctx);
005700211005
005800211005          p_recv = %addr(wEncrypted);
005900211005          p_src  = %addr(wdata);
006000211005
006100211005          cipher( p_recv: RC4_Controls: p_src);
006200211005
006300211005       elseif wEncDec = '2';
006400211005          wdata = *blanks;
006500211005
006600211005          key_ctx = *ALLx'00';
006700211005          %subst(key_ctx.stream:1:%len(wkey)) = wkey;
006800211005          key_ctx.len = %len(wkey);
006900211005
007000211005          RC4_Controls = *ALLx'00';
007100211005          RC4_Controls.funct_id = x'0013';
007200211005          RC4_Controls.datalen  = %size(wdata);
007300211005          RC4_Controls.operation = x'01';         // 0=Encrypt,1=Decrypt
007400211005          RC4_Controls.p_key_ctx = %addr(key_ctx);
007500211005
007600211005          p_recv = %addr(wdata);
007700211005          p_src  = %addr(wEncrypted);
007800211005
007900211005          cipher( p_recv: RC4_Controls: p_src);
008000211005
008100211005       endif;
008200211005          *inlr = *on;
008300211005      /end-free
008400211005
008500211005
