/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³NUMTOSTR  ³ Autor ³                       ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Numeros a Letras                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#include "rwmake.ch"  

USER FUNCTION NumToStr( nNum, nLen )

   LOCAL aUnidad, ;
         aDecena, ;
         aCentena, ;
         aMil, ;
         cLet := Space( 0 ), ;
         cAux := Space( 0 ), ;
         nDec := Val( Str( ( nNum - Int( nNum ) ) * 100, 2 ) ) ,;
         n    := 0, ;
         aImp := Array( 0 )

/*
 Las variables nNum, nLen y aImp se refieren al número a convertir, al largo máximo por línea del string a
 generar, y al arreglo que contendrá las líneas correspondiente al texto que se ha generado a partir de nNum,
 respectivamente.  Deben ser inicializados en el programa padre.
 */

   aUnidad  := { "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez", ;
                 "once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", "dieciocho", "diecinueve", ;
                 "veinte", "veintiuno", "veintidos", "veintitres", "veinticuatro", "veinticinco", "veintiseis", ;
                 "veintisiete", "veintiocho", "veintinueve" }
   aDecena  := { "diez", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa" }
   aCentena := { "cien", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", ;
                 "setecientos", "ochocientos", "novecientos" }
   aMil     := { "un", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez", ;
                 "once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", "dieciocho", "diecinueve", ;
                 "veinte", "veintiun", "veintidos", "veintitres","veinticuatro", "veinticinco", "veintiseis", ;
                 "veintisiete", "veintiocho", "veintinueve" }

/*If nNum > 1   
   IF nNum <= 1
      cLet := aUnidad[ nNum ] 
*/ 
IF nNum < 1
  cLet := "cero"
ELSE
   IF nNum < 30 
      cLet := aUnidad[ nNum ]     
   ELSEIF nNum < 100
      cLet := aDecena[ Val( Left( Str( Int( nNum ), 2 ), 1 ) ) ]
      IF Val( Right( Str( Int( nNum ), 2 ), 1 ) ) > 0
         cLet := cLet + " y " + ;
                 aUnidad[ Val( Right( Str( Int( nNum ), 2 ), 1 ) ) ]
      ENDIF
   ELSEIF nNum < 1000
      cLet := aCentena[ Val( Left( Str( Int( nNum ), 3 ), 1 ) ) ]
      IF nNum > 100 .AND. nNum < 200
         cLet := cLet + "to"
      ENDIF
      IF Val( Right( Str( Int( nNum ), 3 ), 2 ) ) < 30 .AND. ;
         Val( Right( Str( Int( nNum ), 3 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aUnidad[ Val( Right( Str( Int( nNum ), 3 ), 2 ) ) ]
      ELSEIF Val( Right( Str( Int( nNum ), 3 ), 2 ) ) < 100 .AND. ;
         Val( Right( Str( Int( nNum ), 3 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aDecena[ Val( SubStr( Str( Int( nNum ), 3 ), 2, 1 ) ) ]
         IF Val( Right( Str( Int( nNum ), 3 ), 1 ) ) > 0
            cLet := cLet + " y " + ;
                    aUnidad[ Val( Right( Str( Int( nNum ), 3 ), 1 ) ) ]
         ENDIF
      ENDIF
   ELSEIF nNum < 100000
      IF Val( Left( Str( Int( nNum ), 5 ), 2 ) ) < 30
         cLet := aMil[ Val( Left( Str( Int( nNum ), 5 ), 2 ) ) ]
      ELSE
         cLet := aDecena[ Val( Left( Str( Int( nNum ), 5 ), 1 ) ) ]
         IF Val( SubStr( Str( Int( nNum ), 5 ), 2, 1 ) ) > 1
            cLet := cLet + " y " + ;
                    aUnidad[ Val( SubStr( Str( Int( nNum ), 5 ), 2, 1 ) ) ]
         ELSEIF Val( SubStr( Str( Int( nNum ), 5 ), 2, 1 ) ) > 0
            cLet := cLet + " y un"
         ENDIF
      ENDIF
      cLet := cLet + " mil"
      IF Val( Right( Str( Int( nNum ), 5 ), 3 ) ) > 99
         cLet := cLet + " " + ;
                 aCentena[ Val( Left( Right( Str( Int( nNum ), 5 ), 3 ), 1 ) ) ]
         IF Val( Right( Str( Int( nNum ), 5 ), 3 ) ) > 100 .AND. ;
            Val( Right( Str( Int( nNum ), 5 ), 3 ) ) < 200
            cLet := cLet + "to"
         ENDIF
      ENDIF
      IF Val( Right( Str( Int( nNum ), 5 ), 2 ) ) < 30 .AND. ;
         Val( Right( Str( Int( nNum ), 5 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aUnidad[ Val( Right( Str( Int( nNum ), 5 ), 2 ) ) ]
      ELSEIF Val( Right( Str( Int( nNum ), 5 ), 2 ) ) < 100 .AND. ;
         Val( Right( Str( Int( nNum ), 5 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aDecena[ Val( Left( Right( Str( Int( nNum ), 5 ), 2 ), 1 ) ) ]
         IF Val( Right( Str( Int( nNum ), 5 ), 1 ) ) > 0
            cLet := cLet + " y " + ;
                    aUnidad[ Val( Right( Str( Int( nNum ), 5 ), 1 ) ) ]
         ENDIF
      ENDIF
   ELSEIF nNum < 1000000
      cLet := aCentena[ Val( Left( Str( Int( nNum ), 6 ), 1 ) ) ]
      IF Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 2 ) ) > 0 .AND. ;
         Val( Left( Str( Int( nNum ), 6 ), 3 ) ) < 200
         cLet := cLet + "to"
      ENDIF
      IF Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 2 ) ) < 30 .AND. ;
         Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aMil[ Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 2 ) ) ]
      ELSEIF Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aDecena[ Val( SubStr( Left( Str( Int( nNum ), 6 ), 3 ), 2, 1 ) ) ]
         // Diegho - 14/08/02
         IF Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 1 ) ) > 1 .and. Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 1 ) ) <> 0
            cLet := cLet + " y " + ;
                    aUnidad[ Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 1 ) ) ]
         ELSEIF Val( Right( Left( Str( Int( nNum ), 6 ), 3 ), 1 ) ) <> 0
            cLet := cLet + " y un"
         ENDIF
         // Diegho - 14/08/02
      ENDIF
      cLet := cLet + " mil"
      IF Val( Right( Str( Int( nNum ), 6 ), 3 ) ) > 99
         cLet := cLet + " " + ;
                 aCentena[ Val( Left( Right( Str( Int( nNum ), 6 ), 3 ), 1 ) ) ]
         IF Val( Right( Str( Int( nNum ), 6 ), 3 ) ) > 100 .AND. ;
            Val( Right( Str( Int( nNum ), 6 ), 3 ) ) < 200
            cLet := cLet + "to"
         ENDIF
      ENDIF
      IF Val( Right( Str( Int( nNum ), 6 ), 2 ) ) < 30 .AND. ;
         Val( Right( Str( Int( nNum ), 6 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aUnidad[ Val( Right( Str( Int( nNum ), 6 ), 2 ) ) ]
       ELSEIF Val( Right( Str( Int( nNum ), 6 ), 2 ) ) < 100 .AND. ;
         Val( Right( Str( Int( nNum ), 6 ), 2 ) ) > 0
         cLet := cLet + " " + ;
                 aDecena[ Val( Left( Right( Str( Int( nNum ), 6 ), 2 ), 1 ) ) ]
         IF Val( Right( Str( Int( nNum ), 6 ), 1 ) ) > 0
            cLet := cLet + " y " + ;
                    aUnidad[ Val( Right( Str( Int( nNum ), 6 ), 1 ) ) ]
         ENDIF
      ENDIF
   ENDIF
EndIf
   IF nNum > Int( nNum )
     If nNum > 0.99
      IF nDec < 30
         cLet := cLet + " con " + aMil[ nDec ]
      ELSEIF nDec < 100
         cLet := cLet + " con " + ;
                 aDecena[ Val( Left( Str( nDec, 2 ), 1 ) ) ]
         IF Val( Right( Str( nDec, 2 ), 1 ) ) > 0
            cLet := cLet + " y " + ;
                    aUnidad[ Val( Right( Str( nDec, 2 ), 1 ) ) ]
         ENDIF
      ENDIF
      cLet := cLet + If( nDec > 1, " ctvos.", " ctvo." )
     Else                                                //rip
       IF nDec < 30
           cLet := cLet + "  " + aMil[ nDec ]
       EndIf
           cLet := cLet + If( nDec > 1, " ctvos.", " ctvo." )
     ENDIF
   ENDIF

   cLet := Stuff( cLet, 1, 1, Upper( Left( cLet, 1 ) ) )
   aImp := Array( 0 )

   FOR n := 1 TO Len( cLet )
      cAux := cAux + SubStr( cLet, n, 1 )
      IF Len( cAux ) >= nLen
         AAdd( aImp, SubStr( cAux, 1, RAt( Space( 1 ), cAux ) - 1 ) )
         cAux := SubStr( cAux, RAt( Space( 1 ), cAux ) + 1 )
      ENDIF
   NEXT

   IF n >= Len( cLet ) .AND. !Empty( Len( cAux ) ) .AND. Len( cAux ) < nLen
      AAdd( aImp, cAux )
   ENDIF        
//msgstop(cLet)
RETURN aImp



