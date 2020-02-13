B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Public BANano As BANano
	Public result As String
End Sub

public Sub GetResults(Url As String) 'ignore
	' We make a new promise
	Dim promise As BANanoPromise
	' Some vars to hold our results
	Dim json As String
	Dim error As String
 
	' Call the http request
	promise.CallSub(Me, "DoHTTPForUrl", Array(Url))
 
	promise.Then(json)
		' We got it!
	    result=json
	    Main.setImages(json)
	promise.Else(error) 'ignore
		Log(error)	
	    BANano.Alert(error)
	promise.end
End Sub


public Sub DoHTTPForUrl(Url As String) As String 'ignore
	' Defining a XMLHttpRequest object
	Dim Request As BANanoObject
	Request.Initialize2("XMLHttpRequest", Null)
	
	' Running a get
	Request.RunMethod("open", Array("GET", Url))
		
	' Defining the onload and onerror callbacks
	Dim event As Map
	' Careful here: we have to use the event name without the 'on' prefix when using AddEventListener
	Request.AddEventListener("load", BANano.CallBack(Me, "OnLoadHTTP", event), True)
	Request.AddEventListener("error", BANano.CallBack(Me, "OnErrorHTTP", event), True)
	
	' Let's do it!
	Request.RunMethod("send", Null)
End Sub

public Sub OnloadHTTP(event As Map)
	' Getting our XmlHttpRequest object again
	Dim Request As BANanoObject = event.Get("target")
	
	' Checking the status
	Dim status As Int = Request.GetField("status").Result
	If status < 200 Or status >= 300 Then
		' Maybe not allowed? Return an error with ReturnElse
		BANano.ReturnElse("Status code was not 200!")
	Else
		' All is fine, return a Then
		BANano.ReturnThen(Request.GetField("response").Result)
	End If
End Sub

public Sub OnErrorHTTP(event As Map)
	' Some other error, return a ReturnElse
	BANano.ReturnElse("Network error")
End Sub