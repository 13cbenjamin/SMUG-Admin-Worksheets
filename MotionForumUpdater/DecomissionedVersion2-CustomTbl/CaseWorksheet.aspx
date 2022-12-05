<%@ Page Language="VB" ValidateRequest="False" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="BinaryIntellect.DatabaseHelper" %>
<%@ Import Namespace="WorksheetDataEngine" %>
<%@ Import Namespace="PDFTech" %>
<%@ Import Namespace="GetDocFromImageStorage" %>
<%@ Import Namespace="Eval3" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>


<%
'	Copyright 2004-2011 Bankruptcy Software Specialists, LLC (BSS, LLC)  All rights reserved. 
'	This material contains proprietary information of BSS, LLC 
'	Use, reproduction, modification or distribution without express written permission of an authorized representative of BSS, LLC is strictly prohibited. 
%>
<!-- #INCLUDE FILE = "Programs.aspx" -->

<% If Request.QueryString("standalone") <> "1" Then %>
<!-- #INCLUDE FILE = "incMainHeading.aspx" -->
<%
    End If

    If Request.QueryString("tcfp1") = "" Then Session("MenuTab" & Request.QueryString("xWin")) = "14"

    If Session("CaseID") = "" And Request.QueryString("cid") = "" And Session("CaseID" & Request.QueryString("xWin")) = "" Then
        Session("Prompt") = "A serious error has occurred."
        Response.Redirect("prompt.aspx?nolink=close")
    End If

    If Trim(Session("UserCodeID")) = "" Then Response.Redirect("Goodbye.aspx")

    If Request.QueryString("print") = "" Then

        If Request.QueryString("xWin") = "" Then
            If Request.QueryString("tcfp1") = "" Then
                If Session("CaseID") = "" And Request.QueryString("cid") = "" And Session("CaseID" & Request.QueryString("xWin")) = "" Then
                    Session("Prompt") = "A serious error has occurred."
                    Response.Redirect("prompt.aspx?nolink=close")
                End If
            End If
        Else
            If Request.QueryString("tcfp1") = "" Then
                Session("Rows" & Request.QueryString("xWin")) = "0"
                Session("OnLoadControls" & Request.QueryString("xWin")) = ""
                Session("Resize" & Request.QueryString("xWin")) = ""
                Session("Resizes" & Request.QueryString("xWin")) = ""
                Session("Scroll" & Request.QueryString("xWin")) = ""
            End If
        End If
    End If
