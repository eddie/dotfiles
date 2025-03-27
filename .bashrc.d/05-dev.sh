

function p {
    if [ -f "poetry.lock" ]; then
        pytest
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
