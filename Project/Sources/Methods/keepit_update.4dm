//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit_update
// Database: 4DPop KeepIt
// ID[F14D9C62547946EDBA607B1DD320AE79]
// Created #21-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_i; $Lon_parameters)
C_TEXT:C284($Dir_sharedSnippets; $Dom_node; $Dom_preferences; $File_database; $Txt_name; $Txt_xml)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// <NO PARAMETERS REQUIRED>
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
	$Dir_sharedSnippets:=keepit_folder
	
Else 
	
	ABORT:C156
	
	
End if 

// ----------------------------------------------------
$Boo_OK:=(Test path name:C476($Dir_sharedSnippets)=Is a folder:K24:2)

If (Not:C34($Boo_OK))
	
	// Export previous used database to files
	ARRAY TEXT:C222($tTxt_Components; 0x0000)
	COMPONENT LIST:C1001($tTxt_Components)
	
	If (Find in array:C230($tTxt_Components; "4DPop")>0)
		
		EXECUTE METHOD:C1007("4DPop_preferenceLoad"; $Txt_xml; "KeepIt")
		
		$Dom_preferences:=DOM Parse XML variable:C720($Txt_xml)
		
		If (Bool:C1537(OK))
			
			$Dom_node:=DOM Find XML element:C864($Dom_preferences; "preference/KeepIt/database")
			
			If (Bool:C1537(OK))
				
				ON ERR CALL:C155("noError")
				DOM GET XML ATTRIBUTE BY NAME:C728($Dom_node; "location"; $File_database)
				ON ERR CALL:C155("")
				
				$Boo_OK:=Bool:C1537(OK)
				
				If ($Boo_OK)
					
					If ((Test path name:C476($File_database)=Is a document:K24:1))
						
						ARRAY TEXT:C222($tTxt_code; 0x0000)
						ARRAY TEXT:C222($tTxt_name; 0x0000)
						
						Begin SQL
							
							USE DATABASE DATAFILE :$File_database
							AUTO_CLOSE;
							
							SELECT ALL  name, code
							FROM KEEPIT
							INTO :$tTxt_name, :$tTxt_code;
							
							USE DATABASE SQL_INTERNAL;
							
						End SQL
						
						CREATE FOLDER:C475($Dir_sharedSnippets; *)
						
						For ($Lon_i; 1; Size of array:C274($tTxt_name); 1)
							
							$Txt_name:=Replace string:C233($tTxt_name{$Lon_i}; "/"; "_")
							
							TEXT TO DOCUMENT:C1237($Dir_sharedSnippets+$Txt_name+".txt"; $tTxt_code{$Lon_i})
							
						End for 
					End if 
				End if 
			End if 
			
			DOM CLOSE XML:C722($Dom_preferences)
			
		End if 
	End if 
End if 

If (Not:C34($Boo_OK))
	
	// Install default snippets
	COPY DOCUMENT:C541(Object to path:C1548(New object:C1471(\
		"name"; "INIT"; \
		"isFolder"; True:C214; \
		"parentFolder"; Get 4D folder:C485(Current resources folder:K5:16))); \
		Get 4D folder:C485; "KEEPIT")
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End