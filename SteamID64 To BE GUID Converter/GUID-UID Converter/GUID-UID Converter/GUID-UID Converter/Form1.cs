using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GUID_UID_Converter
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            if (textBox1.Text.Length == 17)
            {
                textBox2.Text = toGUID(Convert.ToInt64(textBox1.Text));
            }
        }
        private string toGUID(long UID)
        {
            MD5 md5 = System.Security.Cryptography.MD5.Create();
            List<byte> bytes = new List<byte>();
            long i = 0;
            
            byte[] starter = System.Text.Encoding.ASCII.GetBytes("BE");
            for(i = 0;i<starter.Length;i++)
                bytes.Add(starter[i]);

            for (i = 0; i < 8; i++)
            {
                bytes.Add((byte)(UID & 0xFF));
                UID >>= 8;
            }
            byte[] inputBytes = bytes.ToArray();
            byte[] hash = md5.ComputeHash(inputBytes);
            StringBuilder sb = new StringBuilder();
            for (i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }
            return sb.ToString();
        }
    }
}
