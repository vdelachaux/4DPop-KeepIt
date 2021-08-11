// ----------------------------------------------------
// Object method : keepIt.b.action - (4DPop KeepIt.4DB)
// Created 15/10/10 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($Obj_form)

// ----------------------------------------------------
// Initialisations
$Obj_form:=Form:C1466.definition
$Obj_form.event:=Form event code:C388
$Obj_form.current:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_form.event=On Clicked:K2:4)
		
		//If (True)  //Maurice Inzirillo8/10/2015
		
		//$refWin_l:=Open form window("preferences";Sheet form window;*)
		//DIALOG("preferences")
		
		//Else
		
		//  //$Mnu_main:=Create menu
		//  //$Mnu_preference:=Create menu
		//  //APPEND MENU ITEM($Mnu_preference;Get localized string("automaticCloseOfDatabase"))
		//  //SET MENU ITEM PARAMETER($Mnu_preference;-1;"autoclose")
		//  //keepit_preferences ("database";->$Boo_autoclose)
		//  //If ($Boo_autoclose)
		//  //SET MENU ITEM MARK($Mnu_preference;-1;Char(18))
		//  // End if
		//  //APPEND MENU ITEM($Mnu_main;Get localized string("options");$Mnu_preference)
		//  //RELEASE MENU($Mnu_preference)
		//  //$Mnu_choice:=Dynamic pop up menu($Mnu_main)
		//  //RELEASE MENU($Mnu_main)
		//  // Case of
		//  //  //………………………………………………………………………………………
		//  //: (Length($Mnu_choice)=0)
		//  //  //………………………………………………………………………………………
		//  //: ($Mnu_choice="autoclose")
		//  //$Boo_autoclose:=Not($Boo_autoclose)
		//  //keepit_preferences ("database.set";->$Boo_autoclose)
		//  //  //………………………………………………………………………………………
		//  // Else
		//  //ASSERT(False;"Unknown menu action ("+$Mnu_choice+")")
		//  //  //………………………………………………………………………………………
		//  // End case
		
		//End if
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unnecessarily activated form event")
		
		//______________________________________________________
End case 