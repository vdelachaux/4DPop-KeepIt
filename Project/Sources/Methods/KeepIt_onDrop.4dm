//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : KeepIt.onDrop
// ID[40592A93807A435CB2B2261A81DED6A9]
// Created 30/04/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// #4DPop entry point "On drop"
// ----------------------------------------------------
// Declarations
C_POINTER:C301($1)

If (False:C215)
	C_POINTER:C301(KeepIt_onDrop; $1)
End if 

// ----------------------------------------------------

COMPILER_component

keepit_main("onDrop")