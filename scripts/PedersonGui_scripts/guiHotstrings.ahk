else if Pedersen = @ ; Email address
{
    gui_destroy()
    Send, my_email_address@gmail.com
}
else if Pedersen = name ; My name
{
    gui_destroy()
    Send, My Full Name
}
else if Pedersen = phone ; My phone number
{
    gui_destroy()
    SendRaw, +45-12345678
}
else if Pedersen = int ; LaTeX integral
{
    gui_destroy()
    SendRaw, \int_0^1  \; \mathrm{d}x\,
}
else if Pedersen = logo ; ¯\_(ツ)_/¯
{
    gui_destroy()
    Send ¯\_(ツ)_/¯
}
else if Pedersen = clip ; Paste clipboard content without formatting
{
    gui_destroy()
    SendRaw, %ClipBoard%
}