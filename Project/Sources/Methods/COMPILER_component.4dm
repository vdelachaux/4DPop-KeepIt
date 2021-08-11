//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : COMPILER_component
// ID[6521B910B15F4B6D98249556EB66D730]
// Created 29/04/10 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations

// PROCESS VARIABLES


// INTERPROCESS VARIABLES
C_BOOLEAN:C305(<>inited)

If (Not:C34(<>inited))
	
	<>inited:=True:C214
	
	C_TEXT:C284($Txt_language)
	
	ARRAY TEXT:C222($tTxt_Components; 0)
	
	// Set the component localization {
	// Find the language of the 4D runtime…
	COMPONENT LIST:C1001($tTxt_Components)
	
	If (Find in array:C230($tTxt_Components; "4DPop")>0)
		
		//…with 4DPop, if any, …
		EXECUTE METHOD:C1007("4DPop_applicationLanguage"; $Txt_language)
		
	Else 
		
		//…the system language else.
		$Txt_language:=Get database localization:C1009(User system localization:K5:23)
		
	End if 
	
	// Set the component language
	SET DATABASE LOCALIZATION:C1104($Txt_language; *)
	
	If (OK=0)
		
		// Default is english
		SET DATABASE LOCALIZATION:C1104("en"; *)
		
		If (OK=0)
			
			// If fail, restore the default
			SET DATABASE LOCALIZATION:C1104(Get database localization:C1009(Default localization:K5:21); *)
			
		End if 
	End if 
	//}
	
End if 

// DATABASE METHODS
// ----------------------------------------------------
If (False:C215)
	
	//____________________________________
	C_LONGINT:C283(ON_HOST_DATABASE_EVENT; $1)
	
	//____________________________________
End if 

// METHODS
// ----------------------------------------------------
If (False:C215)  // 4DPop entryPoints
	
	//____________________________________
	C_TEXT:C284(Keepit_MACRO; $1)
	
	//____________________________________
	C_POINTER:C301(KeepIt_onDrop; $1)
	
	//____________________________________
	C_POINTER:C301(KeepIt_tool; $1)
	
	//____________________________________
End if 

If (False:C215)
	
	//____________________________________
	C_OBJECT:C1216(keepit; $0)
	C_OBJECT:C1216(keepit; $1)
	
	//____________________________________
	C_TEXT:C284(keepit_ask; $0)
	C_TEXT:C284(keepit_ask; $1)
	C_TEXT:C284(keepit_ask; $2)
	
	//____________________________________
	C_TEXT:C284(keepit_folder; $0)
	
	//____________________________________
	C_TEXT:C284(keepit_get_file; $0)
	C_TEXT:C284(keepit_get_file; $1)
	C_TEXT:C284(keepit_get_file; $2)
	
	//____________________________________
	C_TEXT:C284(keepit_indent; $0)
	C_TEXT:C284(keepit_indent; $1)
	
	//____________________________________
	C_BOOLEAN:C305(keepit_main; $0)
	C_TEXT:C284(keepit_main; $1)
	
	//____________________________________
	C_TEXT:C284(keepit_method; $0)
	C_TEXT:C284(keepit_method; $1)
	
	//____________________________________
	C_OBJECT:C1216(keepit_session; $0)
	C_OBJECT:C1216(keepit_session; $1)
	
	//____________________________________
End if 