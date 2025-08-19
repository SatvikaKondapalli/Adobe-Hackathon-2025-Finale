#!/bin/bash

# PDF Analyzer Docker Setup Script
# This script helps you set up and run the PDF Analyzer application with Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    print_status "Checking Docker installation..."
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Check if .env file exists
setup_env() {
    if [ ! -f .env ]; then
        print_status "Creating .env file from template..."
        if [ -f env.example ]; then
            cp env.example .env
            print_warning "Please edit .env file and add your API keys before running the application"
            print_status "Required: GEMINI_API_KEY"
            print_status "Optional: AZURE_SPEECH_KEY, AZURE_SPEECH_REGION"
        else
            print_error "env.example file not found"
            exit 1
        fi
    else
        print_success ".env file already exists"
    fi
}

# Build and start services
start_services() {
    local mode=${1:-production}
    
    print_status "Starting services in $mode mode..."
    
    if [ "$mode" = "development" ]; then
        docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
    else
        docker-compose up -d --build
    fi
    
    print_success "Services started successfully"
}

# Check service health
check_health() {
    print_status "Checking service health..."
    
    # Wait for services to start
    sleep 10
    
    # Check backend
    if curl -f http://localhost:5001/files > /dev/null 2>&1; then
        print_success "Backend is healthy"
    else
        print_warning "Backend health check failed"
    fi
    
    # Check frontend
    if curl -f http://localhost/health > /dev/null 2>&1; then
        print_success "Frontend is healthy"
    else
        print_warning "Frontend health check failed"
    fi
    
    # Check Redis
    if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
        print_success "Redis is healthy"
    else
        print_warning "Redis health check failed"
    fi
}

# Show service status
show_status() {
    print_status "Service status:"
    docker-compose ps
    
    echo ""
    print_status "Access URLs:"
    echo "  Frontend: http://localhost"
    echo "  Backend API: http://localhost:5001"
    echo "  Health Check: http://localhost/health"
}

# Stop services
stop_services() {
    print_status "Stopping services..."
    docker-compose down
    print_success "Services stopped"
}

# Clean up
cleanup() {
    print_status "Cleaning up Docker resources..."
    docker-compose down -v
    docker system prune -f
    print_success "Cleanup completed"
}

# Show logs
show_logs() {
    local service=${1:-""}
    if [ -n "$service" ]; then
        docker-compose logs -f "$service"
    else
        docker-compose logs -f
    fi
}

# Main menu
show_menu() {
    echo ""
    echo "PDF Analyzer Docker Setup"
    echo "========================"
    echo "1. Setup environment"
    echo "2. Start services (production)"
    echo "3. Start services (development)"
    echo "4. Stop services"
    echo "5. Show status"
    echo "6. Show logs"
    echo "7. Cleanup"
    echo "8. Exit"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1)
            setup_env
            ;;
        2)
            start_services production
            check_health
            show_status
            ;;
        3)
            start_services development
            check_health
            show_status
            ;;
        4)
            stop_services
            ;;
        5)
            show_status
            ;;
        6)
            echo "Enter service name (or press Enter for all): "
            read service
            show_logs "$service"
            ;;
        7)
            cleanup
            ;;
        8)
            print_success "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
}

# Handle command line arguments
case "${1:-}" in
    "setup")
        check_docker
        setup_env
        ;;
    "start")
        check_docker
        start_services production
        check_health
        show_status
        ;;
    "start-dev")
        check_docker
        start_services development
        check_health
        show_status
        ;;
    "stop")
        stop_services
        ;;
    "status")
        show_status
        ;;
    "logs")
        show_logs "$2"
        ;;
    "cleanup")
        cleanup
        ;;
    "menu"|"")
        check_docker
        while true; do
            show_menu
        done
        ;;
    *)
        echo "Usage: $0 {setup|start|start-dev|stop|status|logs|cleanup|menu}"
        echo ""
        echo "Commands:"
        echo "  setup     - Setup environment file"
        echo "  start     - Start services in production mode"
        echo "  start-dev - Start services in development mode"
        echo "  stop      - Stop all services"
        echo "  status    - Show service status"
        echo "  logs      - Show logs (optionally specify service name)"
        echo "  cleanup   - Stop services and clean up resources"
        echo "  menu      - Interactive menu (default)"
        exit 1
        ;;
esac
