// ----------------------------------------------------
// Object method : keepIt.tags - (4DPop KeepIt)
// Created 21/09/12 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_TEXT:C284($Mnu_main; $Txt_choice)
C_OBJECT:C1216($Obj_form)

// ----------------------------------------------------
// Initialisations
$Obj_form:=Form:C1466.definition
$Obj_form.event:=Form event code:C388
$Obj_form.current:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Enter:K2:33)
		
		If (OBJECT Get enabled:C1079(*; $Obj_form.current))
			
			OBJECT SET FONT STYLE:C166(*; $Obj_form.current; Bold:K14:2)
			
		End if 
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Leave:K2:34)
		
		OBJECT SET FONT STYLE:C166(*; $Obj_form.current; Plain:K14:1)
		
		//______________________________________________________
	: ($Obj_form.event=On Clicked:K2:4)\
		 | ($Obj_form.event=On Alternative Click:K2:36)
		
		$Mnu_main:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_main; ":xliff:tokenize")
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "tokenize")
		
		APPEND MENU ITEM:C411($Mnu_main; ":xliff:indent")
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "indent")
		
		$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main)
		RELEASE MENU:C978($Mnu_main)
		
		If (Length:C16($Txt_choice)>0)
			
			Form:C1466.current.code:=_o_keepit(New object:C1471("do"; $Txt_choice; "code"; Form:C1466.current.code)).code
			Form:C1466.save()
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unnecessarily activated form event")
		
		//______________________________________________________
End case 