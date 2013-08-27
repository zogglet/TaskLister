<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Task Lister: Maggy's Task Management Tool</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="style.css" rel="stylesheet" type="text/css" />
    
</head>


<body>
    <form id="form1" runat="server">
    
        <%--Required for use of AJAX Control Toolkit --%>
        <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnablePartialRendering="true" />
        
        <%--General ModalPopup for FormViews--%>
        <asp:ModalPopupExtender ID="fv_mpExt" runat="server" TargetControlID="dummy" PopupControlID="fv_pnl" />
        <input type="button" id="dummy" runat="server" style="display: none;" />
        
        <asp:Panel ID="fv_pnl" runat="server" CssClass="ModalStyle" Width="400px">
        
            <asp:UpdatePanel ID="fv_updatePnl" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                
                
                    <%--Project FormView--%>
                    <asp:Panel ID="projectsFV_pnl" runat="server">
                    
                        <h3>Manage Projects</h3>
                        <span class="ModalDivider">&nbsp;</span>
                        <br />
                    
                        <table class="modal_options_area">
                            <tr>
                                <td>
                                    <asp:DropDownList ID="manageProjects_ddl" runat="server" DataTextField="ProjectName" DataValueField="ID" AutoPostBack="true" CssClass="ModalInputStyle"
                                        OnSelectedIndexChanged="projectsSelectedIndexChanged" />
                                </td>
                                <td>
                                    <asp:Literal ID="prompt_lit" runat="server" />
                                </td>
                            </tr>
                        </table>
                        <br />
                        <span style="text-align:right;display:block;">
                            <asp:Button ID="outerCancel_btn" runat="server" CssClass="ButtonStyle" Text="Cancel" OnClick="outerCancelClick" />
                        </span>
                        
                        <asp:FormView ID="project_fv" runat="server" DataKeyNames="ID" DataSourceID="manageProjects_sds" Width="100%">
                        
                            <HeaderTemplate>
                                <table class="FormViewTbl">
                            </HeaderTemplate>
                            
                            <EditItemTemplate>
                                    <tr>
                                        <td>
                                            Project Name:
                                            &nbsp;<asp:TextBox ID="projectName_txt" runat="server" Text='<%#Bind("ProjectName") %>' CssClass="ModalInputStyle" />
                                            
                                            <asp:RequiredFieldValidator ID="projectName_rVal" runat="server" ValidationGroup="project_vGroup" ControlToValidate="projectName_txt" ErrorMessage="Project name is required." Display="None" />
                                            <asp:ValidatorCalloutExtender ID="projectName_vcExt" runat="server" TargetControlID="projectName_rVal" WarningIconImageUrl="warningIcon.png"
                                                  CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span class="ModalDivider">&nbsp;</span>
                                            <br />
                                            
                                            <asp:Button ID="update_btn" runat="server" CausesValidation="true" ValidationGroup="project_vGroup" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                        </td>
                                    </tr>
                            </EditItemTemplate>
                            
                            <InsertItemTemplate>
                                    <tr>
                                        <td>
                                            Project Name:
                                            &nbsp;<asp:TextBox ID="projectName_txt" runat="server" Text='<%#Bind("ProjectName") %>' CssClass="ModalInputStyle" />
                                            
                                            <asp:RequiredFieldValidator ID="projectName_rVal" runat="server" ValidationGroup="project_vGroup" ControlToValidate="projectName_txt" ErrorMessage="Project name is required." Display="None" />
                                            <asp:ValidatorCalloutExtender ID="projectName_vcExt" runat="server" TargetControlID="projectName_rVal" WarningIconImageUrl="warningIcon.png"
                                                  CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span class="ModalDivider">&nbsp;</span>
                                            <br />
                                            
                                            <asp:Button ID="insert_btn" runat="server" CausesValidation="true" ValidationGroup="project_vGroup" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                        </td>
                                    </tr>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                    <tr>
                                        <td>
                                            Project Name:
                                            &nbsp;<asp:Label ID="projectName_lbl" runat="server" Text='<%#Bind("ProjectName") %>' CssClass="FormViewLbl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span class="ModalDivider">&nbsp;</span>
                                            <br />
                                            
                                            <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                                OnClientClick="return confirm('Deleting this project will disassociate all tasks assigned to this project. \nAre you sure you want to delete this project?');" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />  
                                        </td>
                                    </tr>
                            </ItemTemplate>
                            
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        
                        </asp:FormView>
                    
                    </asp:Panel>
                    <%--/Project FormView--%>
                    
                    
                    <%--Task FormView--%>
                    <asp:Panel ID="taskFV_pnl" runat="server">
                    
                        <asp:FormView ID="task_fv" runat="server" DataKeyNames="ID" DataSourceID="task_sds" Width="100%">
                        
                            <HeaderTemplate>
                                <table class="FormViewTbl">
                                    <tr>
                                        <td colspan="2">
                                            <h3><asp:Label ID="taskHeader_lbl" runat="server" Text='<%#formatTaskHeader() %>' /></h3>
                                            <span class="ModalDivider">&nbsp;</span>
                                            <br />
                                        </td>
                                    </tr>
                            </HeaderTemplate>
                            
                            <EditItemTemplate>
                                   <tr>
                                        <td colspan="2">
                                            Task: 
                                            &nbsp;<asp:TextBox ID="task_txt" runat="server" Text='<%#Bind("Task") %>' Width="300px" CssClass="ModalInputStyle" />
                                            
                                            <asp:RequiredFieldValidator ID="task_rVal" runat="server" ValidationGroup="task_vGroup" ControlToValidate="task_txt" ErrorMessage="Task name is required." Display="None" />
                                            <asp:ValidatorCalloutExtender ID="projectName_vcExt" runat="server" TargetControlID="task_rVal" WarningIconImageUrl="warningIcon.png"
                                                  CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Status:
                                            &nbsp;<asp:DropDownList ID="statusFV_ddl" runat="server" DataSourceID="statusFVDDL_sds" AutoPostBack="true" DataTextField="StatusName" DataValueField="ID" SelectedValue='<%#Bind("StatusID") %>'
                                                CssClass="ModalInputStyle" OnSelectedIndexChanged="editStatusSelectedIndexChanged" />
                                        </td>
                                        <td>
                                            Project:
                                            &nbsp;<asp:DropDownList ID="projectFV_ddl" runat="server" DataSourceID="projectFVDDL_sds" DataTextField="ProjectName" DataValueField="ID" 
                                                CssClass="ModalInputStyle" OnDataBound="projectFV_ddl_databound" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Start Date:
                                            &nbsp;<asp:TextBox ID="startDateFV_txt" runat="server" Text='<%#formatDateInputText(eval("StartDate")) %>' CssClass="ModalInputStyle" />
                                            <asp:CalendarExtender ID="startDateFV_calExt" runat="server" TargetControlID="startDateFV_txt" DefaultView="Days" />

                                            <asp:CompareValidator ID="startDateFV_cVal" runat="server" ValidationGroup="task_vGroup" ErrorMessage="Enter a valid date." Type="Date" 
                                                operator="DataTypeCheck" ControlToValidate="startDateFV_txt" Display="None" />
                                            <asp:ValidatorCalloutExtender ID="startDateFV_vcExt" runat="server" TargetControlID="startDateFV_cVal" WarningIconImageUrl="warningIcon.png"
                                                CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                        </td>
                                        <td>
                                        
                                            <asp:UpdatePanel ID="endDate_updatePnl" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    Complete Date:
                                                    &nbsp;<asp:TextBox ID="editEndDateFV_txt" runat="server" Text='<%#formatDateInputText(eval("CompleteDate")) %>' CssClass="ModalInputStyle" Enabled='<%#completeDateEnabled(eval("StatusName")) %>' />
                                                    <asp:CalendarExtender ID="editEndDateFV_calExt" runat="server" TargetControlID="editEndDateFV_txt" DefaultView="Days" />
                                                    
                                                    <asp:CompareValidator ID="editEndDateFV_cVal" runat="server" ValidationGroup="task_vGroup" ErrorMessage="Enter a valid date." ControlToValidate="editEndDateFV_txt" 
                                                         Type="Date" operator="DataTypeCheck" Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="editEndDateFV_vcExt" runat="server" TargetControlID="editEndDateFV_cVal" WarningIconImageUrl="warningIcon.png"
                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                        
                                                    <asp:CompareValidator ID="editEndDateFV_cVal2" runat="server" ValidationGroup="task_vGroup" ErrorMessage="Complete date cannot be earlier than start date." 
                                                        ControlToValidate="editEndDateFV_txt" ControlToCompare="startDateFV_txt" Type="Date" Operator="GreaterThan" Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="editEndDateFV_vcExt2" runat="server" TargetControlID="editEndDateFV_cVal2" WarningIconImageUrl="warningIcon.png"
                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="statusFV_ddl" EventName="SelectedIndexChanged" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            Notes:
                                            <br />
                                            <asp:TextBox ID="notes_txt" runat="server" Text='<%#Bind("Notes") %>' TextMode="MultiLine" Wrap="true" width="360px" Height="80px" CssClass="ModalInputStyle" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <span class="ModalDivider">&nbsp;</span>
                                            <br />
                                            
                                            <asp:Button ID="update_btn" runat="server" CausesValidation="true" ValidationGroup="task_vGroup" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                        </td>
                                    </tr>
                            </EditItemTemplate>
                            
                            <InsertItemTemplate>
                                    <tr>
                                        <td colspan="2">
                                            Task: 
                                            &nbsp;<asp:TextBox ID="task_txt" runat="server" Text='<%#Bind("Task") %>' Width="300px" CssClass="ModalInputStyle" />
                                            
                                            <asp:RequiredFieldValidator ID="task_rVal" runat="server" ValidationGroup="task_vGroup" ControlToValidate="task_txt" ErrorMessage="Task name is required." Display="None" />
                                            <asp:ValidatorCalloutExtender ID="projectName_vcExt" runat="server" TargetControlID="task_rVal" WarningIconImageUrl="warningIcon.png"
                                                  CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Status:
                                            &nbsp;<asp:DropDownList ID="statusFV_ddl" runat="server" DataSourceID="statusFVDDL_sds" AutoPostBack="true" DataTextField="StatusName" DataValueField="ID" SelectedValue='<%#Bind("StatusID") %>'
                                                CssClass="ModalInputStyle" OnSelectedIndexChanged="insertStatusSelectedIndexChanged" />
                                        </td>
                                        <td>
                                            Project:
                                            &nbsp;<asp:DropDownList ID="projectFV_ddl" runat="server" DataSourceID="projectFVDDL_sds" DataTextField="ProjectName" DataValueField="ID" 
                                                CssClass="ModalInputStyle" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Start Date:
                                            &nbsp;<asp:TextBox ID="startDateFV_txt" runat="server" Text='<%#formatDateInputText(eval("StartDate")) %>' CssClass="ModalInputStyle" />
                                            <asp:CalendarExtender ID="startDateFV_calExt" runat="server" TargetControlID="startDateFV_txt" DefaultView="Days" />
                                            
                                            <asp:CompareValidator ID="startDateFV_cVal" runat="server" ValidationGroup="task_vGroup" ErrorMessage="Enter a valid date." Type="Date" 
                                                operator="DataTypeCheck" ControlToValidate="startDateFV_txt" Display="None" />
                                            <asp:ValidatorCalloutExtender ID="startDateFV_vcExt" runat="server" TargetControlID="startDateFV_cVal" WarningIconImageUrl="warningIcon.png"
                                                CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                        </td>
                                        <td>
                                            <asp:UpdatePanel ID="endDate_updatePnl" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    Complete Date:
                                                    &nbsp;<asp:TextBox ID="insertEndDateFV_txt" runat="server" Text='<%#formatDateInputText(eval("CompleteDate")) %>' CssClass="ModalInputStyle" Enabled='<%#completeDateEnabled(eval("StatusName")) %>' />
                                                    <asp:CalendarExtender ID="insertEndDateFV_calExt" runat="server" TargetControlID="insertEndDateFV_txt" DefaultView="Days" />
                                                    
                                                    <asp:CompareValidator ID="insertEndDateFV_cVal" runat="server" ValidationGroup="task_vGroup" ErrorMessage="Enter a valid date." ControlToValidate="insertEndDateFV_txt" 
                                                         Type="Date" operator="DataTypeCheck" Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="insertEndDateFV_vcExt" runat="server" TargetControlID="insertEndDateFV_cVal" WarningIconImageUrl="warningIcon.png"
                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                        
                                                    <asp:CompareValidator ID="insertEndDateFV_cVal2" runat="server" ValidationGroup="task_vGroup" ErrorMessage="Complete date cannot be earlier than start date." 
                                                        ControlToValidate="insertEndDateFV_txt" ControlToCompare="startDateFV_txt" Type="Date" Operator="GreaterThan" Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="insertEndDateFV_vcExt2" runat="server" TargetControlID="insertEndDateFV_cVal2" WarningIconImageUrl="warningIcon.png"
                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="statusFV_ddl" EventName="SelectedIndexChanged" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            Notes:
                                            <br />
                                            <asp:TextBox ID="notes_txt" runat="server" Text='<%#Bind("Notes") %>' TextMode="MultiLine" Wrap="true" width="360px" Height="80px" CssClass="ModalInputStyle" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <span class="ModalDivider">&nbsp;</span>
                                            <br />
                                            
                                            <asp:Button ID="insert_btn" runat="server" CausesValidation="true" ValidationGroup="task_vGroup" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                        </td>
                                    </tr>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                    <tr>
                                        <td colspan="2">
                                            Task: 
                                            &nbsp;<asp:Label ID="task_lbl" runat="server" Text='<%#Bind("Task") %>' CssClass="FormViewLbl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Status:
                                            &nbsp;<asp:Label ID="status_lbl" runat="server" Text='<%#Bind("StatusName") %>' CssClass="FormViewLbl" />
                                        </td>
                                        <td>
                                            Project:
                                            &nbsp;<asp:Label ID="project_lbl" runat="server" Text='<%#formatNullField(eval("ProjectName")) %>' CssClass="FormViewLbl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Start Date:
                                            &nbsp;<asp:Label ID="startDate_lbl" runat="server" Text='<%#formatDateDisplay(eval("StartDate")) %>' CssClass="FormViewLbl" />
                                        </td>
                                        <td>
                                            Complete Date:
                                            &nbsp;<asp:Label ID="endDate_lbl" runat="server" Text='<%#formatDateDisplay(eval("CompleteDate")) %>' CssClass="FormViewLbl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            Notes:
                                            <br />
                                            <asp:Label ID="notes_lbl" runat="server" Text='<%#formatNullField(eval("Notes")) %>' CssClass="FormViewLbl" Font-Italic="true" Font-Bold="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <span class="ModalDivider">&nbsp;</span>
                                            <br />
                                            
                                            <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                                OnClientClick="return confirm('Are you sure you want to delete this task?');" CssClass="ButtonStyle" />
                                            &nbsp;&nbsp;
                                            <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" /> 
                                        </td>
                                    </tr>
                            </ItemTemplate>
                            
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:FormView>
                    
                    </asp:Panel>
                    <%--/Task FormView--%>

                
                </ContentTemplate>
                
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="project_fv" EventName="ModeChanged" />
                    <asp:AsyncPostBackTrigger ControlID="project_fv" EventName="ItemInserted" />
                    <asp:AsyncPostBackTrigger ControlID="project_fv" EventName="ItemUpdated" />
                    <asp:AsyncPostBackTrigger ControlID="project_fv" EventName="ItemCommand" />
                    
                    <asp:AsyncPostBackTrigger ControlID="task_fv" EventName="ModeChanged" />
                    <asp:AsyncPostBackTrigger ControlID="task_fv" EventName="ItemInserted" />
                    <asp:AsyncPostBackTrigger ControlID="task_fv" EventName="ItemUpdated" />
                    <asp:AsyncPostBackTrigger ControlID="task_fv" EventName="ItemCommand" />
                    
                    <asp:AsyncPostBackTrigger ControlID="manageProjects_ddl" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="manageProjects_btn" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="addTask_btn" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
        
        </asp:Panel>
        
        <%-- ************************************************************************--%>
        
        <div class="LoginStatusStyle">
            <asp:LoginView ID="loginView" runat="server">
                <AnonymousTemplate>
                    <i>Currently logged out</i>
                    <br />
                    <asp:LoginStatus ID="loginStatus" runat="server" LoginText="[Log In]" LogoutText="[Log Out]" />
                </AnonymousTemplate>
                <LoggedInTemplate>
                    <asp:LoginName ID="loginName" runat="server" FormatString="Greetings, <b>{0}</b>!" />
                    <br />
                    <asp:LoginStatus ID="loginStatus" runat="server" LoginText="[Log In]" LogoutText="[Log Out]" />
                </LoggedInTemplate>
            </asp:LoginView>
        </div>
    
        <br />
        <h1>Task Lister</h1>
        <h2>Maggy's Task Management Tool</h2>
    
        <div id="outer_div">
        
            <table id="outer_table">
                <tr>
                    <td>
                        
                        <table class="options_area">
                            <tr>
                                <td>
                                    <h3>Welcome to Task Lister</h3>
                                    <p>Start by adding tasks or projects to which to assign tasks.</p>
                                    <p>You can filter and sort the list of tasks using the options below.</p>
                                    <p>Once you create your list, you can generate a printable version of it. You can select to print it reflecting 
                                    the status of each task as selected in this application, or as a checklist which you can check off by hand.</p>
                                </td>
                                <td align="right" style="border-left: solid 2px #414141; padding-left: 10px;">

                                    <%--Print options (only visible when the task list is not completely empty)--%>
                                    <asp:Panel ID="print_pnl" runat="server" Visible="false">
                                       
                                        <table class="PrintPnlStyle">
                                            <tr>
                                                <td>
                                                    <b>List Title:</b>
                                                    <asp:TextBox ID="listTitle_txt" runat="server" CssClass="InputStyle" />
                                                    <br />
                                                    <asp:RadioButtonList ID="print_rbList" runat="server" RepeatDirection="Horizontal">
                                                        <asp:ListItem Text="Checklist" Value="Checklist" Selected="True" />
                                                        <asp:ListItem Text="Reflect Completion" Value="Completion" />
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Button ID="printPage_btn" runat="server" Text="Printable List &raquo;" CssClass="ButtonStyle" OnClick="gotoPrintClick" />
                                                </td>
                                            </tr>
                                        </table>
                                        
                                        <span class="OptionsDivider">&nbsp;</span>
                                        <br />
                                    </asp:Panel>
                                    
                                    <asp:Button ID="addTask_btn" runat="server" Text="+ Task" CssClass="ButtonStyle" Width="130px" OnClick="addTaskClick" />
                                    <br /><br />
                                    <asp:Button id="manageProjects_btn" runat="server" Text="Manage Projects" CssClass="ButtonStyle" OnClick="manageProjectsClick" />
                                    <br /><br />
                                    <asp:Button ID="report_btn" runat="server" Text="Generate Report" CssClass="ButtonStyle" OnClick="genReportClick" />
                                    
                                    
                                </td>
                            </tr>
                            <tr>
                                <%--Drilldown options--%>
                                <td colspan="2">
                                    <span class="OptionsDivider">&nbsp;</span>
                                    <br />
                                    
                                    <asp:UpdatePanel ID="options_updatePnl" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table class="inner_options_area">
                                                <tr>
                                                    <td class="ioa_cell">
                                                        Keyword(s): 
                                                        <br /><asp:TextBox ID="search_txt" runat="server" CssClass="InputStyle" />
                                                    </td>
                                                    <td class="ioa_cell">
                                                        Status: 
                                                        <br /><asp:DropDownList ID="status_ddl" runat="server" DataSourceID="statusDDL_sds" DataTextField="StatusName" DataValueField="ID" CssClass="InputStyle" />
                                                    </td>
                                                    <td class="ioa_cell">
                                                        Project: 
                                                        <br /><asp:DropDownList ID="project_ddl" runat="server" DataSourceID="projectDDL_sds" DataTextField="ProjectName" DataValueField="ID" CssClass="InputStyle" />
                                                    </td>
                                                    <td class="ioa_cell">
                                                        Start Date:
                                                        <br /><asp:TextBox ID="startDate_txt" runat="server" CssClass="InputStyle" Width="110px" />
                                                        <asp:CalendarExtender ID="startDate_calExt" runat="server" TargetControlID="startDate_txt" DefaultView="Days" />
                                                        
                                                        <%--This will validate only a date, not a full DateTime--%>
                                                        <asp:CompareValidator ID="startDate_cVal" runat="server" ValidationGroup="options_vGroup" ErrorMessage="Enter a valid date." Type="Date" 
                                                            operator="DataTypeCheck" ControlToValidate="startDate_txt" Display="None" />
                                                        <asp:ValidatorCalloutExtender ID="startDate_vcExt" runat="server" TargetControlID="startDate_cVal" WarningIconImageUrl="warningIcon.png"
                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    </td>
                                                    <td class="ioa_cell">
                                                        End Date:
                                                        <br /><asp:TextBox ID="endDate_txt" runat="server" CssClass="InputStyle" Width="110px" />
                                                        <asp:CalendarExtender ID="endDate_calExt" runat="server" TargetControlID="endDate_txt" DefaultView="Days" />
                                                        
                                                        <%--This will validate only a date, not a full DateTime--%>
                                                        <asp:CompareValidator ID="endDate_cVal" runat="server" ValidationGroup="options_vGroup" ErrorMessage="Enter a valid date." ControlToValidate="endDate_txt" 
                                                             Type="Date" operator="DataTypeCheck" Display="None" />
                                                        <asp:ValidatorCalloutExtender ID="endDate_vcExt" runat="server" TargetControlID="endDate_cVal" WarningIconImageUrl="warningIcon.png"
                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                            
                                                        <asp:CompareValidator ID="endDate_cVal2" runat="server" ValidationGroup="options_vGroup" ErrorMessage="Complete date cannot be earlier than start date." 
                                                            ControlToValidate="endDate_txt" ControlToCompare="startDate_txt" Type="Date" Operator="GreaterThan" Display="None" />
                                                        <asp:ValidatorCalloutExtender ID="endDate_vcExt2" runat="server" TargetControlID="endDate_cVal2" WarningIconImageUrl="warningIcon.png"
                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="reset_btn" EventName="click" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                    
                                </td>
                                <%--/Drilldown options--%>
                                
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <span class="OptionsDivider">&nbsp;</span>
                                    <br />
                                    <asp:Button ID="filter_btn" runat="server" ValidationGroup="options_vGroup" CssClass="ButtonStyle" Text="Filter Tasks" OnClick="filterClick"/>
                                    &nbsp;
                                    <asp:Button ID="reset_btn" runat="server" CausesValidation="false" CssClass="ButtonStyle" Text="Reset Filter" OnClick="resetClick" />
                                </td>
                            </tr>
                        
                        </table>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        
                        <asp:UpdatePanel ID="tasks_updatePnl" runat="server" UpdateMode="Conditional">
                            
                            <ContentTemplate>
                                
                                <asp:GridView ID="tasks_gv" runat="server" DataKeyNames="ID, StatusID" AutoGenerateColumns="false" GridLines="None" 
                                    AllowSorting="true" AllowPaging="true" PageSize="50" HeaderStyle-CssClass="GVHeaderStyle" RowStyle-CssClass="GVItemStyle" CssClass="GVStyle"
                                    OnRowDataBound="tasksDataBound" OnSelectedIndexChanged="taskSelectedIndexChanged" OnSorting="tasksSorting">
                                
                                    <Columns>
                                        
                                        <asp:TemplateField HeaderText="Task" HeaderStyle-CssClass="GVTaskHeaderStyle" SortExpression="Task" ItemStyle-Width="200px" ItemStyle-CssClass="GVButtonItemStyle">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="task_lBtn" runat="server" CommandName="Select" Text='<%#eval("Task") %>' />
                                                
                                                <asp:HoverMenuExtender ID="notes_hmExt" runat="server" TargetControlID="task_lBtn" PopupControlID="tooltip_pnl"
                                                    PopupPosition="Right" HoverDelay="0" />
                                                    
                                                <asp:Panel ID="tooltip_pnl" runat="server" CssClass="ToolTipStyle" Visible='<%#isVisible(eval("Notes")) %>'>
                                                    <asp:Literal ID="tooltip_lit" runat="server" Text='<%#formatTooltipText(eval("Notes")) %>' />
                                                </asp:Panel>
                                                
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Project" HeaderStyle-CssClass="GVTaskHeaderStyle" SortExpression="ProjectName">
                                            <ItemTemplate>
                                                <asp:Literal ID="project_lit" runat="server" Text='<%#formatProjectText(eval("ProjectName")) %>' />
                                            </ItemTemplate>
                                        
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Start Date" HeaderStyle-CssClass="GVTaskHeaderStyle" SortExpression="StartDate" >
                                            <ItemTemplate>
                                                <asp:Literal ID="startDate_lit" runat="server" Text='<%#formatDateTxt(eval("StartDate")) %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Complete Date" HeaderStyle-CssClass="GVTaskHeaderStyle" SortExpression="CompleteDate">
                                            <ItemTemplate>
                                                <asp:Literal ID="completeDate_lit" runat="server" Text='<%#formatCompleteDateTxt(eval("StatusName"), eval("CompleteDate")) %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField>
                                        
                                            <HeaderTemplate>

                                                <asp:DataList ID="status_dList" runat="server" DataSourceID="status_sds" RepeatDirection="Horizontal">
                                                    <HeaderTemplate>
                                                        <table class="StatusTable">
                                                            <tr>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                                <td>
                                                                    <asp:LinkButton ID="statusHeader_lBtn" runat="server" Text='<%#eval("StatusName") %>' CssClass='<%#getStatusCssClass(eval("StatusName")) %>' OnClick="statusHeaderClick" />
                                                                </td>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                            </tr>
                                                        </table>
                                                    </FooterTemplate>
                                                </asp:DataList>
                                                
                                            </HeaderTemplate>
                                            
                                            <ItemTemplate>
                                                <%--The BlankLabel field allows only the radio button to show--%>
                                                <asp:RadioButtonList ID="status_rbList" runat="server" DataSourceID="status_sds" RepeatDirection="Horizontal" CssClass="RBListStyle"
                                                    AutoPostBack="true" DataValueField="ID" DataTextField="BlankLabel" SelectedValue='<%#eval("StatusID") %>' OnSelectedIndexChanged="selectedStatusChanged" />

                                            </ItemTemplate>
                                        </asp:TemplateField>
 
                                    </Columns>
                                    
                                </asp:GridView>
                                
                                <asp:Literal ID="indicator_lit" runat="server" />
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="filter_btn" EventName="click" />
                                <asp:AsyncPostBackTrigger ControlID="reset_btn" EventName="click" />
                                <asp:AsyncPostBackTrigger ControlID="tasks_gv" EventName="sorted" />
                            </Triggers>
                            
                        </asp:UpdatePanel>
                    
                    </td>
                </tr>
            </table>
            
            <%-- ************************************************************************--%>
            
            <asp:SqlDataSource ID="status_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString%>" 
                SelectCommand="SELECT * FROM Status" />
                
            <asp:SqlDataSource ID="statusDDL_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString %>" 
                SelectCommand="SELECT ID, StatusName FROM Status UNION SELECT -1 AS ID, '-- All --' AS StatusName ORDER BY ID" />
                
            <asp:SqlDataSource ID="projectDDL_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString %>" 
                SelectCommand="SELECT ID, ProjectName FROM Projects UNION SELECT -1 as ID, '(None)' AS ProjectName UNION SELECT -2 AS ID, '-- All --' AS ProjectName ORDER BY ID" />
                
            <asp:SqlDataSource ID="projectFVDDL_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString %>" 
                SelectCommand="SELECT ID, ProjectName FROM Projects UNION SELECT -1 AS ID, '(None)' AS ProjectName ORDER BY ID" />
                
            <asp:SqlDataSource ID="statusFVDDL_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString %>" 
                SelectCommand="SELECT ID, StatusName FROM Status ORDER BY ID" />
        
            <asp:SqlDataSource ID="manageProjects_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString%>" 
                SelectCommand="SELECT ID, ProjectName FROM Projects WHERE ID = @ID"
                InsertCommand="INSERT INTO Projects (ProjectName) VALUES (@ProjectName);SET @NewID = SCOPE_IDENTITY()"
                UpdateCommand="UPDATE Projects SET ProjectName = @ProjectName WHERE ID = @ID"
                DeleteCommand="DELETE FROM Projects WHERE ID = @ID"
                >
                
                <SelectParameters>
                    <asp:SessionParameter Name="ID" SessionField="SelectedProject" Type="Int32" />
                </SelectParameters>
                
                <InsertParameters>
                    <asp:Parameter Name="ProjectName" type="String" />
                    <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
                </InsertParameters>
                
                <UpdateParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                    <asp:Parameter Name="ProjectName" type="String" />
                </UpdateParameters>
                
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
            </asp:SqlDataSource>
                
        
            <asp:SqlDataSource ID="task_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString%>" 
                SelectCommand="SELECT Tasks.ID, Task, StatusID, Notes, StartDate, CompleteDate, ProjectID, StatusName, ProjectName FROM Tasks INNER JOIN Status ON Tasks.StatusID = Status.ID LEFT JOIN Projects ON Tasks.ProjectID = Projects.ID WHERE Tasks.ID = @ID"
                Insertcommand="INSERT INTO Tasks (Task, StatusID, Notes, StartDate, CompleteDate, ProjectID) VALUES (@Task, @StatusID, @Notes, @StartDate, @CompleteDate, @ProjectID);SET @NewID = SCOPE_IDENTITY()"
                UpdateCommand="UPDATE Tasks SET Task = @Task, StatusID = @StatusID, Notes = @Notes, StartDate = @StartDate, CompleteDate = @CompleteDate, ProjectID = @ProjectID WHERE ID = @ID"
                DeleteCommand="DELETE FROM Tasks WHERE ID = @ID"
                >
                
                <SelectParameters>
                    <asp:SessionParameter Name="ID" SessionField="SelectedTask" Type="Int32" />
                </SelectParameters>
                
                <InsertParameters>
                    <asp:Parameter Name="Task" Type="String" />
                    <asp:Parameter Name="StatusID" Type="Int32" />
                    <asp:Parameter Name="Notes" Type="String" />
                    <asp:Parameter Name="StartDate" Type="DateTime" />
                    <asp:Parameter Name="CompleteDate" Type="DateTime" />
                    <asp:Parameter Name="ProjectID" Type="Int32" />
                    <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
                </InsertParameters>
                
                <UpdateParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                    <asp:Parameter Name="Task" Type="String" />
                    <asp:Parameter Name="StatusID" Type="Int32" />
                    <asp:Parameter Name="Notes" Type="String" />
                    <asp:Parameter Name="StartDate" Type="DateTime" />
                    <asp:Parameter Name="CompleteDate" Type="DateTime" />
                    <asp:Parameter Name="ProjectID" Type="Int32" /> 
                </UpdateParameters>
                
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                    
            </asp:SqlDataSource>
        </div>
        
        <div class="Footer">
            Copyright &copy; 2011, <a href="mailto:maggy@zogglet.com?subject=About your awesome Task Lister application">Maggy Maffia</a>
        </div>
        
        
    </form>
</body>
</html>
