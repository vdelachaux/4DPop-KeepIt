//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : Keepit_get_file
// ID[652D3C9D36054337B96AA583784955A5]
// Created 27/10/10 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_i; $Lon_parameters)
C_TEXT:C284($Txt_buffer; $Txt_encoding; $Txt_path; $Txt_url; $Txt_volume)

If (False:C215)
	C_TEXT:C284(_o_keepit_get_file; $0)
	C_TEXT:C284(_o_keepit_get_file; $1)
	C_TEXT:C284(_o_keepit_get_file; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_url:=$1
	
	If ($Lon_parameters>=2)
		
		$Txt_encoding:=$2
		
	End if 
	
	$Txt_encoding:=$Txt_encoding+("UTF-8"*Num:C11(Length:C16($Txt_encoding)=0))
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Length:C16($Txt_url)=0)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: ($Txt_url="file://@")  // Abosolute path
		
		If (Is Windows:C1573)
			
			/////
			$Txt_url:=Replace string:C233($Txt_url; "file:/// "; ""; 1)
			
		Else 
			
			$Txt_url:=Replace string:C233($Txt_url; "file:// "; ""; 1)
			
		End if 
		
		$Txt_path:=Replace string:C233(Replace string:C233($Txt_url; "/Volumes/"; ""; 1); "/"; Folder separator:K24:12)
		
		If ($Txt_path[[1]]=Folder separator:K24:12)
			
			// Get the boot voulume's name {
			$Txt_volume:=System folder:C487
			
			For ($Lon_i; 1; Length:C16($Txt_volume); 1)
				
				If ($Txt_volume[[$Lon_i]]=":")
					
					$Txt_volume:=Substring:C12($Txt_volume; 1; $Lon_i-1)
					$Lon_i:=MAXLONG:K35:2-1
					
				End if 
			End for 
			//}
			
			$Txt_path:=$Txt_volume+$Txt_path
			
		End if 
		
		//______________________________________________________
	: ($Txt_url[[1]]="#")  // Relative in the host's resources folder
		
		$Txt_path:=Get 4D folder:C485(Current resources folder:K5:16; *)+Replace string:C233(Delete string:C232($Txt_url; 1; 1); "/"; Folder separator:K24:12)
		
		//______________________________________________________
	: ($Txt_url[[1]]="/")  // Relative in the component's resources folder
		
		//Remove the first "/"
		$Txt_url:=Delete string:C232($Txt_url; 1; 1)
		
		// Look for a localized file
		$Txt_path:=Get localized document path:C1105($Txt_url)
		
		If (Length:C16($Txt_path)=0)
			
			// No file found, look for at the Resources' root
			$Txt_path:=Get 4D folder:C485(Current resources folder:K5:16)+Replace string:C233($Txt_url; "/"; Folder separator:K24:12)
			
		End if 
		
		//______________________________________________________
	Else 
		
		$Txt_path:=$Txt_url
		
		//______________________________________________________
End case 

If (Test path name:C476($Txt_path)=Is a document:K24:1)
	
	$Txt_buffer:=Document to text:C1236($Txt_path; $Txt_encoding)
	
End if 

$0:=$Txt_buffer