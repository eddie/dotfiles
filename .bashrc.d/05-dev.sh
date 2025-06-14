
# https://docs.anthropic.com/en/docs/claude-code/troubleshooting
# export PATH=~/.npm-global/bin:$PATH

function p {
    if [ -f "poetry.lock" ]; then
        pytest -n auto
    elif [ -f "composer.json" ]; then 
        php artisan test --parallel
    else 
        pytest
    fi
}

function pf {
    if [ -f "poetry.lock" ]; then
        pytest -k "$1"
    elif [ -f "composer.json" ]; then 
        php artisan test --filter="$1"
    else 
        pytest -k "$1"
    fi
}
