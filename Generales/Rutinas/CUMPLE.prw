#Include "Protheus.Ch"
#Define ENTER Chr(13)+Chr(10)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ ABM de cumplea๑os     ("Z03")			                    บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function Z03ABM

Private cCadastro := "ABM CUMPLEAัOS"
Private cString   := "Z03"                                          
Private bCampo    := {|nField| FieldName(nField) }

Private cDelFunc  := "u_Z03ABM1J()" // Validaci๓n para el borrado. Puede utilizarse ExecBlock

Private aRotina   := MenuDef()

dbSelectArea(cString)
dbSetOrder(1)

mBrowse( 6,1,22,75,cString,,,,,,)
Return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1V() Funcion de VISUALIZACION                     บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function Z03ABM1V(cAlias,nRecNo,nOpcX)
Local aButtons  := {}

AxVisual(cAlias,nRecNo,nOpcX,,,,,aButtons,,)

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1I() Funcion de INCLUSION                         บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function Z03ABM1I(cAlias,nRecNo,nOpcX)
Local aButtons		:= {}
Local cValidac		:= "U_Z03ABM1N()" //"U_Z03VALID()"
Local cTransac		:= NIL 
                                  
nOpcao := AxInclui(cAlias,nRecNo,nOpcX,,,,cValidac,,cTransac,aButtons)
                     
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1M() Funcion de MODIFICACION                      บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function Z03ABM1M(cAlias,nRecNo,nOpcX)
Local aButtons		:= {}
Local cValidac		:= "u_Z03ABM1A()"
Local cTransac		:= NIL //"u_Z03ABM1N" 
Local aCpos  		:= {} 
Local nOpcao 		:= 0 

nOpcao := AxAltera(cAlias,nRecNo,nOpcX,,aCpos,,,cValidac,cTransac,,aButtons,,,,,)

                                                             
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1B() Funcion de BAJA                              บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function Z03ABM1B(cAlias,nRecNo,nOpcX)
Local aButtons	:= {}
Local cTransac	:= "u_Z03ABM1X"
Local nOpcao := 0 

nOpcao := AxDeleta(cAlias,nRecNo,nOpcX,cTransac,,aButtons,,) 

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1A() VALIDACIONES en MODIFICACION 		        บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function Z03ABM1A()
Local lRet := .T.

Return (lRet)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1N	 TRANSACCIONES en ALTA 					    บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function Z03ABM1N()
Local lRet 		:= .T.

DbSelectArea("Z03")
DbSetOrder(1)
DbSeek(M->Z03_COD)		
IF Found()                                        
	Alert("No se puede cargar un codigo existente") 
	lRet:=.F.
EndIf 
	
Return (lRet)


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1J() VALIDACION de BAJA                           บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function Z03ABM1J()
Local lRet  := .T.

Return (lRet) 


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออหอออออออัออออออออออออปฑฑ
//ฑฑบPrograma   ณ Z03ABM1  บ Autor ณ Cardeza Fernando  บ Fecha ณ 04/07/2013 บฑฑ
//ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออสอออออออฯออออออออออออนฑฑ
//ฑฑบDescripcionณ U_Z03ABM1X() VALIDACION de BAJA                           บฑฑ
//ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function Z03ABM1X()
Local lRet  := .T.

Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ MenuDef  ณ Autor ณ Fernando Cardeza      ณ Data ณ04/07/2013ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Utilizacao de menu Funcional                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Array com opcoes da rotina.                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Parametros do array a Rotina:                              ณฑฑ
ฑฑณ          ณ1. Nome a aparecer no cabecalho                             ณฑฑ
ฑฑณ          ณ2. Nome da Rotina associada                                 ณฑฑ
ฑฑณ          ณ3. Reservado                                                ณฑฑ
ฑฑณ          ณ4. Tipo de Transao a ser efetuada:                        ณฑฑ
ฑฑณ          ณ	  1 - Pesquisa e Posiciona em um Banco de Dados           ณฑฑ
ฑฑณ          ณ    2 - Simplesmente Mostra os Campos                       ณฑฑ
ฑฑณ          ณ    3 - Inclui registros no Bancos de Dados                 ณฑฑ
ฑฑณ          ณ    4 - Altera o registro corrente                          ณฑฑ
ฑฑณ          ณ    5 - Remove o registro corrente do Banco de Dados        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MenuDef()

Private aRotina   := {	{"Buscar"     ,"AxPesqui"  ,0,1} ,;
						{"Visualizar" ,"u_Z03ABM1V",0,2} ,;
						{"Incluir"    ,"u_Z03ABM1I",0,3} ,;
						{"Modificar"  ,"u_Z03ABM1M",0,4} ,;
						{"Borrar"     ,"u_Z03ABM1B",0,5} }
Return aRotina