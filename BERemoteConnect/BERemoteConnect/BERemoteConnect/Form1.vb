Imports System.IO
Imports System
Imports BattleNET
Imports System.Net
Imports System.Text.RegularExpressions

Public Class Form1
    Public WithEvents Client As BattlEyeClient
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Dim creds As New BattlEyeLoginCredentials
        Dim p = TextBox1.Text.Replace(" ", "").Split(":")
        If (p.Count = 1) Then
            MsgBox("Please enter an IP:PORT", MsgBoxStyle.Exclamation, "Oh Noes!")
            Exit Sub
        End If
        Try
            If (Client.Connected()) Then
                MsgBox("You are already connected to a server!", MsgBoxStyle.Exclamation, "Oh Noes!")
                Exit Sub
            End If
        Catch ex As Exception

        End Try
        Dim ip = p(0)
        Dim port = p(1)
        Dim pass = TextBox2.Text
        creds.Host = IPAddress.Parse(ip)
        creds.Port = Int(port)
        creds.Password = pass

        Client = New BattlEyeClient(creds)
        Client.ReconnectOnPacketLoss = True
        Dim result As BattlEyeConnectionResult = Client.Connect()
        If (result = BattlEyeConnectionResult.ConnectionFailed) Then
            MsgBox("Connection Failed! Please Enter The Correct IP:PORT Combination", MsgBoxStyle.Critical, "Connection Failed!")
        ElseIf (result = BattlEyeConnectionResult.InvalidLogin) Then
            MsgBox("Invalid Login! Please Enter the correct password for the server!", MsgBoxStyle.Critical, "Invalid Login")
        ElseIf (result <> BattlEyeConnectionResult.Success) Then
            MsgBox("Unkown Error!", MsgBoxStyle.Critical, "Error!")
        Else
            Client.SendCommand(BattlEyeCommand.Players)
        End If
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Try
            Client.Disconnect()
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Client_BattlEyeConnected(args As BattlEyeConnectEventArgs) Handles Client.BattlEyeConnected

    End Sub

    Private Sub Client_BattlEyeDisconnected(args As BattlEyeDisconnectEventArgs) Handles Client.BattlEyeDisconnected
        If (ListView1.InvokeRequired) Then
            ListView1.Invoke(Sub() ListView1.Items.Clear())
        Else
            ListView1.Items.Clear()
        End If
        MsgBox("Disconnected!", MsgBoxStyle.Information, "")
    End Sub

    Private Sub Client_BattlEyeMessageReceived(args As BattlEyeMessageEventArgs) Handles Client.BattlEyeMessageReceived
        Dim msg = args.Message
        Dim id = args.Id
        If (msg.Contains("Players on server")) Then
            Dim parts = msg.Split(vbLf)
            Dim startIndex = 3
            Dim stopIndex = parts.Count - 2
            If (Label3.InvokeRequired) Then
                Label3.Invoke(Sub() Label3.Text = "Players: " & Str(stopIndex - startIndex))
            Else
                Label3.Text = "Players: " & Str(stopIndex - startIndex)
            End If
            If (ListView1.InvokeRequired) Then
                ListView1.Invoke(Sub() ListView1.Items.Clear())
            Else
                ListView1.Items.Clear()
            End If
            For i As Integer = startIndex To stopIndex Step 1
                Dim line = parts(i)
                line = Regex.Replace(line, "\s+", " ")
                Dim sections = line.Split(" ")
                If (sections.Length > 5) Then
                    Dim temp As New List(Of String)
                    temp.Add(sections(0))
                    temp.Add(sections(1))
                    temp.Add(sections(2))
                    temp.Add(sections(3))
                    Dim holder = ""
                    For j As Integer = 4 To sections.Count - 1
                        holder = holder & " " & sections(j)
                    Next
                    holder = holder.Remove(0, 1)
                    temp.Add(holder)
                    sections = temp.ToArray
                End If
                If (ListView1.InvokeRequired) Then
                    ListView1.Invoke(Sub() ListView1.Items.Add(sections(0)).SubItems.AddRange({sections(1), sections(2), sections(3), sections(4)}))
                Else
                    ListView1.Items.Add(sections(0)).SubItems.AddRange({sections(1), sections(2), sections(3), sections(4)})
                End If
            Next
        ElseIf (msg.Contains("GUID Bans")) Then
            Dim parts = msg.Split(vbLf)
            Dim startIndex = 3
            Dim stopIndex = parts.Count - 1
            Dim lines As New List(Of String)
            For i As Integer = startIndex To stopIndex
                lines.Add(parts(i))
            Next
            Dim window As New BanViewer()
            window.BanList = lines.ToArray()
            window.Show()
            'MsgBox(msg, MsgBoxStyle.OkOnly, "Ban List")
        Else
            If (CheckBox1.Checked) Then
                If (ListBox1.InvokeRequired) Then
                    ListBox1.Invoke(Sub() ListBox1.Items.Add(msg))
                Else
                    ListBox1.Items.Add(id & "|" & msg)
                End If
            End If
        End If
    End Sub


    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Try
            Client.SendCommand(BattlEyeCommand.Players)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub ListView1_MouseClick(sender As Object, e As MouseEventArgs) Handles ListView1.MouseClick
        If e.Button = Windows.Forms.MouseButtons.Right Then
            If (ListView1.SelectedItems.Contains(ListView1.FocusedItem)) Then
                If (ListView1.FocusedItem.Bounds.Contains(e.Location)) Then
                    menu_playeroptions.Show(Cursor.Position)
                End If
            End If
        End If
    End Sub

    Private Sub KickToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles KickToolStripMenuItem.Click
        If (ListView1.SelectedItems.Contains(ListView1.FocusedItem)) Then
            Dim ID = ListView1.FocusedItem.Text
            Try
                Client.SendCommand(BattlEyeCommand.Kick, ID)
            Catch ex As Exception

            End Try
        End If
    End Sub

    Private Sub BanToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles BanToolStripMenuItem.Click
        If (ListView1.SelectedItems.Contains(ListView1.FocusedItem)) Then
            Dim ID = ListView1.FocusedItem.Text
            Dim window As New banWindow()
            window.PlayerID = ID
            window.PlayerName = ListView1.FocusedItem.SubItems(4).Text
            window.Show()
        End If
        
    End Sub

    Private Sub Form1_FormClosing(sender As Object, e As FormClosingEventArgs) Handles Me.FormClosing
        Try
            Client.Disconnect()
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Dim message = TextBox3.Text
        Try
            Client.SendCommand(BattlEyeCommand.Say, "-1 " & message)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        Dim ping = TextBox4.Text
        Try
            If (Int(ping) > 0) Then
                Client.SendCommand(BattlEyeCommand.MaxPing, ping)
            End If
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        Try
            Client.SendCommand(BattlEyeCommand.WriteBans)
            Client.SendCommand(BattlEyeCommand.Bans)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Try
            Client.SendCommand(BattlEyeCommand.LoadScripts)
            Client.SendCommand(BattlEyeCommand.loadEvents)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Try
            Client.SendCommand(BattlEyeCommand.LoadBans)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button11_Click(sender As Object, e As EventArgs) Handles Button11.Click
        Try
            Client.SendCommand(BattlEyeCommand.Lock)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button12_Click(sender As Object, e As EventArgs) Handles Button12.Click
        Try
            Client.SendCommand(BattlEyeCommand.Unlock)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button13_Click(sender As Object, e As EventArgs) Handles Button13.Click
        Try
            Client.SendCommand(BattlEyeCommand.Restart)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub Button14_Click(sender As Object, e As EventArgs) Handles Button14.Click
        Try
            Client.SendCommand(BattlEyeCommand.Shutdown)
        Catch ex As Exception

        End Try
    End Sub

    Private Sub CopyToClipboardToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CopyToClipboardToolStripMenuItem.Click
        If (ListView1.SelectedItems.Contains(ListView1.FocusedItem)) Then
            Dim item = ListView1.FocusedItem
            Dim line = item.Text & " " & item.SubItems(0).Text & " " & item.SubItems(1).Text & " " & item.SubItems(2).Text & " " & item.SubItems(3).Text & " " & item.SubItems(4).Text
            Clipboard.SetText(line)
        End If
    End Sub
End Class
