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
  Initialize ← (
    Init
    ◌AtTop!&runi {"git" "config" "user.name" "log_bot"}
    ◌AtTop!&runi {"git" "config" "user.name" "log_bot@fakeemail"}
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

Sync ← |0.0 (
  ⍣(Git.Merge|&p"Could not automerge") Git.Fetch
  ⍥(⍡(Git.Push Sync Git.Commit"Merged files"|&p)Key‼(⍚⌞(ShowInEditor!(Git.Add)/◇$"_\n\n_"⍚($"_:\n\n_"DecryptWN))|)⊸⍚(°mapGit.ShowUnmerged)) ≠₀⊸⧻Git.GetUnmerged
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
  ⍥(Git.Push Git.Commit"Initial commit" Git.Add Verifile InitPwd)¬
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
⨬(Init|⍡(
    ViewLogs⍩⍤""◇≍"v"⍩⊡1&args
  | ⍣(Sync|&p)Git.Commit$"Edit file: _" Git.Add⊸⨬(MakeLog|EditLog)⊸&fe ⊸PathToLog DateNPrev⍩⋕⍩◇⊡1&args
  | ⍣(Sync|&p)Git.Commit$"Edit file: _" Git.Add⊸⨬(MakeLog|EditLog)⊸&fe ⊸PathToLog Date
  )⍣(Sync|&p)
)
