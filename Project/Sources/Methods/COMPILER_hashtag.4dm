//%attributes = {"invisible":true}
// PROCESS VARIABLES
C_LONGINT:C283(Lon_error)
C_POINTER:C301(Ptr_1)
C_POINTER:C301(Ptr_2)

// INTERPROCESS VARIABLES
C_REAL:C285(<>hashtagStamp)

If (False:C215)
	
	//____________________________________
	C_BOOLEAN:C305(hashtag_handler; $0)
	C_TEXT:C284(hashtag_handler; $1)
	C_POINTER:C301(hashtag_handler; ${2})
	
	//____________________________________
	C_TEXT:C284(hashtag_list; $1)
	
	//____________________________________
	C_TEXT:C284(Hashtag_macro; $1)
	C_TEXT:C284(Hashtag_macro; $2)
	
	//____________________________________
	C_TEXT:C284(hashtag_parse; $1)
	
	//____________________________________
	C_TEXT:C284(hashtag_pattern; $0)
	
	//____________________________________
	C_POINTER:C301(Hashtag_tool; $1)
	
	//____________________________________
End if 