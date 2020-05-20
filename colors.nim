import strutils

const
  RED = "\x1b[31m"
  MAGENTA = "\x1b[35m"
  BLUE = "\x1b[34m"
  RESET = "\x1b[39m"
  BLUE_N = RED & "[" & BLUE & "n" & RED & "]" & RESET

func letter(letter: string): string =
  #[
  [] are red and a is magenta
  >>> _letter("a")
  ... [a]
  ]#
  return RED & "["& MAGENTA & letter & RED & "]" & RESET

func letter_with_coords(letter: string): string =
  #[
  letter is magenta, n is blue, [] is red
  >>> _letter_with_coords("i")
  ... [i][n]
  ]#
  return letter(letter) & BLUE_N

func two_letter_with_coords(letter: string): string =
  #[
  [] and {} is red, | is black, o and O is magenta, y and x is blue, n is blue
  >>> _two_letter_with_coords("o")
  ... [o{y}{x}|O[n]]
  ]#
  return (RED & "[" & MAGENTA & letter.toLowerAscii & RED & "{" & BLUE & "y" &
          RED & "}" & RED & "{" & BLUE & "x" & RED & "}" & RESET & "|" &
          MAGENTA & letter.toUpperAscii & BLUE_N & RED & "]")

