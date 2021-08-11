//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : Hashtag.macro
// Database: 4DPop KeepIt
// ID[E404B5EAC6EF495F96A603423C0EE12B]
// Created 14-1-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_error; $Lon_i; $Lon_parameters)
C_TEXT:C284($Mnu_choice; $Mnu_hashtag; $Txt_entrypoint; $Txt_hashTag; $Txt_method; $Txt_methodPath)

If (False:C215)
	C_TEXT:C284(Hashtag_macro; $1)
	C_TEXT:C284(Hashtag_macro; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_entrypoint:=$1
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Txt_entrypoint="save")
		
		//#macro
		//called when a method is saved.
		
		ARRAY TEXT:C222($tTxt_hashtags; 0x0000)
		
		GET MACRO PARAMETER:C997(Full method text:K5:17; $Txt_method)
		
		If (Position:C15("#"; $Txt_method)>0)
			
			If (hashtag_handler("open"))
				
				//$Txt_methodPath:="Hashtag_macro"
				//element.method.path (->$Txt_methodPath;True)
				$Txt_methodPath:=$2
				hashtag_handler("purge"; ->$Txt_methodPath)
				
				$Lon_error:=Rgx_ExtractText(hashtag_pattern; $Txt_method; "1"; ->$tTxt_hashtags)
				
				For ($Lon_i; 1; Size of array:C274($tTxt_hashtags); 1)
					
					$Txt_hashTag:=$tTxt_hashtags{$Lon_i}
					
					$Boo_OK:=hashtag_handler("store"; ->$Txt_methodPath; ->$Txt_hashTag)
					
				End for 
				
				hashtag_handler("close")
				
				POST OUTSIDE CALL:C329(Process number:C372("$hashtag.list"))
				
			End if 
			
		End if 
		
		//______________________________________________________
	: ($Txt_entrypoint="set")
		
		//#macro
		//display a choose list of the  hashtags existing for the current database
		
		ARRAY TEXT:C222($tTxt_hashtags; 0x0000)
		
		If (hashtag_handler("open"))
			
			hashtag_handler("get-hashtag"; ->$tTxt_hashtags)
			
			hashtag_handler("close")
			
		End if 
		
		$Mnu_hashtag:=Create menu:C408
		
		SORT ARRAY:C229($tTxt_hashtags)
		
		For ($Lon_i; 1; Size of array:C274($tTxt_hashtags); 1)
			
			APPEND MENU ITEM:C411($Mnu_hashtag; $tTxt_hashtags{$Lon_i})
			SET MENU ITEM PARAMETER:C1004($Mnu_hashtag; -1; "#"+$tTxt_hashtags{$Lon_i})
			
		End for 
		
		$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_hashtag)
		
		If (Length:C16($Mnu_choice)>0)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "//"+$Mnu_choice)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Txt_entrypoint+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// End