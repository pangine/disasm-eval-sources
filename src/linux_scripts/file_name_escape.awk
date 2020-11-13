#!/usr/bin/awk -f

# Use url encoding to escape compiler arugments
# Referencing https://gist.github.com/moyashi/4063894

BEGIN {
  for (i = 0; i <= 255; i++) {
    ord[sprintf("%c", i)] = i
  }
}

{
  if (esc == "") esc = "%"
  len = length($0)
  rst = ""
  for (i = 1; i <= len; i++) {
    c = substr($0, i, 1)
    if (c ~ /[0-9A-Za-z]/)
      rst = rst c
    else
      rst = rst esc sprintf ("%02x", ord[c])
  }
  print rst
}
