else if Pedersen = processKiller ; Click a window to close or Ctrl-click to kill it
{
    gui_destroy() ; removes the GUI even when the reload fails
    gosub, subroutine_processKiller
    Return
}