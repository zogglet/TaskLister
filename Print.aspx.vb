Imports System.Data
Imports System.Data.SqlClient


Partial Class Print
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("TaskListConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim now As DateTime = DateTime.Now.Date.ToShortDateString

        If Not IsPostBack Then
            bindGridView()
            title_lit.Text = "<h3>" & Session("ListTitle") & " as of " & now & "</h3>"
            summary_lit.Text = summaryString()
        End If
    End Sub

    Private Function summaryString() As String
        Dim completeData As ArrayList = getCompleteData()
        Dim totalTasks As Integer = getTotalTasks()

        Return "<span class='OptionsDivider'>&nbsp;</span><br /><div class='SummaryStyle'>Total Tasks: <b>" & totalTasks & "</b>" & IIf(Session("PrintMode") = "Completion", "<br />Tasks Completed: <b>" & IIf(completeData(0) > 0, completeData(0), "<i>None</i>") & "</b><br />Percent Complete: <b>" & completeData(1) & "</b>", "") & "</div>"
    End Function



    Private Sub bindGridView()

        Try

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT *, StatusName, ProjectName FROM Tasks INNER JOIN Status ON Tasks.StatusID = Status.ID LEFT JOIN Projects on Tasks.ProjectID = Projects.ID ORDER BY StartDate DESC"
            oDTbl.Clear()

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)

            tasks_gv.DataSource = oDTbl
            tasks_gv.DataBind()

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Function formatNotesText(ByVal notes As Object) As String
        Return IIf(notes IsNot DBNull.Value, "<i><b>Notes:</b> " & notes, "")
    End Function

    Protected Sub tasksDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        Dim dList As DataList
        Dim dListStatusID As Integer

        If e.Row.RowType = DataControlRowType.DataRow Then
            styleGridViewRows(e.Row, e.Row.DataItem("StatusID"))

            dList = CType(e.Row.FindControl("status_dList"), DataList)

            If dList IsNot Nothing Then

                For j As Integer = 0 To dList.Items.Count - 1
                    dListStatusID = CType(dList.Items(j).FindControl("status_hField"), HiddenField).Value

                    Dim img As Image = CType(dList.Items(j).FindControl("taskComplete_img"), Image)
                    img.ImageUrl = IIf(Session("PrintMode") = "Checklist", "checkboxBlank.png", IIf(dListStatusID = e.Row.DataItem("StatusID"), "checkmark.png", Nothing))
                Next
            End If
            
        End If

    End Sub

    Private Sub styleGridViewRows(ByVal row As GridViewRow, ByVal status As Integer)

        For i As Integer = 3 To row.Cells.Count - 1
            row.Cells(i).Font.Bold = (status = 2 Or status = 6)
            row.Cells(i).Font.Italic = (status = 5)
        Next

    End Sub

    Private Function getCompleteData() As ArrayList
        Dim returnArr As ArrayList = New ArrayList()
        Dim percentComplete As String
        Dim complete As String

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT COUNT(*) FROM Tasks WHERE StatusID = 6"

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()

            complete = oCmd.ExecuteScalar().ToString

            oCmd.Connection.Close()

            percentComplete = Math.Round((complete / getTotalTasks()) * 100, 2) & "%"

            returnArr.Add(complete)
            returnArr.Add(percentComplete)

            Return returnArr

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
        End Try
    End Function

    Private Function getTotalTasks() As String
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT Count(*) FROM Tasks"

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()

            Return oCmd.ExecuteScalar().ToString

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
        End Try
    End Function

    Public Function configStatusImg(ByVal status As Object) As String
        Return IIf(Session("PrintMode") = "CheckList", "checkboxBlank.png", IIf(status = 6, "checkmark.png", "checkboxBlank.png"))
    End Function

    Public Function formatProjectText(ByVal name As Object) As String
        Return IIf(name IsNot DBNull.Value, name, "<i>(None associated)</i>")
    End Function

    Public Function formatDateTxt(ByVal d As DateTime) As String
        Return d.ToShortDateString()
    End Function

    Public Function formatCompleteDateTxt(ByVal status As Object, ByVal completeDate As Object) As String
        If status <> "Complete" Then
            Return "<i>(Not complete)</i>"
        ElseIf completeDate IsNot DBNull.Value Then
            Return CType(completeDate, DateTime).ToShortDateString
        Else
            Return "<i>(None specified)</i>"
        End If
    End Function

    Public Function formatStatusTxt(ByVal name As Object) As String
        Return IIf(name = "Complete", "<span class='GVCompleteHeaderStyle'>" & name & "</span>", name)
    End Function

    Protected Sub backClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Default.aspx")
    End Sub

End Class
