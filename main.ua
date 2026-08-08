~ "crypt.ua" ~ Encrypt GenKey Xor

Editor     ← &var"EDITOR"
TopDir     ← ◌°⬚@\n↙⋅⊙◌&runc {"realpath" ∘}&var"LOGDIR"
LogDir     ← ⊂TopDir"/logs"
TempDir    ← ⊂TopDir"/.data"
Tempfile   ← ⊂TempDir"/log"
Verifile   ← ⊂TempDir"/verify"
Statusfile ← ⊂TempDir"/status"

PathToLog ← $"_/_" LogDir

∩₃&fmd TopDir LogDir TempDir

Date      ← (/$"_-_"°⋕↙₃datetime now)
DateNPrev ← /$"_-_" °⋕↙₃datetime -now ×86400

AskPwd ← (
  &pf"Password: "
  ◌&runi{"stty" "-echo" "-isig"}
  &sc
  ◌&runi{"stty" "echo" "isig"}
  &p""
)

VerifyPwd ← (
  &frabVerifile
  ˜⌝Encrypt
  ≍"Verify"
  ⍤"Incorrect password"
)

Key‼          ← ⍡(^0&p"Password verified"⊸⍩VerifyPwd|^1&p"Incorrect password") GenKey AskPwd
ShowInEditor! ← &fde Tempfile ⍥(^)¬ &runi {Editor Tempfile} &fwa Tempfile
ShowInEditor  ← ShowInEditor!()

EncryptWN ← ⊂⊙Encrypt♭⊥₂₅₆⟜Xor GenKey⚂
DecryptWN ← ⌝Encrypt Xor⊙(°⊥₂₅₆↯4_4⊃↙↘16)

InitPwd ← (
  &p "Initializing Log"
  GenKey AskPwd
  Encrypt⊙"Verify"
  &fwa Verifile
  Key‼(◌|&fdeVerifile)
)

# ? Date
MakeLog ← (
  &runi {Editor Tempfile}
  ⨬(&frasTempfile&p"Log creation successful"
    &fde Tempfile Key‼(˜(&fwa) EncryptWN|&p⋅$"Entry:\n_")
  | &p"Log creation failed")
)

# ? Date
EditLog ← (
  ⍜&frab(
    Key‼(
      ⤚DecryptWN
      ShowInEditor!(˜EncryptWN&frasTempfile)
    | )
  )
)

ViewLogs ← (
  ⍆⊙¤⊸&fld LogDir
  Key‼(ShowInEditor/◇$"_\n_"⍚⌞(˜$"_:\n\n_"⊙(˜↘⊙(+₁⧻))DecryptWN⊙⊸&frab)|)
)

&fe Verifile
⨬(InitPwd|⍡(
    ViewLogs⍩⍤""◇≍"v"⍩⊡1&args
  | ⨬(MakeLog|EditLog)⊸&fe PathToLog DateNPrev⍩⋕⍩◇⊡1&args
  | ⨬(MakeLog|EditLog)⊸&fe PathToLog Date
  )
)
