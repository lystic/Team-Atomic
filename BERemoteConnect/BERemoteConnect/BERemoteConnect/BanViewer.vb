Imports System.Windows.Forms.ListBox

Public Class BanViewer
    Public BanList As String()
    Private Sub BanViewer_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim collection = New ObjectCollection(ListBox1, BanList)
        '   ListBox1.Update()
    End Sub
End Class