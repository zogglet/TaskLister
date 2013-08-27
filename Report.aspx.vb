
Partial Class Report
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        report_ctrl.ReportName = "TasksByStatusAndProject"
        'report_ctrl.ReportName = "CompleteTasksByWeek"
        report_ctrl.ReportPath = System.Configuration.ConfigurationManager.AppSettings("ReportPath")
        report_ctrl.ReportServerURL = System.Configuration.ConfigurationManager.AppSettings("ReportURL")

    End Sub

    Protected Sub backClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("Default.aspx")
    End Sub

End Class
