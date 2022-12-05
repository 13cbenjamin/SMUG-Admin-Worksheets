<%@ Page Language="VB" ValidateRequest="false" %>

<%@ Import Namespace="BinaryIntellect.DatabaseHelper" %>
<%@ Import Namespace="System" %>
<%
    '   Modified clone of XMLWorksheetUpdate for custom table January 2021. 
    '	Copyright 2004-2011 Bankruptcy Software Specialists, LLC (BSS, LLC)  All rights reserved. 
    '	This material contains proprietary information of BSS, LLC 
    '	Use, reproduction, modification or distribution without express written permission of an authorized representative of BSS, LLC is strictly prohibited. 
%>


<script runat="server">

    Dim SQLCmd As String
    Dim db = New SqlHelper()
    Dim upd As Integer = 0

    Sub Page_Load()
        db.commandtimeout = 3600

        Dim dbUpdate As SqlHelper = New SqlHelper()
        If Session("UserUpdateConnectionString") = "" Then
            dbUpdate = New SqlHelper()
        Else
            dbUpdate = New SqlHelper(Session("UserUpdateConnectionString"))
        End If
        dbUpdate.CommandTimeout = 3600

        Try

            If Request.QueryString("del") = "1" Then

                SQLCmd = "Delete from tblCaseWorksheetSnapshot where CaseWorksheetSnapshotID = " & Request.QueryString("id")
                upd = dbUpdate.ExecuteNonQuery(SQLCmd)

            Else

                If Request.QueryString("i") = "" Or Request.QueryString("i") = "0" Then
                    SQLCmd = "Delete from tblTAC_CustomWorksheetData where CaseID = " & Request.QueryString("cid") & " "
                    SQLCmd = SQLCmd & "and CaseWorksheetTemplateID = " & Request.QueryString("tid") & " "
                    SQLCmd = SQLCmd & "and FieldID = '" & Replace(Request.QueryString("id"), "'", "''") & "' "
                    If Request.QueryString("InqCaseWorksheetID") <> "" Then
                        SQLCmd = SQLCmd & "and InqCaseWorksheetID = '" & Request.QueryString("InqCaseWorksheetID") & "' "
                    End If
                    upd = dbUpdate.ExecuteNonQuery(SQLCmd)

                    If (Trim(Request.QueryString("val")) <> "") Then
                        SQLCmd = "Insert into tblTAC_CustomWorksheetData (CaseID, CaseWorksheetTemplateID, FieldID, SavedData, UserIDLastUpdated"
                        If Request.QueryString("InqCaseWorksheetID") <> "" Then
                            SQLCmd = SQLCmd & ", InqCaseWorksheetID"
                        End If
                        SQLCmd = SQLCmd & ") values (" & Request.QueryString("cid") & ", "
                        SQLCmd = SQLCmd & Request.QueryString("tid") & ", "
                        SQLCmd = SQLCmd & "'" & Replace(Request.QueryString("id"), "'", "''") & "', "
                        SQLCmd = SQLCmd & "'" & Replace(Server.UrlDecode(Request.QueryString("val")), "'", "''") & "','" & Session("UserID") & "'"
                        If Request.QueryString("InqCaseWorksheetID") <> "" Then
                            SQLCmd = SQLCmd & ",'" & Request.QueryString("InqCaseWorksheetID") & "'"
                        End If
                        SQLCmd = SQLCmd & ")"
                        upd = dbUpdate.ExecuteNonQuery(SQLCmd)
                    End If
                Else
                    If (Trim(Request.QueryString("val")) <> "") Then
                        SQLCmd = "Update tblTAC_CustomWorksheetData set SavedData = SavedData + '" & Replace(Server.UrlDecode(Trim(Request.QueryString("val"))), "'", "''") & "', "
                        SQLCmd = SQLCmd & "DateLastUpdated = '" & Date.Now & "', UserIDLastUpdated = '" & Session("UserID") & "' "
                        SQLCmd = SQLCmd & "where CaseID = " & Request.QueryString("cid")
                        SQLCmd = SQLCmd & " and CaseWorksheetTemplateID = " & Request.QueryString("tid")
                        SQLCmd = SQLCmd & " and FieldID = '" & Replace(Request.QueryString("id"), "'", "''") & "' "
                        If Request.QueryString("InqCaseWorksheetID") <> "" Then
                            SQLCmd = SQLCmd & "and InqCaseWorksheetID = '" & Request.QueryString("InqCaseWorksheetID") & "' "
                        End If
                        upd = dbUpdate.ExecuteNonQuery(SQLCmd)
                    End If
                End If

            End If
        Catch ex As Exception

            ' WriteToLog(ex.Message, False, "")

        End Try

        Response.Write(" ")

    End Sub

</script>

