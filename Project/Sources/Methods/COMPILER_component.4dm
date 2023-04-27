//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : COMPILER_component
// ID[6521B910B15F4B6D98249556EB66D730]
// Created 29/04/10 by Vincent de Lachaux
// ----------------------------------------------------

If (False:C215)  // 4DPop entryPoints
	
	//____________________________________
	C_TEXT:C284(Keepit_MACRO; $1)
	
	//____________________________________
	//C_POINTER(KeepIt_onDrop; $1)
	
	//____________________________________
	//C_POINTER(KeepIt_tool; $1)
	
	//____________________________________
End if 

If (False:C215)
	
	//____________________________________
	C_OBJECT:C1216(keepit; $0)
	C_OBJECT:C1216(keepit; $1)
	
	//____________________________________
	C_TEXT:C284(keepit_ask; $0)
	C_TEXT:C284(keepit_ask; $1)
	C_TEXT:C284(keepit_ask; $2)
	
	//____________________________________
	C_TEXT:C284(keepit_folder; $0)
	
	//____________________________________
	C_TEXT:C284(keepit_get_file; $0)
	C_TEXT:C284(keepit_get_file; $1)
	C_TEXT:C284(keepit_get_file; $2)
	
	//____________________________________
	C_TEXT:C284(keepit_indent; $0)
	C_TEXT:C284(keepit_indent; $1)
	
	//____________________________________
	C_BOOLEAN:C305(keepit_list; $0)
	C_TEXT:C284(keepit_list; $1)
	
	//____________________________________
	C_TEXT:C284(keepit_method; $0)
	C_TEXT:C284(keepit_method; $1)
	
	//____________________________________
	C_OBJECT:C1216(keepit_session; $0)
	C_OBJECT:C1216(keepit_session; $1)
	
	//____________________________________
End if 