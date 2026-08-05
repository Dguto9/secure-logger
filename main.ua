~ "crypt.ua" ~ Encrypt GenKey

Editor   ← &var"EDITOR"
Tempfile ← ".logdata/log"
Verifile ← ".logdata/verify"

Date ← (/$"_-_"°⋕↙₃datetime now)

&fmd "logs"
&fmd ".logdata"

AskPwd ← (
  &pf"Password: "
  ◌&runi{"stty" "-echo" "-isig"}
  &sc
  ◌&runi{"stty" "echo" "isig"}
  &p""
)

VerifyPwd ← (
  &frab".logdata/verify"
  ˜⌝Encrypt
  ≍"Verify"
  ⍤"Incorrect password"
)

Key‼          ← ⍡(^0&p"Password verified"⊸⍩VerifyPwd|^1&p"Incorrect password") GenKey AskPwd
ShowInEditor! ← &fde Tempfile ⍥(^)¬ &runi {Editor Tempfile} &fwa Tempfile
ShowInEditor  ← ShowInEditor!()

InitPwd ← (
  GenKey AskPwd
  Encrypt⊙"Verify"
  &fwa Verifile
  Key‼(◌|&fdeVerifile)
)

# ? Date
MakeLog ← (
  &runi {Editor Tempfile}
  ⨬(&frasTempfile&p"Log creation successful"
    &fde Tempfile Key‼(˜(&fwa) Encrypt|&p⋅$"Entry:\n_")
  | &p"Log creation failed")
)

# ? Date
EditLog ← (
  ⍜&frab(
    Key‼(
      ⤚⌝Encrypt
      ShowInEditor!(˜Encrypt&frasTempfile)
    | )
  )
)

ViewLogs ← (
  ⍆⊙¤⊸&fld "logs"
  Key‼(ShowInEditor/◇$"_\n_"⍚⌞(˜$"_:\n\n_"⊙(˜↘⊙(+₁⧻))⌝Encrypt⊙⊸&frab)|)
)

&fe Verifile
⨬(InitPwd
| ⍡(ViewLogs⍩⍤""◇≍"v"⍩⊡1&args|⨬(MakeLog|EditLog)⊸&fe $"logs/_"Date)
)
