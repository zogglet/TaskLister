<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Report.aspx.vb" Inherits="Report" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Task Lister: Maggy's Task Management Tool</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="style.css" rel="stylesheet" type="text/css" />
    
</head>

<body>
    <form id="form1" runat="server">
    
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
                                    <h3>Task List Report</h3>
                                    <p>Below, you can both preview and print, and render and obtain an SSRS report of your task list in the output format of your choice, organized by status and project.</p>
                                    <p>Select the values for any available parameters for the report.</p>
                                    <span class="OptionsDivider">&nbsp;</span>
                                    <br />
                                    <asp:Button ID="back_btn" runat="server" Text="&laquo; Back" CssClass="ButtonStyle" OnClick="backClick" />
                                </td>
                            
                            </tr>
                        </table>
                        
                        
                        <br />
                        <mag:ReportControl id="report_ctrl" runat="server" />
                    </td>
                </tr>
            
            </table>
        
        </div>
        
        <div class="Footer">
            Copyright &copy; 2011, <a href="mailto:maggy@zogglet.com?subject=About your awesome Task Lister application">Maggy Maffia</a>
        </div>
        
    </form>
</body>
</html>
