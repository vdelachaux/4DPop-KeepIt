//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method :  menu_copy
// ID[2417691B56D64AAA944CC1FC4088BF97]
// Created 05/05/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
C_BLOB:C604($Blb_data)
C_TEXT:C284($Txt_object)

// ----------------------------------------------------
// Initialisations
$Txt_object:=OBJECT Get name:C1087(Object with focus:K67:3)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Txt_object=Form:C1466.definition.list)
		
		If (Form:C1466.current#Null:C1517)
			
			// Keep as text
			SET TEXT TO PASTEBOARD:C523(_o_keepit(New object:C1471("do"; "processing"; "code"; Form:C1466.current.code)).code)
			
			// And keep as private data
			TEXT TO BLOB:C554("<keepit name=\""+Form:C1466.current.name+"\"/>"; $Blb_data; UTF8 text without length:K22:17)
			APPEND DATA TO PASTEBOARD:C403("private.keepit.item"; $Blb_data)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Txt_object+"\"")
		
		//______________________________________________________
End case 