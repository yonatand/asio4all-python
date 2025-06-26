#!/usr/bin/env python3
"""
Build script for asio4all package
"""

import subprocess
import sys
import os
from pathlib import Path

def run_command(cmd, description):
    """Run a command and handle errors"""
    print(f"\n{description}...")
    print(f"Running: {' '.join(cmd)}")
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"❌ {description} failed!")
        print("STDOUT:", result.stdout)
        print("STDERR:", result.stderr)
        return False
    else:
        print(f"✅ {description} succeeded!")
        if result.stdout.strip():
            print("Output:", result.stdout.strip())
        return True

def main():
    """Main build function"""
    print("🏗️  Building asio4all package")
    print("=" * 50)
    
    # Change to project directory
    project_dir = Path(__file__).parent
    os.chdir(project_dir)
    
    # Clean previous builds
    if not run_command([sys.executable, "setup.py", "clean", "--all"], "Cleaning previous builds"):
        return False
    
    # Build extension in place
    if not run_command([sys.executable, "setup.py", "build_ext", "--inplace"], "Building extension"):
        return False
    
    # Build source distribution
    if not run_command([sys.executable, "setup.py", "sdist"], "Building source distribution"):
        return False
    
    # Build wheel
    if not run_command([sys.executable, "setup.py", "bdist_wheel"], "Building wheel"):
        return False
    
    print("\n🎉 Build completed successfully!")
    print("\nBuild artifacts:")
    
    # List build artifacts
    dist_dir = Path("dist")
    if dist_dir.exists():
        for file in dist_dir.iterdir():
            print(f"  📦 {file.name}")
    
    print("\n📋 Next steps:")
    print("  1. Test the wheel: pip install dist/*.whl")
    print("  2. Upload to TestPyPI: twine upload --repository-url https://test.pypi.org/legacy/ dist/*")
    print("  3. Upload to PyPI: twine upload dist/*")

if __name__ == "__main__":
    main()
