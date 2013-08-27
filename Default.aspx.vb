Imports System.Data
Imports System.Data.SqlClient

Partial Class _Default
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("TaskListConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String = ""

    Dim dv As DataView
    Dim innerDv As DataView
    Private Const ASCENDING As String = " ASC"
    Private Const DESCENDING As String = " DESC"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Session("Status") = Nothing
            Session("Project") = Nothing
            Session("SearchTerm") = Nothing
            Session("StartDate") = Nothing
            Session("CompleteDate") = Nothing
            Session("InputCompleteDate") = Nothing

            Session("SortDir") = SortDirection.Ascending
            Session("FirstSort") = True

            bindGridView(True)

        End If
    End Sub

    Private Sub bindGridView(ByVal all As Boolean, Optional ByVal orderBy As String = "StartDate DESC")

        Try

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT *, Status.StatusName, Projects.ProjectName FROM Tasks INNER JOIN Status ON Tasks.StatusID = Status.ID LEFT JOIN Projects on Tasks.ProjectID = Projects.ID"

            oCmd.Parameters.Clear()
            oDTbl.Clear()

            If Not all Then
                addParams()
            End If

            strSQL &= " ORDER BY " & orderby

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)

            indicator_lit.Text = rigSubGVStuff(oDTbl)

            tasks_gv.DataSource = oDTbl
            tasks_gv.DataBind()

            Session("TaskList") = oDTbl

            print_pnl.Visible = (tasks_gv.Rows.Count > 0)

            tasks_updatePnl.Update()

        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Protected Sub gotoPrintClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("PrintMode") = print_rbList.SelectedValue
        Session("ListTitle") = IIf(listTitle_txt.Text.Trim.Length > 0, listTitle_txt.Text.Trim, "Task List")
        Response.Redirect("Print.aspx")
    End Sub

    Private Function rigSubGVStuff(ByVal dt As DataTable) As String
        If dt.Rows.Count = 0 Then
            Return "<span class='IndicatorStyle'>Your selected filtering options returned no items.</span>"
        Else
            Dim completeData As ArrayList = getCompleteData()
            Return "<div class='StatStyle'>Drilled-down items: <span class='TotalItemStyle'>" & dt.Rows.Count & "</span> <b>|</b> Total Tasks: <span class='TotalItemStyle'>" & getTotalTasks() & "</span> <b>|</b> Completed Tasks: <span class='TotalCompleteStyle'>" & completeData(0) & "</span> (<span class='TotalCompleteStyle'>" & completeData(1) & "</span>)</div>"
        End If

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

    Protected Sub tasksDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)

        If e.Row.RowType = DataControlRowType.DataRow Then
            styleGridViewRows(e.Row, e.Row.DataItem("StatusID"))
        End If

    End Sub


    Private Sub styleGridViewRows(ByVal row As GridViewRow, ByVal status As Integer)
        Dim rblist As RadioButtonList

        rblist = CType(row.FindControl("status_rbList"), RadioButtonList)

        For i As Integer = 1 To row.Cells.Count - 1
            Select Case status
                Case 1, 5
                    row.Cells(i).CssClass = "GVItemStyle"
                    rblist.SelectedItem.Attributes.Add("style", "background: #5ddaec")
                Case 2
                    row.Cells(i).CssClass = "GVInProgressItemStyle"
                    rblist.SelectedItem.Attributes.Add("style", "background: #f7ff6a")
                Case 3, 4
                    row.Cells(i).CssClass = "GVWaitingItemStyle"
                    rblist.SelectedItem.Attributes.Add("style", "background: #5ddaec")
                Case 6
                    row.Cells(i).CssClass = "GVCompleteItemStyle"
                    rblist.SelectedItem.Attributes.Add("style", "background: #a0ec5d")
            End Select

            row.Cells(i).Font.Italic = (status = 5)

        Next
    End Sub

    Protected Sub selectedStatusChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim id As Integer

        Try
            'Isolate Task ID
            For i As Integer = 0 To tasks_gv.Rows.Count - 1
                If CType(tasks_gv.Rows(i).FindControl("status_rbList"), RadioButtonList) Is sender Then
                    id = tasks_gv.DataKeys(i).Values("ID")
                    GoTo EndLoop
                End If
            Next

