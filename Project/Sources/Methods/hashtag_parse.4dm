//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method: hashtag.parse
// Database: 4DPop KeepIt
// ID[3F8D3427CEB443E0A27B08CA7FD3A6E4]
// Created 14-1-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Parsing off all the methods for the first installation
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_error; $Lon_i; $Lon_j; $Lon_parameters)
C_TEXT:C284($Txt_entryPoint; $Txt_method; $Txt_pattern)

If (False:C215)
	C_TEXT:C284(hashtag_parse; $1)
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
		
		$Txt_method:=Current method name:C684
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=$Txt_method)
				
				//Error handling manager
				
				//……………………………………………………………………
				//: (Method called on event=$Txt_method)
				//
				//  //Event manager
				
				//……………………………………………………………………
			Else 
				
				//This method must be executed in a unique new process
				BRING TO FRONT:C326(New process:C317($Txt_method; 0; "$hashtag.parse"; "_run"; *))
				
				//……………………………………………………………………
		End case 
		
		//___________________________________________________________
	: ($Txt_entryPoint="_run")
		
		//First launch of this method executed in a new process
		hashtag_parse("_declarations")
		hashtag_parse("_init")
		
		ARRAY TEXT:C222($tTxt_methods; 0x0000)
		ARRAY TEXT:C222($tTxt_hashtags; 0x0000)
		
		If (hashtag_handler("open"))
			
			//purge all hashtags
			If (hashtag_handler("empty"))
				
				POST OUTSIDE CALL:C329(Process number:C372("$hashtag.list"))
				
				$Txt_pattern:=hashtag_pattern
				
				METHOD GET PATHS:C1163(Path all objects:K72:16; $tTxt_methods; <>hashtagStamp; *)
				
				For ($Lon_i; 1; Size of array:C274($tTxt_methods); 1)
					
					METHOD GET CODE:C1190($tTxt_methods{$Lon_i}; $Txt_method; *)
					
					$Lon_error:=Rgx_ExtractText($Txt_pattern; $Txt_method; "1"; ->$tTxt_hashtags; 0 ?+ 1)
					
					For ($Lon_j; 1; Size of array:C274($tTxt_hashtags); 1)
						
						hashtag_handler("store"; ->$tTxt_methods{$Lon_i}; ->$tTxt_hashtags{$Lon_j})
						
					End for 
					
					POST OUTSIDE CALL:C329(Process number:C372("$hashtag.list"))
					
				End for 
			End if 
			
			hashtag_handler("close")
			
		End if 
		
		hashtag_parse("_deinit")
		
		//___________________________________________________________
	: ($Txt_entryPoint="_declarations")
		
		C_REAL:C285(<>hashtagStamp)
		
		//___________________________________________________________
	: ($Txt_entryPoint="_init")
		
		//___________________________________________________________
	: ($Txt_entryPoint="_deinit")
		
		//___________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point ("+$Txt_entryPoint+")")
		
		//___________________________________________________________
End case 

// ----------------------------------------------------
// End