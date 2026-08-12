# Experimental!
Rrₙ   ← ⍜⊙⋯₃₂⧋⬚0↻^n
Rlₙ   ← ⍜⊙⋯₃₂⧋⬚0↻¯^n
Xor   ← ⍜∩⋯₃₂≠
Add   ← ◿4294967296+∩(◿4294967296)
Sub   ← ◿4294967296-∩(◿4294967296)
Magic ← ⋕₁₆"9E3779B9"

# Data ? Data Sum Key
Inner₀ ← Xor⊓(Add Xor⊸⊃Rl₄Rr₅|Add⟜(⊡◿₄Rr₁₁))
# Data ? Data Sum Key
Inner₁ ← Xor⊓(Add Xor⊸⊃Rl₄Rr₅|Add⟜(⊡◿₄))

# Data Sum ? Data Sum Key
EnShuffle ← ⇌⊟Add˜⌞⊙⤚₂Inner₀⊙⊙(Add Magic)Add⊸₃⊙Inner₁°⊟
# Data Sum ? Data Sum Key
DeShuffle ← ⊟˜Sub˜⌞⊙⤚₂Inner₁⊙⊙(Sub Magic)˜Sub⊸₃⊙Inner₀°⊟⇌

# Enciphered ? Data Key
Encipherₙ ← (
  ⊙⋅◌⍥ₙ(⊸EnShuffle)⊙0
)
# Deciphered ? Data Key
Decipherₙ ← (
  ⊙⋅◌⍥ₙ(⊸DeShuffle)⊙(⍥ₙ(Add Magic)0)
)

Counter ← ⬚0↯¤4⊥4294967296

# Encrypted ? Key Text
Encrypt ← ⌅(
  ˜(
    °⊥₂₅₆⬚0↯∞_2_4utf₈
    ♭≡⌟(Encipher₃₂⊙(Xor Counter))⟜(⇡⧻)
    ♭⊥₂₅₆
  )
| ˜(
    ↯∞_2°⊥₂₅₆↯∞_4
    ≡⌟(Decipher₃₂⊙(Xor Counter))⟜(⇡⧻)
    ◌°⬚@\0↙°utf₈♭⊥₂₅₆
  ))

GenKey ← °⊥₂₅₆⌊×₂₅₆gen4_4