%>
<script runat="server">

    Dim SQLCmd As String
    Dim SQLUpdate As String
    Dim db As SqlHelper = New SqlHelper()

    Dim CaseWorksheetID As Integer = 0

    Dim Printing As Boolean = False

    Dim x As Integer = 0
    Dim i As Integer = 0
    Dim CaseID As Integer = 0
    Dim CaseNumber As String = ""

    Dim Flatten As Boolean = False
    Dim p As Integer = 0
    Dim RecordID As Integer = 0
    Dim WorksheetType As Integer = 0
    Dim WorksheetDefault As Integer = 0
    Dim WorksheetDescription As String = ""

    Dim SQLDate As String = ""
    Dim Snap As Boolean = False

    Dim UserCanAccess As Boolean = False
    Dim UserCanModify As Boolean = False
    Dim UserCanMakeSnapshots As Boolean = False
    Dim UserCanDeleteTheirSnapshots As Boolean = False
    Dim UserCanDeleteAnyonesSnapshots As Boolean = False

    Dim SortedSnapshots As SortedList = New SortedList
    Dim SortedWorksheets As SortedList = New SortedList

    Dim ItemNumber As String = ""

    Dim gsListboxData As String = ""
    Dim Script1 As String = ""
    Dim JQueryReadyFunction As String = ""
    Dim wsOnload As String = ""

    Dim NoSnapshotBackground As String = ""

    Dim EnableHyperlinkToSection As Boolean = False
    Dim SortedSectionLinks As SortedList = New SortedList
    Dim SortedSectionLinksColor As Hashtable = New Hashtable
    Dim SortedSectionLinksFontColor As Hashtable = New Hashtable
    Dim NumberOfSectionLinks As Int16 = 0
    Dim EnableEnhancedFormatting As Boolean = False
    Dim EnteredQS As String = ""

    Sub Page_Load()

        Session("CaseWorksheetSnapshot1" & Request.QueryString("xWin")) = ""
        Session("CaseWorksheetSnapshot2" & Request.QueryString("xWin")) = ""

        If Left(Request.QueryString("cid"), 1) = "-" Then
            EnteredQS = "&standalone=1&cid=-8888888"
        End If


        db = New SqlHelper()
        db.CommandTimeout = 3600

        If Request.QueryString("print") = "" Then Printing = False

        If Request.QueryString("snap") <> "" Or Request.QueryString("tcfp1") <> "" Then Printing = True

        If Request.QueryString("wstype") <> "" Then
            If InStr(Request.QueryString("wstype"), "|") > 0 Then
                WorksheetType = CInt(Mid(Request.QueryString("wstype"), InStr(Request.QueryString("wstype"), "|") + 1))
            Else
                WorksheetType = CInt(Request.QueryString("wstype"))
            End If

            If LCase(Session("TruCode")) = "ftw" Then
                Dim dbUpdate0 As SqlHelper = New SqlHelper(Session("UserUpdateConnectionString"))
                SQLCmd = "Update tblUserWorksheetAccess Set MakeThisTheDeafultForThisUser = 0 where MakeThisTheDeafultForThisUser <> 0 And tblUserWorksheetAccess.UserCodeID = " & Session("UserCodeID") & " And tblUserWorksheetAccess.CaseWorksheetsID <> '" & WorksheetType & "';"
                SQLCmd = SQLCmd & "Update tblUserWorksheetAccess set MakeThisTheDeafultForThisUser = 1 where MakeThisTheDeafultForThisUser <> 1 and tblUserWorksheetAccess.UserCodeID = " & Session("UserCodeID") & " and tblUserWorksheetAccess.CaseWorksheetsID = '" & WorksheetType & "';"
                Dim updClear As Integer = dbUpdate0.ExecuteNonQuery(SQLCmd)
            End If

        End If

        If WorksheetType = 0 And IsNumeric(Session("WorksheetType" & Request.QueryString("xWin"))) And Session("WorksheetType" & Request.QueryString("xWin")) <> 0 Then WorksheetType = Session("WorksheetType" & Request.QueryString("xWin"))

        If Request.QueryString("ItemNumber") <> "" Then
            ItemNumber = Request.QueryString("ItemNumber")
        Else
            ItemNumber = "1"
        End If

        SQLCmd = "SELECT tblUserWorksheetAccess.* FROM tblUserWorksheetAccess, tblCaseWorksheets where "
        SQLCmd = SQLCmd & "tblUserWorksheetAccess.CaseWorksheetsID = tblCaseWorksheets.CaseWorksheetsID "
        SQLCmd = SQLCmd & "and tblUserWorksheetAccess.UserCodeID = " & Session("UserCodeID") & " "
        SQLCmd = SQLCmd & "and tblUserWorksheetAccess.CaseWorksheetsID = " & WorksheetType & " "
        Dim rs459 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs459.Read()
            UserCanAccess = rs459("UserCanAccess")
            UserCanModify = rs459("UserCanModify")
            UserCanMakeSnapshots = rs459("UserCanMakeSnapshots")
            UserCanDeleteTheirSnapshots = rs459("UserCanDeleteTheirSnapshots")
            UserCanDeleteAnyonesSnapshots = rs459("UserCanDeleteAnyonesSnapshots")
        End While
        rs459.Close()
        rs459 = Nothing

        Session("WorksheetType" & Request.QueryString("xWin")) = WorksheetType

        If Not IsPostBack And Request.QueryString("s") <> "" Then
            CaseID = CInt(Request.QueryString("s"))
            Snapshot()
            Response.Redirect("CaseWorksheet.aspx?xwin=" & Request.QueryString("xWin") & "&wstype=" & WorksheetType & EnteredQS)
        End If

        SQLCmd = "SELECT top 1 CaseWorksheetsID FROM tblCaseWorksheets where DoNotDisplayFromWorksheetTab = 0 order by CaseWorksheetsID"
        Dim rs453 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs453.Read()
            WorksheetDefault = rs453("CaseWorksheetsID")
        End While
        rs453.Close()
        rs453 = Nothing

        If Request.QueryString("snap") <> "" Then
            Snap = True
            NoSnapshotBackground = "&noBI=1"
        End If

        If Request.QueryString("cid") = "" Then
            CaseID = Session("CaseID" & Request.QueryString("xWin"))
        Else
            CaseID = CInt(Request.QueryString("cid"))
        End If

        SQLCmd = "SELECT CaseNumber from tblCaseData where CaseID = " & CaseID
        Dim rs58 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs58.Read()
            CaseNumber = rs58("CaseNumber")
        End While
        rs58.Close()
        rs58 = Nothing

        SQLCmd = "SELECT EnableEnhancedFormatting, CaseWorksheetsID, WorksheetDescription, Script1, JQueryReadyFunction from tblCaseWorksheets "
        SQLCmd = SQLCmd & "where tblCaseWorksheets.CaseWorksheetsID = '" & WorksheetType & "' "
        Dim rs26 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs26.Read()
            EnableEnhancedFormatting = rs26("EnableEnhancedFormatting")
            CaseWorksheetID = rs26("CaseWorksheetsID")
            WorksheetDescription = rs26("WorksheetDescription")

            JQueryReadyFunction = rs26("JQueryReadyFunction")

            'JQueryReadyFunction = Replace(JQueryReadyFunction, vbCrLf, " " & vbCr & " ")

            'Response.Write(JQueryReadyFunction)
            'Response.End()

            If JQueryReadyFunction <> "" Then
                JQueryReadyFunction = ReplaceStuff.ReplaceVariables(JQueryReadyFunction, "", CaseID, CaseNumber, 0, 0)
            End If

            Script1 = rs26("Script1")
            If Script1 <> "" Then
                Script1 = ReplaceStuff.ReplaceVariables(Script1, "", CaseID, CaseNumber, 0, 0)
            End If

            If 1 = 2 Then
                JQueryReadyFunction = rs26("JQueryReadyFunction")
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:CaseID:|", CaseID)
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:CaseNumber:|", CaseNumber)
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:ShortDate:|", Format(Now, "M/dd/yyyy"))
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:LongDate:|", Format(Now, "MMMM dd, yyyy"))
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:Time:|", Format(Now, "h:mm tt"))
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:UserCodeID:|", Session("UserCodeID"))
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:UserID:|", Session("UserID"))
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:UserName:|", Session("UserName"))
                JQueryReadyFunction = Replace(JQueryReadyFunction, "|:UserInitials:|", Session("UserInitials"))
                'JQueryReadyFunction = Replace(JQueryReadyFunction, "/*", vbCr)
                'JQueryReadyFunction = Replace(JQueryReadyFunction, "*/", vbCr)

                Script1 = rs26("Script1")
                Script1 = Replace(Script1, "|:CaseID:|", CaseID)
                Script1 = Replace(Script1, "|:CaseNumber:|", CaseNumber)
                Script1 = Replace(Script1, "|:ShortDate:|", Format(Now, "M/dd/yyyy"))
                Script1 = Replace(Script1, "|:LongDate:|", Format(Now, "MMMM dd, yyyy"))
                Script1 = Replace(Script1, "|:Time:|", Format(Now, "h:mm tt"))
                Script1 = Replace(Script1, "|:UserCodeID:|", Session("UserCodeID"))
                Script1 = Replace(Script1, "|:UserID:|", Session("UserID"))
                Script1 = Replace(Script1, "|:UserName:|", Session("UserName"))
                Script1 = Replace(Script1, "|:UserInitials:|", Session("UserInitials"))
                'Script1 = Replace(Script1, "/*", vbCr)
                'Script1 = Replace(Script1, "*/", vbCr)



            End If

            If InStr(Script1, " wsOnLoad()") = 0 Then
                wsOnload = ""
            Else
                wsOnload = "wsOnLoad()"
            End If

        End While
        rs26.Close()
        rs26 = Nothing

        ' Get Templates
        Dim AllTemplates As String = ""
        SQLCmd = "SELECT CaseWorksheetTemplateID from tblCaseWorksheetSectionLink, tblCaseWorksheetSections, tblCaseWorksheetTemplate "
        SQLCmd = SQLCmd & "where tblCaseWorksheetTemplate.Disabled <> 1 "
        SQLCmd = SQLCmd & "and tblCaseWorksheetSectionLink.CaseWorkSheetSectionsID = tblCaseWorksheetSections.CaseWorkSheetSectionsID "
        SQLCmd = SQLCmd & "and tblCaseWorksheetSectionLink.CaseWorkSheetSectionsID = tblCaseWorksheetTemplate.CaseWorkSheetSectionsID "
        SQLCmd = SQLCmd & "and CaseWorksheetsID = " & WorksheetType & " "
        Dim rs62 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs62.Read()
            AllTemplates = AllTemplates & rs62("CaseWorksheetTemplateID") & ","
        End While
        rs62.Close()
        rs62 = Nothing
        If AllTemplates <> "" Then
            AllTemplates = "(" & Left(AllTemplates, Len(AllTemplates) - 1) & ")"
        Else
            AllTemplates = "('')"
        End If

        SQLCmd = "SELECT * from tblCaseWorksheetSectionLink, tblCaseWorksheetSections "
        SQLCmd = SQLCmd & "where Disabled <> 1 and tblCaseWorksheetSectionLink.CaseWorkSheetSectionsID = tblCaseWorksheetSections.CaseWorkSheetSectionsID "
        SQLCmd = SQLCmd & "and CaseWorksheetsID = " & WorksheetType & " "
        SQLCmd = SQLCmd & "order by SectionDisplayOrder, CaseWorksheetSectionLink "
        Dim rsSec As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rsSec.Read()
            If rsSec("EnableHyperlinkToSection") Then
                NumberOfSectionLinks = NumberOfSectionLinks + 1
                If Not EnableHyperlinkToSection Then SortedSectionLinks.Add("  Jump to Section" & "|" & CStr(0), "Jump to Section")
                EnableHyperlinkToSection = True
                Try
                    SortedSectionLinks.Add("CaseWorksheet.aspx#section" & CStr(rsSec("CaseWorkSheetSectionsID")), rsSec("SectionDescription"))
                    SortedSectionLinksColor.Add(CStr(rsSec("CaseWorkSheetSectionsID")), rsSec("BackgroundColor"))
                    SortedSectionLinksFontColor.Add(CStr(rsSec("CaseWorkSheetSectionsID")), rsSec("DescriptionFontColor"))
                Catch ex As Exception
                End Try
            End If
        End While
        rsSec.Close()
        rsSec = Nothing

        If EnableHyperlinkToSection Then
            ddlSectionLink.Attributes.Add("onChange", "gotosection();return false")
            ddlSectionLink.DataSource = SortedSectionLinks
            ddlSectionLink.DataValueField = "Key"
            ddlSectionLink.DataTextField = "Value"
            ddlSectionLink.DataBind()
        End If

        Dim i As Int16 = 0
        Dim key As ICollection = SortedSectionLinks.Keys
        For Each k As String In key
            If Len(k) > 20 Then
                ddlSectionLink.Items(i).Attributes.CssStyle.Add("background-color", SortedSectionLinksColor(Trim(Mid(k, 27))))
                ddlSectionLink.Items(i).Attributes.CssStyle.Add("color", SortedSectionLinksFontColor(Trim(Mid(k, 27))))
            End If
            i = i + 1
        Next k

        If Request.QueryString("clear") = "1" Then
            Dim dbUpdate0 As SqlHelper = New SqlHelper(Session("UserUpdateConnectionString"))
            SQLCmd = "Delete from tblCaseWorksheetData where CaseWorksheetID in ( "
            SQLCmd = SQLCmd & "Select CaseWorksheetID from tblCaseWorksheetData "
            SQLCmd = SQLCmd & "inner join tblCaseWorksheetTemplate on tblCaseWorksheetData.CaseWorksheetTemplateID = tblCaseWorksheetTemplate.CaseWorksheetTemplateID "
            SQLCmd = SQLCmd & "inner join tblCaseWorksheetSectionLink on tblCaseWorksheetSectionLink.CaseWorksheetSectionsID = tblCaseWorksheetTemplate.CaseWorksheetSectionsID "
            SQLCmd = SQLCmd & "where CaseID = " & CaseID & " and tblCaseWorksheetSectionLink.CaseWorksheetsID = '" & WorksheetType & "') "
            Dim updClear As Integer = dbUpdate0.ExecuteNonQuery(SQLCmd)
        End If

        gsListboxData = ""
        SQLCmd = "SELECT CaseWorksheetTemplateID, FieldID, SavedData, UserIDLastUpdated, DateLastUpdated from tblCaseWorksheetData where CaseID = " & CaseID & " and CaseWorksheetTemplateID in " & AllTemplates
        Dim rs8 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs8.Read()
            If Left(rs8("FieldID"), 9) = "gsListBox" Then gsListboxData = gsListboxData & """" & rs8("FieldID") & "|" & Replace(rs8("SavedData"), "`", "") & """~"
        End While
        rs8.Close()
        rs8 = Nothing

        If gsListboxData <> "" Then gsListboxData = Left(gsListboxData, Len(gsListboxData) - 1)

        Dim xx As Boolean = False
        SQLCmd = "SELECT Distinct tblCaseWorksheets.CaseWorksheetsID, tblCaseWorksheets.DisplayOrder, tblCaseWorksheets.WorksheetDescription FROM tblUserWorksheetAccess, tblCaseWorksheets where "
        SQLCmd = SQLCmd & "tblUserWorksheetAccess.CaseWorksheetsID = tblCaseWorksheets.CaseWorksheetsID "
        SQLCmd = SQLCmd & "and tblUserWorksheetAccess.UserCodeID = " & Session("UserCodeID") & " "
        SQLCmd = SQLCmd & "and tblUserWorksheetAccess.UserCanAccess = 1 "
        SQLCmd = SQLCmd & "and tblCaseWorksheets.DoNotDisplayFromWorksheetTab = 0 "
        SQLCmd = SQLCmd & "and tblCaseWorksheets.AdminWorksheet = 0 "
        SQLCmd = SQLCmd & "and tblUserWorksheetAccess.CaseWorksheetsID <> " & WorksheetType & " "
        SQLCmd = SQLCmd & "order by DisplayOrder, WorksheetDescription"
        Dim rs6 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs6.Read()
            If Not xx Then SortedWorksheets.Add("!|0", "Select a Different Worksheet")
            SortedWorksheets.Add(rs6("WorksheetDescription") & "|" & CStr(rs6("CaseWorksheetsID")), rs6("WorksheetDescription"))
            xx = True
        End While
        rs6.Close()
        rs6 = Nothing

        ddlWorksheet.Attributes.Add("onChange", "worksheetchange('" & Request.QueryString("xWin") & "');return false")
        ddlWorksheet.DataSource = SortedWorksheets
        ddlWorksheet.DataValueField = "Key"
        ddlWorksheet.DataTextField = "Value"
        ddlWorksheet.DataBind()
        If Snap Or Not xx Then ddlWorksheet.Visible = False

        xx = False
        SQLCmd = "SELECT * from tblCaseWorksheetSnapshot where CaseID = " & CaseID & " and CaseWorksheetsID = " & WorksheetType & " order by CaseWorksheetSnapshotID "
        Dim rs88 As SqlDataReader = db.ExecuteReader(SQLCmd)
        While rs88.Read()
            If Not xx Then SortedSnapshots.Add(0, "Select a Previous Snapshot")
            If rs88("SnapshotDescription") = "" Then
                SortedSnapshots.Add(rs88("CaseWorksheetSnapshotID"), Format(rs88("SnapshotDate"), "ddd") & " " & Format(rs88("SnapshotDate"), "d") & " " & Format(rs88("SnapshotDate"), "T") & " (" & rs88("UserID") & ")")
            Else
                SortedSnapshots.Add(rs88("CaseWorksheetSnapshotID"), rs88("SnapshotDescription") & "- " & Format(rs88("SnapshotDate"), "ddd") & " " & Format(rs88("SnapshotDate"), "d") & " " & Format(rs88("SnapshotDate"), "T") & " (" & rs88("UserID") & ")")
            End If
            xx = True
        End While
        rs88.Close()
        rs88 = Nothing

        ddlSnapshot.Attributes.Add("onChange", "snapchange(" & WorksheetType & "," & Session("WinSuffix") & ",'" & Request.QueryString("xWin") & "');return false")
        ddlSnapshot.DataSource = SortedSnapshots
        ddlSnapshot.DataValueField = "Key"
        ddlSnapshot.DataTextField = "Value"
        ddlSnapshot.DataBind()

        If Snap Or Not xx Then ddlSnapshot.Visible = False
        If Snap Then
            SQLCmd = "SELECT getdate() as SQLDate"
            Dim rs38 As SqlDataReader = db.ExecuteReader(SQLCmd)
            While rs38.Read()
                SQLDate = Format(rs38("SQLDate"), "ddd") & " " & Format(rs38("SQLDate"), "d") & " " & Format(rs38("SQLDate"), "T")
            End While
            rs38.Close()
            rs38 = Nothing
            If Not Printing Then
                labSnap.Text = "<b>Snapshot taken " & SQLDate & "</b>"
            Else
                labSnap.Text = "<b>Printed " & SQLDate & "</b>"
            End If
        Else
            If Not xx Then labSnap.Visible = False
        End If

        '********************

        Dim GetWorksheet As New GetWorksheet
        PlaceHolder.Controls.Add(GetWorksheet.ReturnWorksheet(WorksheetType, CaseID, Request.QueryString("xWin"), Request.QueryString("v"), ItemNumber, 0))

        '********************

    End Sub

    Sub Snapshot()

        Dim sw As New StringWriter()
        Dim vsc As String = ""
        Dim SentToUsers As String = Request.QueryString("users")

        Dim dbUpdate As SqlHelper = New SqlHelper(Session("UserUpdateConnectionString"))
        dbUpdate.CommandTimeout = 3600

        Server.Execute("CaseWorksheet.aspx?xWin=" & Request.QueryString("xWin") & "&wstype=" & WorksheetType & "&snap=1&v=true&cid=" & CaseID, sw)

        SQLCmd = "Insert into tblCaseWorksheetSnapshot (CaseID, UserID, CaseWorksheetsID, SnapshotDescription, SentToUsers, Snapshot) values (" & CaseID & ", '" & Replace(Session("UserID"), "'", "''") & "', "
        SQLCmd = SQLCmd & WorksheetType & ", '" & Replace(Request.QueryString("desc"), "'", "''") & "', '" & SentToUsers & "', '" & Replace(RemoveViewState(sw.ToString), "'", "''") & "'); Select scope_identity()"
        Dim upd As Integer = dbUpdate.ExecuteScalar(SQLCmd)

        If SentToUsers <> "" Then
            Dim InboxHyperlink As String = "PleaseWaitStatic.aspx?prog=CaseWorksheetSnapshot.aspx?qs=progskip=~|xWin=" & Request.QueryString("xWin") & "|wstype=" & WorksheetType & "|a=" & upd
            SQLCmd = "Update tblInbox Set InboxHyperlink = '" & InboxHyperlink & "' where InboxID in (" & SentToUsers & ")"
            Dim updinbox As Integer = dbUpdate.ExecuteNonQuery(SQLCmd)

        End If

    End Sub

    Function CheckForTableData(TextString As String)

        ' Check for Data Fields
        Dim GetData As New GetData()
        Dim dp As Integer = InStr(TextString, "{")
        Dim dp1 As Integer = InStr(TextString, "}")

        If dp > 0 And dp1 > 0 Then
            Try
                TextString = GetData.ParseFieldData(TextString, CaseID, CaseNumber)
            Catch
                Session("Prompt") = "There was a problem parsing the Worksheet. Please verify."
                Response.Redirect("Prompt.aspx")
            End Try

        End If

        Return TextString

    End Function


    Function RemoveViewState(ByVal vsc As String) As String
        Dim vs As String = "<input type=""hidden"" name=""__VIEWSTATE"" id=""__VIEWSTATE"""
        p = InStr(vsc, vs)

        Do While p > 0
            vsc = Left(vsc, p - 1) & Mid(vsc, p + InStr(Mid(vsc, p), "/>") + 1)
            p = InStr(vsc, vs)
        Loop

        Return vsc

    End Function


