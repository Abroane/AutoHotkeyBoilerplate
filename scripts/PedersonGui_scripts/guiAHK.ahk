else if Pedersen = ahk.rel ; Reload this script
{
    gui_destroy() ; removes the GUI even when the reload fails
    Reload
}