#INCLUDE "Protheus.ch"

#DEFINE ENTER chr(13)+chr(10)

/*
Funcao      : CargaXLS
Objetivos   : Fun��o chamada para realizar a convers�o de XLS para um array
Par�metros  : cArqE    - Nome do arquivo XLS a ser carregado
              cOrigemE - Local onde est� o arquivo XLS
              nLinTitE - Quantas linhas de cabe�alho que n�o ser�o integradas possui o arquivo
Autor       : Kana�m L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
User Function CargaXLS(cArqE,cOrigemE,nLinTitE,lTela)   
*-------------------------*
Local bOk        := {||lOk:=.T.,oDlg:End()}
Local bCancel    := {||lOk:=.F.,oDlg:End()}
Local lOk        := .F.
Local nLin       := 20
Local nCol1      := 15
Local nCol2      := nCol1+30
Local cMsg       := ""
Local oDlg
Local oArq
Local oOrigem
Local oMacro  

Default lTela := .T.

Private cArq       := If(ValType(cArqE)=="C",cArqE,"")
Private cArqMacro  := "XLS2DBF.XLA"
Private cTemp      := GetTempPath() //pega caminho do temp do client
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
Private cOrigem    := ""
Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private aArquivos  := {}
Private aRet       := {}
Private aDatexc	   := {}

aDatexc	:= U_SELFILEXLS() 
    
If Empty(aDatexc)
	MsgInfo("Proceso cancelado")
	Return
Endif           

cArq	:= SUBSTR (aDatexc[2],1,(Len(aDatexc[2])-4))
cOrigem	:= aDatexc[1]
aAdd(aArquivos, cArq)
IntegraArq()

Return aRet

/*
Funcao      : IntegraArq
Objetivos   : Faz a chamada das rotinas referentes a integra��o
Autor       : Kana�m L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function IntegraArq()
*-------------------------*
Local lConv      := .F.
//converte arquivos xls para csv copiando para a pasta temp
MsAguarde( {|| ConOut("Se inici� la conversi�n de archivos "+cArq+ " - "+Time()),;
               lConv := convArqs(aArquivos) }, "Conversi�n de archivos", "Conversi�n de archivos" )
If lConv
   //carrega do xls no array
   ConOut("Termin� la conversi�n de archivos "+cArq+ " - "+Time())   
   ConOut("Empez� a cargar el archivo "+cArq+ " - "+Time())
   Processa( {|| aRet:= CargaArray(AllTrim(cArq)) } ,;
                  "Espere, cargando hoja de c�lculo... Puede demorar") 
   ConOut("Terminado de cargar el archivo "+cArq+ " - "+Time())

EndIf

Return

/*
Funcao      : convArqs
Objetivos   : converte os arquivos .xls para .csv
Autor       : Kana�m L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function convArqs(aArqs)
*-------------------------*
Local oExcelApp
Local cNomeXLS  := ""
Local cFile     := ""
Local cExtensao := ""
Local i         := 1
Local j         := 1
Local aExtensao := {}

cOrigem := AllTrim(cOrigem)

//Verifica se o caminho termina com "\"
If !Right(cOrigem,1) $ "\"
   cOrigem := AllTrim(cOrigem)+"\"
EndIf


//loop em todos arquivos que ser�o convertidos
For i := 1 To Len(aArqs)      

   If !"." $ AllTrim(aArqs[i])
      //passa por aqui para verifica se a extens�o do arquivo � .xls ou .xlsx
      aExtensao := Directory(cOrigem+AllTrim(aArqs[i])+".*")
      For j := 1 To Len(aExtensao)
         If "XLS" $ Upper(aExtensao[j][1])
            cExtensao := SubStr(aExtensao[j][1],Rat(".",aExtensao[j][1]),Len(aExtensao[j][1])+1-Rat(".",aExtensao[j][1]))
            Exit
         EndIf
      Next j
   EndIf
   //recebe o nome do arquivo corrente
   cNomeXLS := AllTrim(aArqs[i])
   cFile    := cOrigem+cNomeXLS+cExtensao
   
   If !File(cFile)
      MsgInfo("El archivo "+cFile+" no se ha encontrado!" ,"Archivo")      
      Return .F.
   EndIf
     
   //verifica se existe o arquivo na pasta temporaria e apaga
   If File(cTemp+cNomeXLS+cExtensao)
      fErase(cTemp+cNomeXLS+cExtensao)
   EndIf                 
   
   //Copia o arquivo XLS para o Temporario para ser executado
   If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.) 
      MsgInfo("Problemas en la copia del archivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
      Return .F.
   EndIf                                       
   
   //apaga macro da pasta tempor�ria se existir
   If File(cTemp+cArqMacro)
      fErase(cTemp+cArqMacro)
   EndIf

   //Copia o arquivo XLA para o Temporario para ser executado
   If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.) 
      MsgInfo("Problemas en la copia del archivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
      Return .F.
   EndIf
   
   //Exclui o arquivo antigo (se existir)
   If File(cTemp+cNomeXLS+".csv")
      fErase(cTemp+cNomeXLS+".csv")
   EndIf
   
   //Inicializa o objeto para executar a macro
   oExcelApp := MsExcel():New()             
   //define qual o caminho da macro a ser executada
   oExcelApp:WorkBooks:Open(cTemp+cArqMacro)       
   //executa a macro passando como parametro da macro o caminho e o nome do excel corrente
   oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cNomeXLS)
   //fecha a macro sem salvar
   oExcelApp:WorkBooks:Close('savechanges:=False')
   //sai do arquivo e destr�i o objeto
   oExcelApp:Quit()
   oExcelApp:Destroy()

   //Exclui o Arquivo excel da temp
   fErase(cTemp+cNomeXLS+cExtensao)
   fErase(cTemp+cArqMacro) //Exclui a Macro no diretorio temporario
   //
Next i
//
Return .T. 

/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Par�metros  : cArq - nome do arquivo que ser� usado      
Autor       : Kana�m L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function CargaArray(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 1 
Local nTotLin := 0
Local aDados  := {}
Local cFile   := cTemp + cArq + ".csv"
Local nHandle := 0


//abre o arquivo csv gerado na temp
nHandle := Ft_Fuse(cFile)
If nHandle == -1
   Return aDados
EndIf
Ft_FGoTop()                                                         
nLinTot := FT_FLastRec()-1
ProcRegua(nLinTot)
//Pula as linhas de cabe�alho
While nLinTit > 0 .AND. !Ft_FEof()
   Ft_FSkip()
   nLinTit--
EndDo

//percorre todas linhas do arquivo csv
Do While !Ft_FEof()
   //exibe a linha a ser lida
   IncProc("Carga L�nea "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
   nLin++
   //le a linha
   cLinha := Ft_FReadLn()
   //verifica se a linha est� em branco, se estiver pula
   If Empty(AllTrim(StrTran(cLinha,';','')))
      Ft_FSkip()
      Loop
   EndIf
   //transforma as aspas duplas em aspas simples
   cLinha := StrTran(cLinha,'"',"'")
   cLinha := '{"'+cLinha+'"}' 
   //adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array 
   cLinha := StrTran(cLinha,';','","')
   aAdd(aDados, &cLinha)
   
   //passa para a pr�xima linha
   FT_FSkip()
   //
EndDo

//libera o arquivo CSV
FT_FUse()             

//Exclui o arquivo csv
If File(cFile)
   FErase(cFile)
EndIf
MsgInfo("Carga del archivo Excel Finalizado")
Return aDados

