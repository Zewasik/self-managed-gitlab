#!/bin/bash

show_help() {
    echo "Usage: $0 [init|create]"
    echo "  init    Initialize Ansible vault variables"
    echo "  create  Start playbooks with defined order"
}

is_empty_string() {
    if [ -z "$1" ]; then
        printf "\ninput shoudn't be empty\n"
        exit 1
    fi
}

printf_bold() {
    printf "\033[1m$1\033[0m"
}

initialize_vault() {
    printf_bold "Initializing Ansible vault variables...\n\n"
    
    printf_bold "Add user data\n"
    read -p "Enter password for default gitlab user(project_admin): " -s password
    password=$(echo "$password" | xargs) && is_empty_string $password

    printf_bold "\n\nSpecify Docker hub credentials\n"
    read -p "Enter your docker username: " docker_user
    docker_user=$(echo "$docker_user" | xargs) && is_empty_string $docker_user
    read -p "Enter your docker password: " -s docker_password
    docker_password=$(echo "$docker_password" | xargs) && is_empty_string $docker_password

    printf_bold "\n\nSpecify Snyk credentials\n"
    read -p "Enter your Snyk token: " -s snyk_token
    snyk_token=$(echo "$snyk_token" | xargs) && is_empty_string $snyk_token

    printf_bold "\n\nSpecify AWS credentials (Access key id and Secret access key)\n"
    read -p "Enter your AWS Access key id: " aws_access_key_id
    aws_access_key_id=$(echo "$aws_access_key_id" | xargs) && is_empty_string $aws_access_key_id
    read -p "Enter your AWS Secret access key: " -s aws_secret_access_key
    aws_secret_access_key=$(echo "$aws_secret_access_key" | xargs) && is_empty_string $aws_secret_access_key

    mkdir -p group_vars/git_group/vaults
    
    printf_bold "\n\nVault file was created: group_vars/git_group/vaults/project-variables.yml\n"
    echo "api_enviroment:" > group_vars/git_group/vaults/project-variables.yml
    echo "  DOCKER_USER: \"$docker_user\"" >> group_vars/git_group/vaults/project-variables.yml
    echo "  DOCKER_PASS: \"$docker_password\"" >> group_vars/git_group/vaults/project-variables.yml
    echo "  SNYK_TOKEN: \"$snyk_token\"" >> group_vars/git_group/vaults/project-variables.yml
    echo "amazon_access:" >> group_vars/git_group/vaults/project-variables.yml
    echo "  AWS_ACCESS_KEY_ID: \"$aws_access_key_id\"" >> group_vars/git_group/vaults/project-variables.yml
    echo "  AWS_SECRET_ACCESS_KEY: \"$aws_secret_access_key\"" >> group_vars/git_group/vaults/project-variables.yml
    while : ; do
        ansible-vault encrypt group_vars/git_group/vaults/project-variables.yml
        [[ $? -ne 0 ]] || break
    done

    printf_bold "\nVault file was created: group_vars/git_group/vaults/user-password.yml\n"
    echo "password: \"$password\"" > group_vars/git_group/vaults/user-password.yml
    while : ; do
        ansible-vault encrypt group_vars/git_group/vaults/user-password.yml
        [[ $? -ne 0 ]] || break
    done
}

start_playbooks() {
    printf_bold "Starting playbooks with defined order...\n"
    # Add your logic here to execute the Ansible playbooks
}

main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi

    case $1 in
        init)
            initialize_vault
            ;;
        create)
            start_playbooks
            ;;
        *)
            echo "Invalid argument: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"