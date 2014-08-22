#Include "Protheus.Ch"
#Define ENTER Chr(13)+Chr(10)

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� ABM de Acopio       ("Z01")     		                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

User Function ACOPIO                                      

Local aCores := { 	{"Z01_XENVIO == '1'"   , "BR_VERDE"	   },; //Empresa 01
  					{"Z01_XENVIO == '2'"   , "BR_VERMELHO" },; //Backup
					{"Z01_FCHVEN <  DATE()", "BR_PRETO"    }}  //Acopio Vencido
					
Private cCadastro := "Acopio"
Private cString   := "Z01"                                          
Private bCampo    := {|nField| FieldName(nField) }

Private cDelFunc  := "u_Z01ABM1J()" // Validaci�n para el borrado. Puede utilizarse ExecBlock

Private aRotina   := MenuDef()

dbSelectArea(cString)
dbSetOrder(1)

mBrowse( 6,1,22,75,cString,,,,,,aCores)
Return


//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1V() Funcion de VISUALIZACION                     ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
User Function Z01ABM1V(cAlias,nRecNo,nOpcX)
Local aButtons  := {}

AxVisual(cAlias,nRecNo,nOpcX,,,,,aButtons,,)

Return

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1I() Funcion de INCLUSION                         ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
User Function Z01ABM1I(cAlias,nRecNo,nOpcX)
Local aButtons		:= {}
Local cValidac		:= "U_Z01ABM1N()" //"U_Z01VALID()"
Local cTransac		:= NIL 
                                  
nOpcao := AxInclui(cAlias,nRecNo,nOpcX,,,,cValidac,,cTransac,aButtons)
                     
Return

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1M() Funcion de MODIFICACION                      ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

User Function Z01ABM1M(cAlias,nRecNo,nOpcX)
Local aButtons		:= {}
Local cValidac		:= "u_Z01ABM1A()"
Local cTransac		:= NIL //"u_Z01ABM1N" 
Local aCpos  		:= {}//agregar campos que pueden ser editables 
Local nOpcao 		:= 0 
AADD(aCpos, "Z01_XSEG")
AADD(aCpos, "Z01_TPSEG1")
AADD(aCpos, "Z01_TPSEG2")
AADD(aCpos, "Z01_POLIZA")
AADD(aCpos, "Z01_POLIZ2")
AADD(aCpos, "Z01_CCLIET")
AADD(aCpos, "Z01_CCLIE2")
AADD(aCpos, "Z01_XPORC")
AADD(aCpos, "Z01_XPORC2")
AADD(aCpos, "Z01_XDIRO")
AADD(aCpos, "Z01_XOBS3")
AADD(aCpos, "Z01_DESC1")
AADD(aCpos, "Z01_DESC2")
AADD(aCpos, "Z01_DESC3")
AADD(aCpos, "Z01_DESC4")
AADD(aCpos, "Z01_XCDTAB")
AADD(aCpos, "Z01_XINCR")
AADD(aCpos, "Z01_XPAUT")
AADD(aCpos, "Z01_FCHVEN")

nOpcao := AxAltera(cAlias,nRecNo,nOpcX,,aCpos,,,cValidac,cTransac,,aButtons,,,,,)

                                                             
Return

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1B() Funcion de BAJA                              ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

User Function Z01ABM1B(cAlias,nRecNo,nOpcX)
Local aButtons	:= {}
Local cTransac	:= "u_Z01ABM1X"
Local nOpcao := 0 

nOpcao := AxDeleta(cAlias,nRecNo,nOpcX,cTransac,,aButtons,,) 

Return

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1A() VALIDACIONES en MODIFICACION 		        ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

User Function Z01ABM1A()
Local lRet := .T.

Return (lRet)

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1N	 TRANSACCIONES en ALTA 					    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
User Function Z01ABM1N()
Local lRet 		:= .T.

M->Z01_STATUS:="1"

DbSelectArea("Z01")
DbSetOrder(1)
DbSeek(XFilial("Z01") + M->Z01_ACOPIO)		
IF Found()                                        
	Alert("No se puede cargar un Acopio existente") 
	lRet:=.F.
	Return (lRet)
EndIf

aAcopio:=Pendient()

If  Len(aAcopio)>0
	Alert("Este cliente ya posee un acopio pendiente") 
	lRet:=.T.
	Return (lRet)
EndIf
	
Return (lRet)


//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1J() VALIDACION de BAJA                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

User Function Z01ABM1J()
Local lRet  := .T.

Return (lRet) 


//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � Z01ABM1  � Autor � Cardeza Fernando  � Fecha � 04/07/2013 ���
//�������������������������������������������������������������������������͹��
//���Descripcion� U_Z01ABM1X() VALIDACION de BAJA                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

User Function Z01ABM1X()
Local lRet  := .T.

Return (lRet)                      

//+------------------------------------------- 
//|Funci�n: BLegenda - Rutina de Leyenda 
//+------------------------------------------- 
User Function BLegenda() 
Local aLegenda := {}
AADD(aLegenda,{"BR_VERDE"   ,"1-Acopio Normal"}) 
AADD(aLegenda,{"BR_VERMELHO","2-Acopio de BU"})     
AADD(aLegenda,{"BR_PRETO"	,"3-Acopio Vencido"})     
BrwLegenda(cCadastro, "Leyenda", aLegenda) 
Return Nil     

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MenuDef  � Autor � Fernando Cardeza      � Data �04/07/2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Array com opcoes da rotina.                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Parametros do array a Rotina:                              ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �	  1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()

Private aRotina   := {	{"Buscar"     ,"AxPesqui"  ,0,1} ,;
						{"Visualizar" ,"u_Z01ABM1V",0,2} ,;
						{"Incluir"    ,"u_Z01ABM1I",0,3} ,;
						{"Modificar"  ,"u_Z01ABM1M",0,4} ,;
						{"Borrar"     ,"u_Z01ABM1B",0,5} ,;
						{"Leyenda"    ,"u_BLegenda",0,6} }	
Return aRotina                                                                


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALMONACO �Autor  �Microsiga           �Fecha �  06/26/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ejecuta store procedure de los acopios pendientes         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function Pendient()
Local cQuery	:=""    
Local aAcopio   := {}
Local cCliente 	:=M->Z01_CLIENT

cQuery := "exec [QRY_VAL_ACOPIO_01]'"+ cCliente +"'"
cQuery := PLSAvaSQL(cQuery)
  If Select("TODO01") <> 0
	DBSelectArea("TODO01")
	TODO01->(DBCloseArea())
  EndIf
// Executa a Query
PLSQuery(cQuery,"TODO01")
// Vai para o inicio da area de trabalho
TODO01->(DBGoTop())
    While TODO01->(!Eof())
   		AADD( aAcopio, {TODO01->ACOPIO,TODO01->VALOR} )
    	DbSkip()
	Enddo

Return(aAcopio)           