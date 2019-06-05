st_glue(array, pref="", delim="`n")
{
   for k,v in array
      new.=pref v delim
   return trim(new, delim)
}

st_printArr(array, depth=5, indentLevel="")
{
   for k,v in Array
   {
      list.= indentLevel "[" k "]"
      if (IsObject(v) && depth>1)
         list.="`n" st_printArr(v, depth-1, indentLevel . "    ")
      Else
         list.=" => " v
      list.="`n"
   }
   return rtrim(list, "`r`n `t")
}