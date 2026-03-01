#!/bin/bash

# gcloud-profile-manager.sh
# A script to easily manage gcloud configuration profiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[HEADER]${NC} $1"
}

# Check if gcloud is installed
check_gcloud() {
    if ! command -v gcloud &> /dev/null; then
        print_error "gcloud CLI is not installed. Please install it first."
        echo "Visit: https://cloud.google.com/sdk/docs/install"
        exit 1
    fi
    print_status "gcloud CLI found"
}

# Display current configurations
show_configs() {
    print_header "Current gcloud configurations:"
    gcloud config configurations list
    echo
}

# Create a new configuration profile
create_profile() {
    print_header "Creating a new gcloud configuration profile"

    read -p "Enter profile name: " profile_name

    if [[ -z "$profile_name" ]]; then
        print_error "Profile name cannot be empty"
        return 1
    fi

    # Check if profile already exists
    if gcloud config configurations describe "$profile_name" &>/dev/null; then
        print_warning "Profile '$profile_name' already exists"
        read -p "Do you want to overwrite it? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            print_status "Aborted"
            return 0
        fi
    fi

    # Create the configuration
    print_status "Creating configuration '$profile_name'..."
    gcloud config configurations create "$profile_name" --no-activate

    # Configure the profile
    configure_profile "$profile_name"
}

# Configure an existing profile
configure_profile() {
    local profile_name="$1"

    if [[ -z "$profile_name" ]]; then
        show_configs
        read -p "Enter profile name to configure: " profile_name
    fi

    if [[ -z "$profile_name" ]]; then
        print_error "Profile name cannot be empty"
        return 1
    fi

    # Check if profile exists
    if ! gcloud config configurations describe "$profile_name" &>/dev/null; then
        print_error "Profile '$profile_name' does not exist"
        return 1
    fi

    print_header "Configuring profile: $profile_name"

    # Activate the configuration temporarily for setup
    gcloud config configurations activate "$profile_name"

    # Account setup
    read -p "Enter Google Cloud account email (or press Enter to skip): " account_email
    if [[ -n "$account_email" ]]; then
        print_status "Setting account to: $account_email"
        gcloud config set account "$account_email"

        # Check if we need to authenticate
        if ! gcloud auth list --filter="account:$account_email" --format="value(account)" | grep -q "$account_email"; then
            print_status "Account not authenticated. Starting authentication flow..."
            gcloud auth login "$account_email"
        fi
    fi

    # Project setup
    read -p "Enter Google Cloud Project ID (or press Enter to skip): " project_id
    if [[ -n "$project_id" ]]; then
        print_status "Setting project to: $project_id"
        gcloud config set project "$project_id"
    fi

    # Default region
    read -p "Enter default compute region (e.g., us-central1, or press Enter to skip): " region
    if [[ -n "$region" ]]; then
        print_status "Setting compute region to: $region"
        gcloud config set compute/region "$region"
    fi

    # Default zone
    read -p "Enter default compute zone (e.g., us-central1-a, or press Enter to skip): " zone
    if [[ -n "$zone" ]]; then
        print_status "Setting compute zone to: $zone"
        gcloud config set compute/zone "$zone"
    fi

    print_status "Profile '$profile_name' configured successfully!"

    # Show the configuration
    echo
    print_header "Configuration summary for '$profile_name':"
    gcloud config list
}

# Switch to a profile
switch_profile() {
    show_configs
    read -p "Enter profile name to activate: " profile_name

    if [[ -z "$profile_name" ]]; then
        print_error "Profile name cannot be empty"
        return 1
    fi

    if gcloud config configurations describe "$profile_name" &>/dev/null; then
        gcloud config configurations activate "$profile_name"
        print_status "Switched to profile: $profile_name"
        echo
        print_header "Current active configuration:"
        gcloud config list
    else
        print_error "Profile '$profile_name' does not exist"
        return 1
    fi
}

# Delete a profile
delete_profile() {
    show_configs
    read -p "Enter profile name to delete: " profile_name

    if [[ -z "$profile_name" ]]; then
        print_error "Profile name cannot be empty"
        return 1
    fi

    if [[ "$profile_name" == "default" ]]; then
        print_error "Cannot delete the default profile"
        return 1
    fi

    if gcloud config configurations describe "$profile_name" &>/dev/null; then
        print_warning "This will permanently delete the profile '$profile_name'"
        read -p "Are you sure? (y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            gcloud config configurations delete "$profile_name" --quiet
            print_status "Profile '$profile_name' deleted successfully"
        else
            print_status "Aborted"
        fi
    else
        print_error "Profile '$profile_name' does not exist"
        return 1
    fi
}

