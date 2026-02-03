if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Add Claude install to path
export PATH="$HOME/.local/bin:$PATH"

alias monet="claude --dangerously-skip-permissions"

# Setup tere explorer
function tere
    set --local result (command tere $argv)
    [ -n "$result" ] && cd -- "$result"
end

# there are many mkcd functions, but this one is mine
function mkcd
  mkdir $argv && cd $argv
end
