//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit_folder
// Database: 4DPop KeepIt
// ID[A13561BCC4444EA5ADD52569B3CB9DFC]
// Created #21-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Return the pathname to the shared snippets folder
// Resolve alias if any
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_snippetFolder; $File_alias; $Txt_buffer)

If (False:C215)
	C_TEXT:C284(keepit_folder; $0)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// <NO PARAMETERS REQUIRED>
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// The default directory is {current 4D Folder}/KEEPIT/
$Dir_snippetFolder:=Object to path:C1548(New object:C1471(\
"name"; "KEEPIT"; \
"isFolder"; True:C214; \
"parentFolder"; Get 4D folder:C485(Active 4D Folder:K5:10)))

If (Test path name:C476($Dir_snippetFolder)#Is a folder:K24:2)
	
	// Look for an alias
	$File_alias:=Object to path:C1548(New object:C1471(\
		"name"; "KEEPIT"; \
		"isFolder"; False:C215; \
		"parentFolder"; Get 4D folder:C485(Active 4D Folder:K5:10)))
	
	If (Test path name:C476($File_alias)=Is a document:K24:1)
		
		RESOLVE ALIAS:C695($File_alias; $Txt_buffer)
		
		If (Bool:C1537(OK))
			
			$Dir_snippetFolder:=$Txt_buffer
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Dir_snippetFolder

// ----------------------------------------------------
// End