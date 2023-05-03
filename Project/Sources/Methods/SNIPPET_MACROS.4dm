//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method: Keepit_MACRO
// ID[B0EAA2D3EC46428CA595378DE8C6D45E]
// Database: 4DPop KeepIt.4DB
// Created 14/10/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Display a contextual menu of keepIt items
// If an item is selected the code is pasted in the method editor
// ----------------------------------------------------
#DECLARE($action : Text)

If (False:C215)
	C_TEXT:C284(SNIPPET_MACROS; $1)
End if 

COMPILER_component

Case of 
		
		//______________________________________________________
	: ($action="new")
		
		// Add a new snippet from the code selection
		_o_keepit(New object:C1471(\
			"do"; "new"))
		
		//______________________________________________________
	Else 
		
		// Display the snippets menu
		snippet.doMenu()
		
		//______________________________________________________
End case 