'##############################################################################
'NOTES

'#Much of this code is adapted from www.rondebruin.nl
'#This macro will create a csv based on a sheet of your choice and email (using outlook)...
'#to an email of your choice and then give user a feedback message of your choice to...
'#indicate the email has been sent.


'PARAMETERS TO SET IN CODE BELOW

'#Sheet name to send as email:							sheetname
'#Feedback in message box when data is sent:			Data Sent - You may close this workbook
'#email to send to:										fakeemail@gmail.com
'#email subject:										enter your email subject here
'#email body text:										enter body text of email here

'##############################################################################'

'CODE

Sub Mail_ActiveSheet()
'Working in Excel 2000-2016
    Dim FileExtStr As String
    Dim FileFormatNum As Long
    Dim Sourcewb As Workbook
    Dim Destwb As Workbook
    Dim TempFilePath As String
    Dim TempFileName As String
    Dim OutApp As Object
    Dim OutMail As Object

    With Application
        .ScreenUpdating = False
        .EnableEvents = False
    End With

    Set Sourcewb = ActiveWorkbook

    'Copy the ActiveSheet to a new workbook
    Sheets("sheetname").Copy
    Set Destwb = ActiveWorkbook

    'Determine the Excel version and file extension/format
    With Destwb
        If Val(Application.Version) < 12 Then
            'You use Excel 97-2003
            FileExtStr = ".xls": FileFormatNum = -4143
        Else
            'You use Excel 2007-2016
            FileExtStr = ".csv": FileFormatNum = 6
            'Select Case Sourcewb.FileFormat
            'Case 51: FileExtStr = ".xls": FileFormatNum = 51
            'Case 52:
                'If .HasVBProject Then
                    'FileExtStr = ".xls": FileFormatNum = 52
                'Else
                    'FileExtStr = ".xls": FileFormatNum = 51
                'End If
            'Case 56: FileExtStr = ".xls": FileFormatNum = 56
            'Case Else: FileExtStr = ".xls": FileFormatNum = 50
            'End Select
        End If
    End With

    '    'Change all cells in the worksheet to values if you want
        With Destwb.Sheets(1).UsedRange
            .Cells.Copy
            .Cells.PasteSpecial xlPasteValues
            .Cells(1).Select
        End With
        Application.CutCopyMode = False

    'Save the new workbook/Mail it/Delete it
    TempFilePath = Environ$("temp") & "\"
    TempFileName = "etpaeration_" & Format(Now, "dd-mmm-yy_h-mm-ss")

    Set OutApp = CreateObject("Outlook.Application")
    Set OutMail = OutApp.CreateItem(0)

    With Destwb
        .SaveAs TempFilePath & TempFileName & FileExtStr, FileFormat:=FileFormatNum
        On Error Resume Next
        With OutMail
            .to = "fakeemail@gmail.com"
            .CC = ""
            .BCC = ""
            .Subject = "enter your email subject here"
            .Body = "enter body text of email here"
            .Attachments.Add Destwb.FullName
            'You can add other files also like this
            '.Attachments.Add ("C:\test.txt")
            .Send   'or use .Display
        End With
        On Error GoTo 0
        .Close savechanges:=False
    End With

    'Delete the file you have send
    Kill TempFilePath & TempFileName & FileExtStr

    Set OutMail = Nothing
    Set OutApp = Nothing

    With Application
        .ScreenUpdating = True
        .EnableEvents = True
    End With

    MsgBox "Data Sent - You may close this workbook", vbOKOnly, "Feedback"

End Sub