</script>

<html>

<%  If Not Printing And Request.QueryString("snap") = "" Then%>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script type="text/javascript" src="Keys.js"></script>
    <script>
      <% If EnableHyperlinkToSection Then%>
        WCszYoff = 90
      <%        Else %>
        WCszYoff = 50
      <%End If %>
    </script>

<% End If%>

    <% If EnableEnhancedFormatting Then %>

        <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="bootstrap/css/bss.css" rel="stylesheet">

        <style media="screen" type="text/css">
        </style>
    
    <% End If %>

    <script>
        $(document).ready(function () {
            try {
                $("#CasePayout").load("modCasePayout.aspx?cid=<%= CaseID%>");
            }
            catch (e) { };

            <% If Trim(JQueryReadyFunction) <> "" Then

            Response.Write(vbCr)
            Response.Write(JQueryReadyFunction)
            Response.Write(vbCr)

        End If %>

        });

    </script>

    <% If Script1 <> "" Then%>
    <script type="text/javascript">
        <% = Script1 %>
    </script>
    <% End If%>

    
<%  If Request.QueryString("standalone") = "1" And Request.QueryString("cid") <> "" Then%>

        <script type="text/javascript" src="KeysWS.js"></script>
    
<% End If%>

<%  If Not Printing And Request.QueryString("snap") = "" Then%>

    <% If Request.QueryString("cid") = "" Then%>

        <script type="text/javascript" src="KeysWS.js"></script>
    
    <% End If%>

