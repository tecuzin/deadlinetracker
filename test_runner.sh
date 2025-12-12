#!/bin/bash

# Test Runner Script for Deadline Tracker
# This script runs all tests (unit, widget, integration) and generates coverage report

set -e

echo "🚀 Starting test suite..."
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
    else
        echo -e "${RED}✗ $2${NC}"
        exit 1
    fi
}

# Clean previous build artifacts
echo "🧹 Cleaning previous build artifacts..."
flutter clean
flutter pub get
print_status $? "Dependencies installed"
echo ""

# Run code formatting check
echo "📝 Checking code formatting..."
dart format --set-exit-if-changed . > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠ Code formatting issues found. Running formatter...${NC}"
    dart format .
    echo -e "${GREEN}✓ Code formatted${NC}"
fi
echo ""

# Run static analysis
echo "🔍 Running static analysis..."
flutter analyze
print_status $? "Static analysis passed"
echo ""

# Run unit tests
echo "🧪 Running unit tests..."
flutter test --coverage test/models test/providers
print_status $? "Unit tests passed"
echo ""

# Run widget tests
echo "🎨 Running widget tests..."
flutter test test/screens
print_status $? "Widget tests passed"
echo ""

# Run integration tests
echo "🔗 Running integration tests..."
flutter test test/integration
print_status $? "Integration tests passed"
echo ""

# Generate coverage report
echo "📊 Generating coverage report..."
if [ -f coverage/lcov.info ]; then
    # Install lcov if not already installed
    if ! command -v lcov &> /dev/null; then
        echo "Installing lcov..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install lcov
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get install -y lcov
        fi
    fi
    
    # Generate HTML coverage report
    genhtml coverage/lcov.info -o coverage/html
    print_status $? "Coverage report generated at coverage/html/index.html"
    
    # Calculate coverage percentage
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}')
    echo -e "${GREEN}📈 Coverage: ${COVERAGE}${NC}"
else
    echo -e "${YELLOW}⚠ Coverage file not found${NC}"
fi
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ All tests passed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "To view coverage report, open: coverage/html/index.html"
