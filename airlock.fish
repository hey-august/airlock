function airlock
    if test (count $argv) -eq 0
        echo "Usage: airlock <container-name>"
        return 1
    end
    docker start -ai $argv
end
