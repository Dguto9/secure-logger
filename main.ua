# Experimental!
~ "crypt.ua" ~ Encrypt GenKey Xor

Editor     ← &var"EDITOR"
TopDir     ← ◌°⬚@\n↙⋅⊙◌&runc {"realpath" ∘}&var"LOGDIR"
LogDir     ← ⊂TopDir"/logs"
TempDir    ← ⊂TopDir"/.data"
Tempfile   ← ⊂TempDir"/log"
Verifile   ← ⊂TempDir"/verify"
Statusfile ← ⊂TempDir"/status"

PathToLog ← $"_/_" LogDir

┌─╴Git
  AtDir!       ← ^⍜⊙⊢(˜⊂□₂"-C")
  AtTop!       ← AtDir!^TopDir
  RunFallible‼ ← ⍤$"_: _"^0⊓/◇$"_ _"=₀⟜^1
  Init         ← RunFallible‼"Repo init failed"AtTop!&runi {"git" "init"} &p"=====RUNNING GIT INIT====="
  AddRemote    ← RunFallible‼"Remote does not exist"AtTop!&runi {"git" "ls-remote" "origin"}◌AtTop!&runi {"git" "remote" "add" "origin" ∘} &p"=====RUNNING GIT REMOTE====="
  Add          ← ◌AtTop!&runi {"git" "add" ∘} &p"=====RUNNING GIT ADD====="
  Commit       ← RunFallible‼"Commit failed"AtTop!&runi {"git" "commit" $"-m\"_\""} &p"=====RUNNING GIT COMMIT====="
  Merge        ← RunFallible‼"Could not automerge"AtTop!&runi {"git" "merge" "origin/main"} &p"=====RUNNING GIT MERGE====="
  GetUnmerged  ← (⊜□⊸≠@\n⋅⊙◌AtTop!&runc{"git" "--no-pager" "diff" "--name-only" "--diff-filter=U"} &p"=====GETTING UNMERGED=====")
  ShowUnmerged ← map{"Local" "Remote"}□₂∩⌟(⊓(&cl|&cl⤙&rb∞|&cl)AtTop!&runs{"git" "--no-pager" "show" $":_:_"}) 2 3 &p"=====SHOWING UNMERGED====="
  Fetch        ← RunFallible‼"Could not acquire remote changes"AtTop!&runi {"git" "fetch"} &p"=====RUNNING GIT FETCH====="
  Push         ← RunFallible‼"Could not push"AtTop!&runi {"git" "push" "origin" "main"} &p"=====RUNNING GIT PUSH====="
  Reachable    ← (=₀AtTop!&runi {"git" "ls-remote" "origin"} &p"=====CHECKING REMOTE REACHABILITY=====")
  Initialize ← (
    Init
    ◌AtTop!&runi {"git" "config" "user.name" "secure_logger"}
    ◌AtTop!&runi {"git" "config" "user.email" "secure_logger@fake_email"}
    &p"" &sc &pf "Remote URL: "
    ⍡(⍩AddRemote|⍤⊙0◌&ftr ⊂TopDir"/.git")
  )
└─╴

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

VerifyPwdBool ← (
  &frabVerifile
  ⍣(˜⌝Encrypt|"")
  ≍"Verify"
  &p⊸⨬("Incorrect password, try again"|"Password verified")
)
VerifyPwdError ← (
  VerifyPwdBool
  ⍤"Incorrect password"
)

Key‼          ← ⍡(^0&p"Password verified"⊸⍩VerifyPwdError|^1&p"Incorrect password") GenKey AskPwd
Key           ← (⍢(GenKey AskPwd◌|¬VerifyPwdBool) GenKey AskPwd)
ShowInEditor! ← &ftr Tempfile ⍥(^)=₀ &runi {Editor Tempfile} &fwa Tempfile
ShowInEditor  ← ShowInEditor!()

EncryptWN ← ⊂⊙Encrypt♭⊥₂₅₆⟜Xor GenKey⚂
DecryptWN ← ⌝Encrypt Xor⊙(°⊥₂₅₆↯4_4⊃↙↘16)

Sync ← |0.0 (
  ⍣(Git.Merge Git.Fetch|&p"Could not automerge")
  ≠₀⊸⧻Git.GetUnmerged
  ⍥(Key⊸⍚(˜⊙∘°mapGit.ShowUnmerged)
    ⍚⌞(˜ShowInEditor!(Git.Add⊸˜&fwa ˜EncryptWN &frasTempfile)⊙/◇$"_\n\n_"⟜⍚⌞(˜$"_:\n\n_"DecryptWN))
    ⍣(Git.Commit"Merged files"|&p)
  )
  ⍣(⍥Git.Push Git.Reachable|Sync)
)

InitPwd ← (
  &p "Initializing Log"
  GenKey AskPwd
  Encrypt⊙"Verify"
  &fwa Verifile
  Key‼(◌|&fdeVerifile)
)

Init ← (
  Git.Initialize
  ⍣(Git.Merge Git.Fetch|∩&p"Failed to sync with remote")
  &fe Verifile
  ⍥(⍡(⍩InitPwd
      Git.Commit"Add .gitattributes" Git.Add".gitattributes" &fwa⊂TopDir"/.gitattributes" $"_\n_"∩$"/_/** binary""logs"".data"
      Git.Commit"Create password" Git.Add Verifile
      Git.Push
    | &ftr⊂TopDir"/.git")
  )¬
)

# ? Date
MakeLog ← (
  &runi {Editor Tempfile}
  ⨬(&frasTempfile&p"Log creation successful"
    &ftr Tempfile ˜&fwa EncryptWN Key
  | &p"Log creation failed")
)

# ? Date
EditLog ← (
  ⍜&frab(
    Key
    ⤚DecryptWN
    ShowInEditor!(˜EncryptWN&frasTempfile)
  )
)

ViewLogs ← (
  ⍆⊙¤⊸&fld LogDir
  ShowInEditor/◇$"_\n\n_"⍚⌞(˜$"_:\n\t_"⊙(˜↘⊙(+₁⧻))/$"_\n\t_"⊜□⊸≠@\nDecryptWN⊙⊸&frab) Key
)

&fe Verifile
⨬(Init|⍡(
    ViewLogs⍩⍤""◇≍"v"⍩⊡1&args
  | Sync Git.Commit$"Edit file: _" Git.Add⊸⨬(MakeLog|EditLog)⊸&fe ⊸PathToLog DateNPrev⍩⋕⍩◇⊡1&args
  | Sync Git.Commit$"Edit file: _" Git.Add⊸⨬(MakeLog|EditLog)⊸&fe ⊸PathToLog Date
  )Sync
)