<% End If%>

    <base href="<%= Application("ApplicationHTTPAddress") %>" target="_self" />
    <link rel="stylesheet" href="StyleSheet.aspx?u=<%= Session("UserCodeID") %><%= NoSnapshotBackground %>" type="text/css" />
    <% If Not Printing Then%>
    <title>Case Worksheet</title>
</head>
<%
        Dim Resize As String = ""
        Dim Resizes As String = ""
        Dim Hides As String = ""
        If Request.QueryString("tcfp1") = "" Then
            Resize = ""
            Resizes = "resizeDivs();"
            Hides = "hideDivs();"
        End If

%>
<body style="overflow: hidden" onorientationchange="WCpleaseWaitResize();WCdisableScreenOverflow();setTimeout(&quot;WCresizeDivs();WCenableScreenOverflow()&quot;,0);"
    onresize="if (WCszBV != 'iPad'){if (WCresizeTimeout){clearTimeout(WCresizeTimeout)};WCresizeTimeout=0;WCresizeTimeout=setTimeout(&quot;WCresizeDivs();WCpleaseWaitResize();&quot;,WCszBW)}"
    onbeforeunload="WCdisableScreenOverflow()" onload="WCresizeDivs();<%= Session("HistoryGo") %><%= wsOnload %>;select_gsListBox(<%= gsListBoxData %>);">
    <!-- #INCLUDE FILE = "incPleaseWait.aspx" -->

    <% Else %>

