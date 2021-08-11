//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method: hashtag.list
// Database: 4DPop KeepIt
// ID[2428E7E37A8A4D77B8E405BDF3B64A45]
// Created 14-1-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters; $Lon_w)
C_TEXT:C284($Txt_entryPoint)

If (False:C215)
	C_TEXT:C284(hashtag_list; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

// ----------------------------------------------------
Case of 
		
		//___________________________________________________________
	: (Length:C16($Txt_entryPoint)=0)
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=Current method name:C684)
				
				//Event manager
				
				//……………………………………………………………………
			Else 
				
				//This method must be executed in a unique new process
				BRING TO FRONT:C326(New process:C317("hashtag_list"; 0; "$hashtag.list"; "_run"; *))
				
				//……………………………………………………………………
		End case 
		
		//___________________________________________________________
	: ($Txt_entryPoint="_run")
		
		//First launch of this method executed in a new process
		hashtag_list("_declarations")
		hashtag_list("_init")
		
		//{
		$Lon_w:=Open form window:C675("HASHTAG"; Palette form window:K39:9; On the right:K39:3; At the top:K39:5)
		DIALOG:C40("HASHTAG")
		CLOSE WINDOW:C154
		//}
		
		hashtag_list("_deinit")
		
		//___________________________________________________________
	: ($Txt_entryPoint="_declarations")
		
		//___________________________________________________________
	: ($Txt_entryPoint="_init")
		
		//___________________________________________________________
	: ($Txt_entryPoint="_deinit")
		
		//___________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point ("+$Txt_entryPoint+")")
		
		//___________________________________________________________
End case 