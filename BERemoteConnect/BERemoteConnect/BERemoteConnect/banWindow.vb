Public Class banWindow
    Public PlayerID = ""
    Public PlayerName = ""
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Try
            Form1.Client.SendCommand(BattleNET.BattlEyeCommand.Ban, PlayerID & " 0 " & TextBox3.Text)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub banWindow_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        TextBox1.Text = PlayerName
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Me.Close()
    End Sub
End Class