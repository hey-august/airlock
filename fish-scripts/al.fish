function al
    if test (count $argv) -eq 0
        echo "Usage: al <container-name>"
        return 1
    end
    docker exec -it $argv /bin/bash
end
