# Devlog

## Todo

- [ ] Fix Micro text editor system clipboard integration
  - it's actually impossible to copy text out of Micro at all, you need a
    workaround like `cat {filename}`
- [ ] Setup Brewfile
- [ ] Convert fish functions to shell scripts
- [ ] Add "development servers" section to readme
- [x] fix unicode symbols not working in tmux
  - [ ] Document
- [ ] Test Remote SSH extension VS dev containers
- [x] Set up VSCode DevContainers extension
  - [ ] Add to readme
- [x] Fix Homebrew install (not consistently working)
  - Seems like Homebrew doesn't like being run as root user. Need to create a
    'brew' user and install Homebrew with that.
- [x] Figure out why `cd` by itself sends you to an empty dir from which there
      is no return
- [x] Test SSH agent forwarding
  - Not pursuing this at the moment. See **SSH** in **20260123**.
- [x] Allocate more memory to VM and container

---

## 20260202

When I compose exec into my 'work' profile (below) in macOS Terminal, why is it installing Claude code every time? 😭

```
august@m2 airlock % docker compose exec work fish
Setting up Claude Code...
                                                                                                                                                                                                                    
✔ Claude Code successfully installed!                                                                                                                                                                               
                                                                                                                                                                                                                    
  Version: 2.1.29                                                                                                                                                                                                   
                                                                                                                                                                                                                    
  Location: ~/.local/bin/claude                                                                                                                                                                                     
                                                                                                                                                                                                                    
                                                                                                                                                                                                                    
  Next: Run claude --help to get started                                                                                                                                                                            
                                                                                                                                                                                                                    
⚠ Setup notes:                                                                                                                                                                                                      
  • Native installation exists but ~/.local/bin is not in your PATH. Run:                                                                                                                                           
                                                                                                                                                                                                                    
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> your shell config file && source your shell config file                                                                                                            
                                                                                                                                                                                                                    

✅ Installation complete!

Welcome to fish, the friendly interactive shell
Type help for instructions on how to use fish
```

## 20260123

Lots of updates from the last month or so!

### Dockerfile

**User management:** I now create a `dev` user without root privileges,
and switch to that user after setup.
I did this because Homebrew refuses to run as root.

### SSH

I've landed on a solution that I'm happy with for SSH. 
I keep a dedicated keypair on my host, 
then copy it in to `~/.ssh/` (in my case, `/airlock/.ssh/`.)

I **do not** add the SSH key to ssh-agent. 
The passphrase lives only in my brain (and my host machine password manager).
Some might find this inconvenient, 
but I prefer to categorically prevent agents like Claude
from being able to perform destructive git actions on my behalf.
Diffs are fine - pulls and pushes I do myself.
ssh-agent is trivial to set up if you want to make a different convenience-security compromise.

#### Why not forward the SSH agent? 
Colima provisions the SSH agent socket dynamically which makes it a pain to forward. 
It's a lot easier to copy in keys and simply not add the passphrase.
I don't run claude as root, so it doesn't have read permissions on the keys.
Even if it did, my passphrase is not stored anywhere in the container.

You have to change the ownership of the keys to the `dev` user.
Do this as root from the host with:

```
docker compose exec -u root me fish		# new terminal 
chown -hR dev:dev .ssh/								
```

### Homebrew

With users figured out, Homebrew can now install itself. :)

### Docker Compose

I developed a really nice compose.yaml, with two profiles: `me` and `work`. 
Each forwards the port range 3000:3015 to unique host ranges,
so they can be run in parallel (resources allowing!).

The core commands, for me, are:

```
docker compose build
docker compose --profile me up -d
docker compose exec me fish
```

## 20251205

Working on a better system for SSH.

1. Create dedicated keypair for container

1. Start ssh-agent:

   - Fish: `eval (ssh-agent -c)`
   - Bash: `eval "$(ssh-agent -s)"`

1. Add the key to the agent, and verify it's available to the host:

   `ssh-add ~/.ssh/keyname` `ssh-add -l`

1. Start docker container with mounted socket

This is where things got tricky.

First, you need to run colima with `--ssh-agent` to enable agent forwarding.

Next, create the container. These two commands worked for me:

```
# Create a new environment variable with colima's current ssh socket
set COLIMA_SSH_AUTH_SOCK $(colima ssh eval 'echo $SSH_AUTH_SOCK')
```

```
# Pass that environment variable into the container at start
docker run -it -m 8g -p 3000:3000 -v $COLIMA_SSH_AUTH_SOCK:$COLIMA_SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$COLIMA_SSH_AUTH_SOCK --name <container> airlock
# Yes this command is huge
```

Referenced these resources:

- https://github.com/abiosoft/colima/issues/127#issuecomment-1014474574
- https://github.com/gustavoguarda/ssh-agent-forward-colima/blob/main/docker-compose.yml

1. Inside the container, test that the ssh-agent is being forwarded:

`ssh-add -l`

Then test authentication with Github:

`ssh -T git@github.com`.

Success!

## 17-11-2025

Turns out
[this StackExchange thread](https://askubuntu.com/questions/410048/utf-8-character-not-showing-properly-in-tmux)
(remember StackExchange?) had the answer to the tmux Unicode issue. Run tmux
with the `-u` flag to force it to display Unicode symbols. There's probably a
way to fix this with environment variables, but I've been down that road before
without success. For now, I'm just aliasing `tmux` to `tmux -u`.

## 13-11-2025

Created the `al` fish function to quickly add new terminals:

```fish
function al
    if test (count $argv) -eq 0
        echo "Usage: al <container-name>"
        return 1
    end
    docker exec -it $argv /home/linuxbrew/.linuxbrew/bin/fish
end
```

## 4-11-2025

Troubleshooting the unicode symbols issue.

|              | Normal environment | Within Docker     |
| ------------ | ------------------ | ----------------- |
| Normal shell | Correct symbols    | Correct           |
| Within tmux  | Correct            | Incorrect symbols |

## 31-10-2025 🎃

Ran `locale` and found that everything was set to basic POSIX, which maybe
explains the lack of Unicode symbol support.

Adding this to Dockerfile: `ENV LANG=C.UTF-8 LC_ALL=C.UTF-8`

## 30-10-2025

Localhost isn't forwarded automatically, so my Docusaurus dev server at
`http://localhost:3000` was inaccessible outside the container. This is a
feature of Docker's network isolation.

Fixed by adding `--host 0.0.0.0` to my `yarn start` command.

The image build was failing at step 5/7 with this message:

```
/bin/bash: brew: No such file or directory
The command '/bin/sh -c /bin/bash brew install lazygit' returned a non-zero code: 127
```

Looks like the image builds in an 'intermediate container' until it succeeds, at
which point it is tagged with the provided name.

## 29-10-2025

Homebrew warns the following on startup:

```
Warning: Your CPU architecture (arm64) is not supported. We only support
x86_64 CPU architectures. You will be unable to use binary packages (bottles).

This is a Tier 2 configuration:
  https://docs.brew.sh/Support-Tiers#tier-2
You can report Tier 2 unrelated issues to Homebrew/* repositories!
Read the above document before opening any issues or PRs.
```

I get this output when running the container today:

```
/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: No such file or directory
```
