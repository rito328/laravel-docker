#!/usr/bin/env bash

# create unitTest db
echo "CREATE DATABASE IF NOT EXISTS \`test_laravel_db\` ;" | "${mysql[@]}"