# Provisioning a new container

This is a WIP doc describing the setup process I currently perform manually for new containers.

These instructions have only been tested on macOS with a Debian container. 

## Authentication

Git is the core mechanism for pulling work into,
and pushing work out of, airlock containers.
For various reasons I find that SSH keys are the easiest way to handle auth:
they are universally accepted by code forges and have first class tooling support.

1. Create dedicated keypair

Generate a new SSHs key exclusively for your container(s).
This makes it easy to rotate keys later.

```
todo - commands
ssh-keygen make me a key
```

1. Add the public key to your code forge

For GitHub, open the
[SSH and GPG keys](https://github.com/settings/ssh/new)
settings page and add the public key.
Refer to their
[Add a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
doc for more detailed instructions. 

1. Copy private key to container

I recommend creating the key on your host machine and copying it into the container.
You only need to copy in the private key.

```
```
```
todo - commands
generate key
docker cp ~/.ssh/your_dedicated_key container:/.ssh/id_ed25519
```

1. Configure key ownership and permissions

You'll then need to change ownership of the key so that your user can use it.
This is because `docker cp` works as root, 
but our user within the container *can't* be root because it breaks Homebrew. 

```
# enter container as root
docker-compose exec -u root me fish

# change ownership to dev user and group
chown -hR dev:dev .ssh/
```

You shouldn't need to change file permissions with `chmod`;
`ssh-keygen` should have set them up correctly on the host.
You can verify with `ls -l ~/.ssh/id_ed25519`.
You should see output that looks like this:

```

-rw-------  1   dev   dev   444         May 8 03:26   /airlock/.ssh/id_ed25519
└─perms─┘   │  └─┬─┘ └─┬─┘ └─┬─┘        └────┬─────┘  └────────┬────────────┘
        link   owner group  size        time modified        path
        count
```

The important part is `-rw-------`, which in
[symbolic notation](https://en.wikipedia.org/wiki/File-system_permissions#Symbolic_notation)
indicates that only the file owner (in this case, `dev`)
can read or write to the file.

4. Test