<body onload="<%= Session("HistoryGo") %><%= wsOnload %>;select_gsListBox(<%= gsListBoxData %>);">

        
    <%

        End If

    %>
    <form id="Form1" name="PlanWorksheet" onsubmit="if (WCszBV == 'iPad') {WCdisableScreenOverflow();};WCsetApplication('clicked_'+WCszUC+'_'+WCszWN+'!1');"
    runat="server">
    <% If Not Printing Then%>
    <br />
    <% End If%>
    <%  
    If Not Printing And (Request.QueryString("standalone") = "" Or Left(Request.QueryString("cid"), 1) = "-") Then
            %>
    <table border="0" width="100%" id="table23" cellpadding="0">
        <tr>
            <td nowrap="nowrap" class="sectionHead" width="5%">
                <%= WorksheetDescription %> </td>
            <% If Not Printing And Request.QueryString("standalone") = ""  %>
            <td nowrap="nowrap" width="45%">&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="ddlWorksheet" runat="server" />
            </td>
            <% End iF %>
            <td nowrap="nowrap" width="25%">&nbsp;<asp:Label ID="labSnap" Text="Snapshots:&nbsp;"
                runat="server" /><asp:DropDownList ID="ddlSnapshot" runat="server" /></td>
            <td width="25%" align="right">
                <% If Request.QueryString("snap") = "" Then
        If Request.QueryString("xWin") = "" Then%>
                <a onclick="WCgoToApp('CaseWorksheet.aspx?xwin=<%= Request.QueryString("xWin") %>&wstype=<%=WorksheetType %><%= EnteredQS %>')"
                    title="Refresh" style="text-decoration: none">
                    <img border="0" width="20" height="20" style="cursor: pointer" alt="Refresh" title="Refresh"
                        src="images/reload.png" /></a>
                <% If CBool(UserCanModify) Then%>
                <a onclick="if(!(confirm('Are you sure you want to remove all the data from this worksheet?  This action cannot be undone.'))) return false; WCgoToApp('CaseWorksheet.aspx?clear=1&xwin=<%= Request.QueryString("xWin") %>&wstype=<%=WorksheetType %><%= EnteredQS %>')"
                    title="Clear All Fields" style="text-decoration: none">
                    <img border="0" width="20" height="20" style="cursor: pointer" alt="Clear All Fields"
                        title="Clear All Fields" src="images/bulletinboard/DeleteSheet.gif" /></a>
                <% If Request.QueryString("v") = "" Then%>
                <a onclick="WCgoToApp('CaseWorksheet.aspx?xwin=<%= Request.QueryString("xWin") %>&wstype=<%=WorksheetType %>&v=true<%= EnteredQS %>')">
                    <img style="border: none; cursor: pointer" width="20" height="20" alt="Flatten" title="Flatten"
                        src="images/bulletinboard/MoveRowUp.gif" /></a>&nbsp;
                <% Else%>
                <a onclick="WCgoToApp('CaseWorksheet.aspx?xwin=<%= Request.QueryString("xWin") %>&wstype=<%=WorksheetType %><%= EnteredQS %>')">
                    <img style="border: none; cursor: pointer" width="20" height="20" alt="Expand" title="Expand"
                        src="images/bulletinboard/MoveRowDown.gif" /></a>&nbsp;
                <% End If%>
                <% End If%>
                <% If CBool(UserCanMakeSnapshots) Then
                        Dim SnapCID As Integer = 0
                        If Left(Request.QueryString("cid"), 1) = "-" Then
                            SnapCID = Request.QueryString("cid")
                        Else
                            SnapCID = CaseID
                        End If
                        %>

                <a onclick="snapselect(<%=WorksheetType %>, <%= SnapCID %>,'<%= Request.QueryString("xWin")%>')">
                    <img style="border: none; cursor: pointer" width="20" height="20" alt="Snapshot"
                        title="Snapshot" src="images/bulletinboard/CameraFlash.gif" /></a>&nbsp;
                <% End If%>
                <%  End If%>
                <img width="20" height="20" style="cursor: pointer" alt="Create PDF" title="Create PDF"
                    onclick="PrintPDFPage(0,&quot;CaseWorksheet&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;)"
                    src="images/pdficon.gif" />&nbsp;&nbsp;
                <% End If%>
            </td>
        </tr>
        <% If EnableHyperlinkToSection Then%>
        <tr>
          <td colspan=4><asp:DropDownList ID="ddlSectionLink" runat="server" /></td>
        </tr>
        <% End If%>
    </table>
    <% End If%>
    <br />
    <!-- #INCLUDE FILE = "incDivStart.aspx" -->
        <asp:PlaceHolder ID="PlaceHolder" runat="server" />
    </form>
    
    <% If Printing And Session("LastCaseID") <> CaseID Then%>
    <div style="page-break-after: always">
        <img alt="" border="0" src="images/pixel.gif" /></div>
    <% End If%>
    <% If Not Printing Then%>
    <!-- #INCLUDE FILE = "incDivEnd.aspx" -->
<% If EnableEnhancedFormatting Then %>
    <script src="bootstrap/js/jquery-3.1.1.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
<% End If %>
</body>
</html>
<% End If%>


