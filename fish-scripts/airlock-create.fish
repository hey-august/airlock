function airlock-create
    if test (count $argv) -eq 0
        echo "Usage: airlock-create <image> <container>"
        return 1
    end
    docker run -it -m 8g -p 3000:3000 -v $SSH_AUTH_SOCK:/tmp/ssh-auth.sock -e SSH_AUTH_SOCK=/tmp/ssh-auth.sock  --name $argv1 $argv0
end
