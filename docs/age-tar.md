# Archive and encrypt keys

## Create tarball

`tar -cf keys.tar .ssh`

## Encrypt

`age -p -o keys.age keys.tar`

## Decrypt

Pass decrypt and output flags, output file, and input file

`age -d -o keys.tar keys.age`

## Untar

`tar -xvf keys.tar -`
