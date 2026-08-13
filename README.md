# Secure logger
My program for storing and syncing encrypted log entries.

## Encryption method
Log entries are encrypted with the XTEA encryption algorithm. Each one stores a nonce (number used once) at the top of the file that is combined with the key to prevent files with similar contents to be encrypted similarly. Furthermore, each block of file data's encryption key is modified by the block's index.

## Syncing method
Log entries are synced between computers through Git. Merge conflicts that cannot be automatically resolved are shown in the user's editor for manual resolution.