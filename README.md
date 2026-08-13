# Secure logger
My program for storing and syncing encrypted log entries.

## Encryption method
Log entries are encrypted with the XTEA encryption algorithm. Each one stores a nonce (number used once) at the top of the file that is combined with the key to prevent files with similar contents from being encrypted similarly. Furthermore, each block of data's encryption key is modified by the block's index (this is known as CTR mode).

## Syncing method
Log entries are synced between computers through Git. Merge conflicts that cannot be automatically resolved are shown in the user's editor for manual resolution.

## Setup
- Set up a git remote at some address; your files will be pushed and pulled from here on every edit.
- Clone this repo into wherever you want to store it.
- Set the environment variable `$LOGDIR` to choose where logs should be stored on-device.
- I use the following Zsh function to run it:
  ```sh
  lg() {
    (cd path_to_repo && uiua run main.ua -- "$@")
  }

  ```
- Run this `lg` function to initialize a local repo, connect it to the remote, sync, and set up a password if the remote does not already have one.

## Usage
Create and edit today's entry by running the command (`lg` if you set it up as before). View logs with `lg v`. Edit previous logs with `lg n` where n is the number of days back you wish to edit.

## More features
- Password verification to avoid encrypting entries with the wrong key
- Cleanup upon failure with initialization
- Edit logs in whatever editor you choose. Set with `$EDTIOR` environment variable
