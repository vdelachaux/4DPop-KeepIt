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
// Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_action)

If (False:C215)
	C_TEXT:C284(Keepit_MACRO; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO REQUIRED PARAMETER
	
	// COMPILER_component
	
	If ($Lon_parameters>=1)
		
		$Txt_action:=$1
		
	End if 
	
	//keepit_update
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Txt_action="new")  // Add a new snippet from the code selection
		
		keepit(New object:C1471(\
			"do"; "new"))
		
		//______________________________________________________
	Else   // Display the snippets menu
		
		keepit(New object:C1471(\
			"do"; "menu"))
		
		//______________________________________________________
End case 