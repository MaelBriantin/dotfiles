function offline --description 'Checks LPV with online connection (DC_RUN without deps or pull)'
    set -l dc "docker compose run --rm --no-deps --pull never"

    switch "$argv[1]"
        case enable ''
            set -gx DC_RUN $dc
            echo "offline: ENABLED"
        case disable
            set -e DC_RUN
            echo "offline: DISABLED"
        case '*'
            env DC_RUN=$dc $argv
    end
end