EndLoop:

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "UPDATE Tasks SET StatusID = @StatusID, CompleteDate = @CompleteDate WHERE ID = @ID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter()
            oParam.ParameterName = "StatusID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = CType(sender, RadioButtonList).SelectedValue
            oCmd.Parameters.Add(oParam)

            oParam = New SqlParameter()
            oParam.ParameterName = "CompleteDate"
            oParam.SqlDbType = SqlDbType.DateTime
            oParam.Value = IIf(CType(sender, RadioButtonList).SelectedValue = 6, DateTime.Now.ToShortDateString, DBNull.Value)
            oCmd.Parameters.Add(oParam)

            oParam = New SqlParameter()
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = id
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()

            oCmd.ExecuteScalar()
            oCmd.Connection.Close()

            bindGridView(False)

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
        End Try

    End Sub

    Private Sub addParams()
        'Parameters will only be included in the filtering if the session variables are not nothing
        If Session("StartDate") IsNot Nothing Then
            strSQL &= andOrWhere(strSQL)
            strSQL &= " StartDate BETWEEN Convert(varchar(10), @StartDate, 101) AND DateAdd(ss, -1, DateAdd(dd, 1, Convert(varchar(10), @StartDate, 101)))"

            oParam = New SqlParameter()
            oParam.ParameterName = "StartDate"
            oParam.SqlDbType = SqlDbType.DateTime
            oParam.Value = CDate(startDate_txt.Text)
            oCmd.Parameters.Add(oParam)
        End If

        If Session("Status") IsNot Nothing Then
            strSQL &= andOrWhere(strSQL)
            strSQL &= " StatusID = @StatusID"

            oParam = New SqlParameter()
            oParam.ParameterName = "StatusID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Session("Status")
            oCmd.Parameters.Add(oParam)
        End If

        If Session("Project") IsNot Nothing Then
            strSQL &= andOrWhere(strSQL)
            If Session("Project") Is DBNull.Value Then
                strSQL &= " ProjectID IS NULL"
                '(In this case, no actual parameters are needed)
            Else
                strSQL &= " ProjectID = @ProjectID"
                oParam = New SqlParameter()
                oParam.ParameterName = "ProjectID"
                oParam.SqlDbType = SqlDbType.Int
                oParam.Value = Session("Project")
                oCmd.Parameters.Add(oParam)
            End If

        End If

        If Session("CompleteDate") IsNot Nothing Then
            strSQL &= andOrWhere(strSQL)
            strSQL &= " CompleteDate BETWEEN Convert(varchar(10), @CompleteDate, 101) AND DateAdd(ss, -1, DateAdd(dd, 1, Convert(varchar(10), @CompleteDate, 101)))"

            oParam = New SqlParameter()
            oParam.ParameterName = "CompleteDate"
            oParam.SqlDbType = SqlDbType.DateTime
            oParam.Value = CDate(Session("CompleteDate"))
            oCmd.Parameters.Add(oParam)
        End If

        If Session("SearchTerm") IsNot Nothing Then
            strSQL &= andOrWhere(strSQL)

            Dim searchStr As String = Session("SearchTerm").ToString
            strSQL &= " Task LIKE '%" & searchStr.Replace(",", "%' OR Task LIKE '%") & "%' OR ProjectName LIKE '%" & searchStr.Replace(",", "%' OR ProjectName LIKE '%") & "%' OR StatusName LIKE '%" & searchStr.Replace(",", "%' OR StatusName LIKE '%") & "%' OR Notes LIKE '%" & searchStr.Replace(",", "%' OR Notes LIKE '%") & "%'"
        End If

    End Sub


    Public Property gvSortDirection() As SortDirection
        Get
            If ViewState("sortDirection") Is DBNull.Value Then
                ViewState("sortDirection") = SortDirection.Ascending
                Return CType(ViewState("sortDirection"), SortDirection)
            End If
        End Get
        Set(ByVal value As SortDirection)
            ViewState("sortDirection") = value
        End Set
    End Property

    Private Sub sortGV(ByVal se As String, ByVal dir As String)
        dv = New DataView(CType(Session("TaskList"), DataTable))
        dv.Sort = se & dir
        tasks_gv.DataSource = dv
        tasks_gv.DataBind()
    End Sub

    Protected Sub tasksSorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)

        Dim sortExp As String = e.SortExpression

        If (gvSortDirection() = SortDirection.Ascending) Then
            gvSortDirection() = SortDirection.Descending
            sortGV(sortExp, DESCENDING)
        Else
            gvSortDirection() = SortDirection.Ascending
            sortGV(sortExp, ASCENDING)
        End If

    End Sub

    Protected Function andOrWhere(ByVal str As String) As String
        Return IIf(InStr(str, "WHERE"), " AND", " WHERE")
    End Function

    Public Function formatDateTxt(ByVal d As DateTime) As String
        Return d.ToShortDateString()
    End Function

    Protected Sub filterClick(ByVal sender As Object, ByVal e As System.EventArgs)
        'Verifying that any filtering options left blank won't be included in the drilldown, since addParams checks for values of Nothing
        Session("Status") = IIf(status_ddl.SelectedValue = -1, Nothing, status_ddl.SelectedValue)
        Session("Project") = IIf(project_ddl.SelectedValue = -2, Nothing, IIf(project_ddl.SelectedValue = -1, DBNull.Value, project_ddl.SelectedValue))
        Session("SearchTerm") = IIf(search_txt.Text.Trim.Length > 0, search_txt.Text.Trim, Nothing)
        Session("StartDate") = IIf(startDate_txt.Text.Trim.Length > 0, startDate_txt.Text.Trim, Nothing)
        Session("CompleteDate") = IIf(endDate_txt.Text.Trim.Length > 0, endDate_txt.Text.Trim, Nothing)

        bindGridView(False)

    End Sub

    Protected Sub resetClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("Status") = Nothing
        Session("Project") = Nothing
        Session("SearchTerm") = Nothing
        Session("StartDate") = Nothing
        Session("CompleteDate") = Nothing

        status_ddl.SelectedValue = -1
        project_ddl.SelectedValue = -2
        startDate_txt.Text = ""
        endDate_txt.Text = ""
        search_txt.Text = ""

        bindGridView(True)

    End Sub

    Private Sub bindProjectsDDL(Optional ByVal value As Integer = -2)
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ID, ProjectName FROM Projects UNION SELECT -2 AS ID, '--Select Project--' AS ProjectName UNION SELECT -1 AS ID, 'ADD NEW' AS ProjectName ORDER BY ID"

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)

            manageProjects_ddl.DataSource = oDTbl
            manageProjects_ddl.DataBind()

            manageProjects_ddl.SelectedValue = value
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub configFormView(ByVal mode As String)
        projectsFV_pnl.Visible = (mode = "Project")
        taskFV_pnl.Visible = (mode = "Task")
    End Sub

    Protected Sub addTaskClick(ByVal sender As Object, ByVal e As System.EventArgs)
        task_fv.ChangeMode(FormViewMode.Insert)
        configFormView("Task")
        fv_updatePnl.Update()
        fv_mpExt.Show()
    End Sub

    Protected Sub manageProjectsClick(ByVal sender As Object, ByVal e As System.EventArgs)

        bindProjectsDDL()

        prompt_lit.Text = "<span class='PromptStyle'>Select a project to edit, or add a new one.</span>"
        configElements(True)

        configFormView("Project")
        fv_updatePnl.Update()
        fv_mpExt.Show()

    End Sub

    Protected Sub genReportClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Report.aspx")
    End Sub

    Protected Sub outerCancelClick(ByVal sender As Object, ByVal e As System.EventArgs)
        fv_mpExt.Hide()
    End Sub

    Private Sub configElements(ByVal showPrompt As Boolean)
        prompt_lit.Visible = showPrompt
        outerCancel_btn.Visible = showPrompt
        project_fv.Visible = Not showPrompt
    End Sub

    Public Function formatStatusTxt(ByVal name As Object) As String
        Return IIf(name = "Complete", "<span class='GVCompleteHeaderStyle'>" & name & "</span>", IIf(name = "In Progress", "<span class='GVInProgressHeaderStyle'>" & name & "</span>", name))
    End Function

    Public Function getStatusCssClass(ByVal name As Object) As String
        Return IIf(name = "Complete", "GVCompleteHeaderStyle", IIf(name = "In Progress", "GVInProgressHeaderStyle", ""))
    End Function

    Public Function isVisible(ByVal f As Object) As Boolean
        Return (f IsNot DBNull.Value)
    End Function

    Public Function formatToolTipText(ByVal notes As Object) As String
        Return "<b>Notes:</b><br />" & notes
    End Function

    Public Function formatProjectText(ByVal name As Object) As String
        Return IIf(name IsNot DBNull.Value, name, "<i>(None associated)</i>")
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

    Public Function completeDateEnabled(ByVal status As Object) As Boolean
        Return (status = "Complete")
    End Function

    Protected Sub projectsSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Select Case manageProjects_ddl.SelectedValue
            Case -1
                project_fv.ChangeMode(FormViewMode.Insert)
            Case -2
                Session("SelectedProject") = Nothing
            Case Else
                Session("SelectedProject") = manageProjects_ddl.SelectedValue
                project_fv.ChangeMode(FormViewMode.ReadOnly)
        End Select
        project_fv.Visible = (manageProjects_ddl.SelectedValue <> -2)
        prompt_lit.Visible = (manageProjects_ddl.SelectedValue = -2)
        outerCancel_btn.Visible = (manageProjects_ddl.SelectedValue = -2)
    End Sub

    Protected Sub project_fv_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles project_fv.ItemCommand
        If e.CommandName = "Cancel" Then
            fv_mpExt.Hide()
        End If
    End Sub

    Protected Sub project_fv_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles project_fv.ItemDeleted
        configElements(True)

        Session("SelectedProject") = Nothing
        bindProjectsDDL()
        bindGridView(False)

    End Sub

    Protected Sub project_fv_ItemDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeleteEventArgs) Handles project_fv.ItemDeleting
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "UPDATE Tasks SET ProjectID = @ProjectID WHERE ProjectID = @FormerProjectID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter()
            oParam.ParameterName = "ProjectID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = DBNull.Value
            oCmd.Parameters.Add(oParam)

            oParam = New SqlParameter()
            oParam.ParameterName = "FormerProjectID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Session("SelectedProject")
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL

            oCmd.Connection.Open()
            oCmd.ExecuteScalar()

            oCmd.Connection.Close()

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub taskSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        For i As Integer = 0 To tasks_gv.Rows.Count - 1
            styleGridViewRows(tasks_gv.Rows(i), tasks_gv.DataKeys(i).Values("StatusID"))
        Next

        Session("SelectedTask") = tasks_gv.SelectedValue

        configFormView("Task")
        fv_updatePnl.Update()
        fv_mpExt.Show()
    End Sub


    Protected Sub project_fv_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles project_fv.ItemInserted
        project_fv.ChangeMode(FormViewMode.ReadOnly)
        bindProjectsDDL(Session("SelectedProject"))
    End Sub


    Protected Sub project_fv_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles project_fv.ItemUpdated
        project_fv.ChangeMode(FormViewMode.ReadOnly)
        bindProjectsDDL(Session("SelectedProject"))
        bindGridView(False)
    End Sub


    Protected Sub manageProjects_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles manageProjects_sds.Inserted
        Session("SelectedProject") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Public Function formatNullField(ByVal f As Object) As String
        Return IIf(f IsNot DBNull.Value, f, "<i>(None specified)</i>")
    End Function

    Public Function formatDateDisplay(ByVal d As Object) As String
        'Casting an object as a date when it is null throws an error, so I can't do this on one line
        If d IsNot DBNull.Value Then
            Return CType(d, DateTime).ToShortDateString
        Else
            Return "<i>(None specified)</i>"
        End If
    End Function

    Public Function formatDateInputText(ByVal d As Object) As String
        'Casting an object as a date when it is null throws an error, so I can't do this on one line
        If d IsNot DBNull.Value Then
            If CType(d, DateTime).ToShortDateString = "1/1/0001" Then
                Return ""
            Else
                Return d
            End If
        Else
            Return ""
        End If
    End Function

    Public Function formatTaskHeader() As String
        Return IIf(task_fv.DefaultMode = FormViewMode.Insert, "Add New Task", "Edit Task")
    End Function

    'I'm not currently using this, since I changed the CustomValidators to CompareValidators
    Public Sub validateDate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        Dim dt As DateTime
        args.IsValid = DateTime.TryParse(args.Value, dt)

    End Sub

    Protected Sub task_fv_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles task_fv.ItemCommand
        If e.CommandName = "Cancel" Then
            fv_mpExt.Hide()
        End If
    End Sub

    Protected Sub task_fv_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles task_fv.ItemDeleted
        fv_mpExt.Hide()
        bindGridView(False)
    End Sub

    Protected Sub task_fv_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles task_fv.ItemInserting
        e.Values("StartDate") = CType(task_fv.FindControl("startDateFV_txt"), TextBox).Text
        e.Values("CompleteDate") = IIf(insertEndDateFV_txt.Text.Trim = "", Nothing, insertEndDateFV_txt.Text.Trim)

        e.Values("ProjectID") = IIf(CType(task_fv.FindControl("projectFV_ddl"), DropDownList).SelectedValue = "-1", Nothing, CType(task_fv.FindControl("projectFV_ddl"), DropDownList).SelectedValue)

    End Sub

    Protected Sub task_fv_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles task_fv.ItemInserted
        fv_mpExt.Hide()
        bindGridView(False)
    End Sub

    Protected Sub task_fv_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles task_fv.ItemUpdating
        e.NewValues("StartDate") = CType(task_fv.FindControl("startDateFV_txt"), TextBox).Text
        e.NewValues("CompleteDate") = IIf(editEndDateFV_txt.Text.Trim = "", Nothing, editEndDateFV_txt.Text.Trim)

        e.NewValues("ProjectID") = IIf(CType(task_fv.FindControl("projectFV_ddl"), DropDownList).SelectedValue = "-1", Nothing, CType(task_fv.FindControl("projectFV_ddl"), DropDownList).SelectedValue)

    End Sub

    Protected Sub task_fv_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles task_fv.ItemUpdated
        fv_mpExt.Hide()
        bindGridView(False)
    End Sub

    Protected Sub task_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles task_sds.Inserted
        Session("SelectedTask") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub


    Protected Sub projectFV_ddl_databound(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim project As Object

        If Session("SelectedTask") IsNot Nothing Then
            project = getProjectForTask(Session("SelectedTask"))
            CType(sender, DropDownList).SelectedValue = IIf(project IsNot DBNull.Value, project, "-1")
        End If

    End Sub

    Protected Function getProjectForTask(ByVal taskID As Integer) As Object
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ProjectID FROM Tasks WHERE ID = @ID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter()
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = taskID
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()

            Return oCmd.ExecuteScalar()
        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
        End Try
    End Function

    Protected Sub insertStatusSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        'If a date was hand-entered, save it
        If insertEndDateFV_txt.Text.Trim.Length > 0 Then
            Session("InputCompleteDate") = insertEndDateFV_txt.Text.Trim
        End If

        insertEndDateFV_txt.Enabled = (CType(sender, DropDownList).SelectedValue = 6)

        If CType(sender, DropDownList).SelectedValue = 6 Then
            'If the user hand-entered a complete date, set it as it, otherwise use Now
            If Session("InputCompleteDate") IsNot Nothing Then
                insertEndDateFV_txt.Text = Session("InputCompleteDate")
                Session("InputCompleteDate") = Nothing
            ElseIf insertEndDateFV_txt.Text.Trim.Length = 0 Then
                insertEndDateFV_txt.Text = DateTime.Now.ToShortDateString
            End If

        Else
            'If the status is not Complete, clear out any CompleteDate input so that when inserting, 
            'checking for the input will determine what to set to e.values("CompleteDate")
            insertEndDateFV_txt.Text = ""
        End If

    End Sub

    Protected Sub editStatusSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        'If a date was hand-entered, save it
        If editEndDateFV_txt.Text.Trim.Length > 0 Then
            Session("InputCompleteDate") = editEndDateFV_txt.Text.Trim
        End If

        editEndDateFV_txt.Enabled = (CType(sender, DropDownList).SelectedValue = 6)

        'If the user hand-entered a complete date, set it as it, otherwise use Now
        If CType(sender, DropDownList).SelectedValue = 6 Then
            If Session("InputCompleteDate") IsNot Nothing Then
                editEndDateFV_txt.Text = Session("InputCompleteDate")
                Session("InputCompleteDate") = Nothing
            ElseIf editEndDateFV_txt.Text.Trim.Length = 0 Then
                editEndDateFV_txt.Text = DateTime.Now.ToShortDateString
            End If
        Else
            'If the status is not Complete, clear out any CompleteDate input so that when updating, 
            'checking for the input will determine what to set to e.NewValues("CompleteDate")
            editEndDateFV_txt.Text = ""
        End If

    End Sub

    Protected Sub statusHeaderClick(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim status As String = CType(sender, LinkButton).Text
        Dim sortStr As String = ""
        Dim statusID As Integer

        If Session("FirstSort") = True Then
            Session("FirstClickedHeader") = CType(sender, LinkButton).ClientID
            Session("FirstSort") = False
        End If

        For i As Integer = 0 To tasks_gv.Rows.Count - 1
            If CType(tasks_gv.Rows(i).FindControl("statusHeader_lBtn"), LinkButton) Is sender Then
                statusID = tasks_gv.DataKeys(i).Values("StatusID")
                Exit For
            End If
        Next

        'This allows me to order by each individual status
        sortStr = "CASE StatusName WHEN '" & status & "' THEN " & statusID & " END"

        'The first time a header is clicked, sort it to the top. 
        'All subsequent times the same header is clicked, toggle back and forth
        If CType(sender, LinkButton).ClientID <> Session("FirstClickedHeader") Then
            Session("SortDir") = SortDirection.Descending
            bindGridView(False, sortStr & " DESC")
            Session("FirstSort") = True
        Else
            'All subsequent same-header clicks
            If Session("SortDir") = SortDirection.Ascending Then
                Session("SortDir") = SortDirection.Descending
                bindGridView(False, sortStr & " DESC")
            ElseIf Session("SortDir") = SortDirection.Descending Then
                Session("SortDir") = SortDirection.Ascending
                bindGridView(False, sortStr & " ASC")
            End If
            Session("FirstSort") = False
        End If

    End Sub

End Class
