# run this for first time (register)
# chmod +x flutter-setup.sh


# Step 0: Clean flutter environment (ffvm clean)
echo "Cleaning flutter environment..."
fvm flutter clean

# Step 1: Delete pubspec.lock file (if it exists)
echo "Removing pubspec.lock file..."
if [ -f "pubspec.lock" ]; then
  rm pubspec.lock
  echo "pubspec.lock file removed."
fi

# Step 2: Get Flutter dependencies
echo "Running flutter pub get..."
fvm flutter pub get

# Step 3: Change directory to ios
echo "Navigating to ios directory..."
cd ios

# Step 4: Run pod install with --repo-update
echo "Running pod install --repo-update..."
pod install --repo-update

# Go back to the root directory
cd ..

echo "Flutter setup completed successfully!"
