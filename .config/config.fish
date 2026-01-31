if status is-interactive
    # Commands to run in interactive sessions can go here
end

# setup tere
function tere
    set --local result (command tere $argv)
    [ -n "$result" ] && cd -- "$result" && pwd
end

curl -fsSL https://claude.ai/install.sh | bash
