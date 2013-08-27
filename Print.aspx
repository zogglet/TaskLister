<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Print.aspx.vb" Inherits="Print" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Task Lister: Maggy's Task Management Tool</title>
    
    <link href="favicon.ico" rel="icon" type="image/x-icon" />
    <link href="print.css" rel="stylesheet" type="text/css" />
    
</head>
<body>
    <form id="form1" runat="server">
    
        <div id="outer_div">
        
            <table id="outer_table">
                <tr>
                    <td>
                        <table class="options_area">
                            <tr>
                                <td>
                                    <asp:Literal ID="title_lit" runat="server" />
                                    <%--This is in a separate literal in order to toggle it if nothing exists--%>
                                    <asp:Literal ID="summary_lit" runat="server" />
                                    <br />
                                    
                                    <asp:Panel ID="printItems_pnl" runat="server" HorizontalAlign="Center">
                                        <asp:Button ID="back_btn" runat="server" Text="&laquo; Back" CssClass="ButtonStyle" OnClick="backClick" />
                                        &nbsp;&nbsp;<asp:Button ID="print_btn" runat="server" Text="Print" CssClass="ButtonStyle" OnClientClick="window.print();return false" />
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                        <br />
                        
                    </td>
                </tr>
                
                <tr>
                    <td>
                        
                        <asp:GridView ID="tasks_gv" runat="server" DataKeyNames="ID, StatusID" AutoGenerateColumns="false" GridLines="None" 
                            AllowSorting="false" AllowPaging="false" HeaderStyle-CssClass="GVHeaderStyle" RowStyle-CssClass="GVItemStyle" CssClass="GVStyle"
                            OnRowDataBound="tasksDataBound">
                        
                            <Columns>
                                
                                <asp:BoundField HeaderText="Task" DataField="Task" ItemStyle-Font-Bold="true" />
                                
                                <asp:TemplateField HeaderText="Project">
                                    <ItemTemplate>
                                        <asp:Literal ID="project_lit" runat="server" Text='<%#formatProjectText(eval("ProjectName")) %>' />
                                    </ItemTemplate>
                                
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Start Date">
                                    <ItemTemplate>
                                        <asp:Literal ID="startDate_lit" runat="server" Text='<%#formatDateTxt(eval("StartDate")) %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Complete Date">
                                    <ItemTemplate>
                                        <asp:Literal ID="completeDate_lit" runat="server" Text='<%#formatCompleteDateTxt(eval("StatusName"), eval("CompleteDate")) %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField>
                                
                                    <HeaderTemplate>
                                    
                                        <asp:DataList ID="status_headerDList" runat="server" RepeatDirection="Horizontal" DataSourceID="status_sds">
                                            <HeaderTemplate>
                                                <table class="StatusTable">
                                                    <tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                        <th>
                                                            <asp:Literal ID="statusHeader_lit" runat="server" Text='<%#formatStatusTxt(eval("StatusName")) %>' />
                                                        </th>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                    </tr>
                                                </table>
                                            </FooterTemplate>
                                        </asp:DataList>
                                        
                                    </HeaderTemplate>
                                    
                                    <ItemTemplate>
                                    
                                        <asp:DataList ID="status_dList" runat="server" RepeatDirection="Horizontal" DataSourceID="status_sds">
                                            <HeaderTemplate>
                                                <table class="StatusTable">
                                                    <tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                        <td class="StatusCell">
                                                            <asp:HiddenField ID="status_hField" runat="server" Value='<%#eval("ID") %>' />
                                                            <asp:Image ID="taskComplete_img" runat="server" />
                                                        </td>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                    </tr>
                                                </table>
                                            </FooterTemplate>
                                        </asp:DataList>
                                        
                                        <asp:Literal ID="notes_lit" runat="server" Text='<%#formatNotesText(eval("Notes")) %>' />
                                        
                                    </ItemTemplate>
                                    
                                </asp:TemplateField>

                            </Columns>
                            
                        </asp:GridView>
                        
                    </td>
                </tr>
            </table>
            
            <asp:SqlDataSource ID="status_sds" runat="server" ConnectionString="<%$ ConnectionStrings:TaskListConnectionString%>" 
                SelectCommand="SELECT * FROM Status" />
            
        </div>
        
        <div class="Footer">
            Copyright &copy; 2011, Maggy Maffia
        </div>
        
    </form>
</body>
</html>
