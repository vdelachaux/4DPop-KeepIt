// ----------------------------------------------------
// Form method : HASHTAG - (4DPop KeepIt)
// ID[6F04EE31BAF848378029C679E36C852C]
// Created 14-1-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_formEvent)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		If (hashtag_handler("open"))
			
			hashtag_handler("get"; OBJECT Get pointer:C1124(Object named:K67:5; "hashtag"); OBJECT Get pointer:C1124(Object named:K67:5; "path"))
			
			hashtag_handler("close")
			
		End if 
		
		SORT ARRAY:C229((OBJECT Get pointer:C1124(Object named:K67:5; "hashtag"))->; (OBJECT Get pointer:C1124(Object named:K67:5; "path"))->)
		LISTBOX COLLAPSE:C1101(*; "hastags")
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Lon_formEvent=On Outside Call:K2:11)
		
		SET TIMER:C645(0)
		
		OBJECT SET VISIBLE:C603(*; ""; Process state:C330(Process number:C372("$hashtag.parse"))=Executing:K13:4)
		
		If (hashtag_handler("open"))
			
			hashtag_handler("get"; OBJECT Get pointer:C1124(Object named:K67:5; "hashtag"); OBJECT Get pointer:C1124(Object named:K67:5; "path"))
			
			hashtag_handler("close")
			
		End if 
		
		SORT ARRAY:C229((OBJECT Get pointer:C1124(Object named:K67:5; "hashtag"))->; (OBJECT Get pointer:C1124(Object named:K67:5; "path"))->)
		
		//______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//ARRAY TEXT($tTxt_hashtags;0x0000)
		//ARRAY TEXT($tTxt_methods;0x0000)
		
		//If (hashtag.handler ("open"))
		//
		//C_LONGINT(<>hashtagStamp)
		//METHOD GET PATHS(Path All objects;$tTxt_methods;<>hashtagStamp;*)
		//
		//For ($Lon_i;1;Size of array($tTxt_methods);1)
		//
		//METHOD GET CODE($tTxt_methods{$Lon_i};$Txt_buffer;*)
		//
		//$Lon_error:=Rgx_ExtractText ($Txt_pattern;$Txt_method;"1";->$tTxt_hashtags;0 ?+ 1)
		//
		//For ($Lon_j;1;Size of array($tTxt_hashtags);1)
		//
		//hashtag.handler ("store";->$Txt_methodPath;->$tTxt_hashtags{$Lon_j})
		//
		//End for
		//End for
		//
		//REDRAW WINDOW
		//
		//hashtag.handler ("close")
		//
		//SET TIMER(60*60*1)  //5 minutes
		//
		//End if
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessary ("+String:C10($Lon_formEvent)+")")
		
		//______________________________________________________
End case 