# Quick setup with prompts
quick_setup() {
    print_header "Quick Profile Setup"
    echo "This will create a new profile with common settings"
    echo

    read -p "Profile name: " profile_name
    read -p "Google Cloud account email: " account_email
    read -p "Project ID: " project_id
    read -p "Default region (e.g., us-central1): " region
    read -p "Default zone (e.g., us-central1-a): " zone

    if [[ -z "$profile_name" || -z "$account_email" || -z "$project_id" ]]; then
        print_error "Profile name, account email, and project ID are required"
        return 1
    fi

    print_status "Creating and configuring profile '$profile_name'..."

    # Create configuration
    gcloud config configurations create "$profile_name" --no-activate
    gcloud config configurations activate "$profile_name"

    # Set properties
    gcloud config set account "$account_email"
    gcloud config set project "$project_id"

    if [[ -n "$region" ]]; then
        gcloud config set compute/region "$region"
    fi

    if [[ -n "$zone" ]]; then
        gcloud config set compute/zone "$zone"
    fi

    # Authenticate if needed
    if ! gcloud auth list --filter="account:$account_email" --format="value(account)" | grep -q "$account_email"; then
        print_status "Starting authentication flow..."
        gcloud auth login "$account_email"
    fi

    print_status "Profile '$profile_name' created and configured successfully!"
    echo
    print_header "Configuration summary:"
    gcloud config list
}

# Export profile configuration
export_profile() {
    show_configs
    read -p "Enter profile name to export: " profile_name

    if [[ -z "$profile_name" ]]; then
        print_error "Profile name cannot be empty"
        return 1
    fi

    if ! gcloud config configurations describe "$profile_name" &>/dev/null; then
        print_error "Profile '$profile_name' does not exist"
        return 1
    fi

    local export_file="${profile_name}_gcloud_config.txt"

    # Temporarily activate the profile to get its config
    local current_profile=$(gcloud config configurations list --filter="IS_ACTIVE=True" --format="value(name)")
    gcloud config configurations activate "$profile_name"

    {
        echo "# gcloud configuration export for profile: $profile_name"
        echo "# Generated on: $(date)"
        echo "# Use this with: gcloud config configurations create <name> && gcloud config configurations activate <name>"
        echo
        gcloud config list --format="text"
    } > "$export_file"

    # Switch back to original profile
    if [[ -n "$current_profile" ]]; then
        gcloud config configurations activate "$current_profile"
    fi

    print_status "Profile '$profile_name' exported to: $export_file"
}

# Show menu
show_menu() {
    echo
    print_header "=== gcloud Configuration Profile Manager ==="
    echo "1. Show current configurations"
    echo "2. Create new profile"
    echo "3. Configure existing profile"
    echo "4. Switch to profile"
    echo "5. Delete profile"
    echo "6. Quick setup (create + configure)"
    echo "7. Export profile configuration"
    echo "8. Exit"
    echo
}

# Main function
main() {
    check_gcloud

    if [[ $# -eq 0 ]]; then
        # Interactive mode
        while true; do
            show_menu
            read -p "Choose an option (1-8): " choice

            case $choice in
                1)
                    show_configs
                    ;;
                2)
                    create_profile
                    ;;
                3)
                    configure_profile
                    ;;
                4)
                    switch_profile
                    ;;
                5)
                    delete_profile
                    ;;
                6)
                    quick_setup
                    ;;
                7)
                    export_profile
                    ;;
                8)
                    print_status "Goodbye!"
                    exit 0
                    ;;
                *)
                    print_error "Invalid option. Please choose 1-8."
                    ;;
            esac

            echo
            read -p "Press Enter to continue..."
        done
    else
        # Command line mode
        case "$1" in
            "list"|"show")
                show_configs
                ;;
            "create")
                if [[ -n "$2" ]]; then
                    profile_name="$2"
                    gcloud config configurations create "$profile_name" --no-activate
                    configure_profile "$profile_name"
                else
                    create_profile
                fi
                ;;
            "switch"|"activate")
                if [[ -n "$2" ]]; then
                    gcloud config configurations activate "$2"
                    print_status "Switched to profile: $2"
                else
                    switch_profile
                fi
                ;;
            "delete")
                if [[ -n "$2" ]]; then
                    profile_name="$2"
                    if [[ "$profile_name" != "default" ]]; then
                        gcloud config configurations delete "$profile_name" --quiet
                        print_status "Profile '$profile_name' deleted"
                    else
                        print_error "Cannot delete default profile"
                    fi
                else
                    delete_profile
                fi
                ;;
            "help"|"-h"|"--help")
                echo "Usage: $0 [command] [profile_name]"
                echo "Commands:"
                echo "  list, show          - Show all configurations"
                echo "  create [name]       - Create new profile"
                echo "  switch [name]       - Switch to profile"
                echo "  delete [name]       - Delete profile"
                echo "  help                - Show this help"
                echo
                echo "Run without arguments for interactive mode"
                ;;
            *)
                print_error "Unknown command: $1"
                echo "Use '$0 help' for usage information"
                exit 1
                ;;
        esac
    fi
}

# Run the script
main "$@"
#alias gcp-profile='/path/to/gcloud-profile-manager.sh'
