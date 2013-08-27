<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Task Lister: Maggy's Task Management Tool - Log In</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="style.css" rel="stylesheet" type="text/css" />
    
</head>
<body>
    <form id="form1" runat="server">
        
        <h1>Task Lister</h1>
        <h2>Maggy's Task Management Tool</h2>
    
        <div id="outer_div">
        
            <h3>Log In</h3>
            
            <table id="blank_outer_table">
                <tr>
                    <td>
                    
                         <asp:Login ID="login2" runat="server" DisplayRememberMe="false" BackColor="#414141" Width="375px" BorderColor="#4b4b4b" BorderWidth="2px" BorderStyle="Solid">
                            <TextBoxStyle CssClass="InputStyle" />
                            <LoginButtonStyle CssClass="ButtonStyle" />
                            <InstructionTextStyle Font-Size="11px" />
                            <LabelStyle Font-Bold="true" ForeColor="#b8b8b8" HorizontalAlign="Left" Font-Size="12px" />
                            <TitleTextStyle font-bold="true" backcolor="#4b4b4b" ForeColor="#ecd65d" Font-Size="12px" />
                        </asp:Login>
                        <br />
                        <asp:PasswordRecovery ID="passwordRecovery2" runat="server" BackColor="#414141" Width="375px" BorderColor="#4b4b4b" BorderWidth="2px" BorderStyle="Solid">
                            <TextBoxStyle CssClass="InputStyle" />
                            <SubmitButtonStyle CssClass="ButtonStyle" /> 
                            <InstructionTextStyle Font-Size="11px" />
                            <LabelStyle Font-Bold="true" ForeColor="#b8b8b8" HorizontalAlign="Left" Font-Size="12px" />
                            <TitleTextStyle font-bold="true" backcolor="#4b4b4b" ForeColor="#ecd65d" Font-Size="12px" />
                        </asp:PasswordRecovery>
                    
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
