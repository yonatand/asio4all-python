# PyPI Publishing Setup Guide

## Overview

This repository includes GitHub Actions workflows to automatically build and publish your Python package to PyPI. The workflows support:

- Building wheels for multiple Python versions (3.8-3.13)
- Building source distributions
- Testing packages before publishing
- Publishing to TestPyPI and PyPI

## Setup Instructions

### 1. Repository Setup

1. **Update URLs in pyproject.toml**:
   ```toml
   [project.urls]
   Homepage = "https://github.com/YOUR_USERNAME/asio4all-python"
   Repository = "https://github.com/YOUR_USERNAME/asio4all-python"
   Issues = "https://github.com/YOUR_USERNAME/asio4all-python/issues"
   ```

2. **Set up repository secrets** (if not using trusted publishing):
   - Go to your repository settings
   - Navigate to "Secrets and variables" → "Actions"
   - Add secrets:
     - `PYPI_API_TOKEN`: Your PyPI API token
     - `TEST_PYPI_API_TOKEN`: Your TestPyPI API token

### 2. Trusted Publishing (Recommended)

Instead of API tokens, you can use trusted publishing (more secure):

1. **Set up PyPI trusted publishing**:
   - Go to https://pypi.org/manage/account/publishing/
   - Add a new publisher with:
     - PyPI Project Name: `asio4all-python`
     - Owner: `YOUR_USERNAME`
     - Repository name: `asio4all-python`
     - Workflow filename: `build-and-publish.yml`
     - Environment name: `pypi`

2. **Set up TestPyPI trusted publishing**:
   - Go to https://test.pypi.org/manage/account/publishing/
   - Add a new publisher with the same settings but environment name: `testpypi`

### 3. GitHub Environments

1. **Create environments** in your repository:
   - Go to repository Settings → Environments
   - Create two environments:
     - `pypi` (for production PyPI)
     - `testpypi` (for test PyPI)

2. **Configure protection rules** (optional but recommended):
   - Require reviewers for production deployments
   - Restrict to specific branches (e.g., main)

## Workflows

### 1. `build-and-publish.yml`

**Triggers**:
- When you push a version tag (e.g., `v1.0.0`)
- When you create a GitHub release
- Manual trigger via GitHub Actions UI

**Jobs**:
- **build-windows**: Builds wheels for Python 3.8-3.13 on Windows
- **build-sdist**: Builds source distribution
- **test-package**: Tests installation and basic functionality
- **publish-testpypi**: Publishes to TestPyPI (on tag push)
- **publish-pypi**: Publishes to PyPI (on release)

### 2. `test.yml`

**Triggers**:
- Pull requests to main/master
- Pushes to main/master (when code files change)

**Jobs**:
- **test-build**: Tests building the package on multiple Python versions

## Publishing Process

### Option 1: Using Git Tags (TestPyPI)

1. **Update version** in `pyproject.toml` and `setup.py`
2. **Commit and push** changes
3. **Create and push a tag**:
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```
4. **Check workflow**: Go to Actions tab to monitor the build
5. **Verify on TestPyPI**: Check https://test.pypi.org/project/asio4all-python/

### Option 2: Using GitHub Releases (PyPI)

1. **Update version** in `pyproject.toml` and `setup.py`
2. **Commit and push** changes
3. **Create a GitHub release**:
   - Go to your repository → Releases
   - Click "Create a new release"
   - Choose a tag (e.g., `v1.0.0`)
   - Add release notes
   - Click "Publish release"
4. **Check workflow**: The publish job will run automatically
5. **Verify on PyPI**: Check https://pypi.org/project/asio4all-python/

### Option 3: Manual Trigger

1. **Go to Actions tab**
2. **Select "Build and Publish to PyPI" workflow**
3. **Click "Run workflow"**
4. **Choose branch and click "Run workflow"**

## Testing Your Package

After publishing to TestPyPI, test installation:

```bash
# Create a new virtual environment
python -m venv test_env
test_env\Scripts\activate  # Windows
# or
source test_env/bin/activate  # Linux/Mac

# Install from TestPyPI
pip install --index-url https://test.pypi.org/simple/ asio4all-python

# Test import
python -c "import asio4all; print('Success!')"
```

## Version Management

Update version numbers in:
- `pyproject.toml` → `version = "x.y.z"`
- `setup.py` → `version="x.y.z"`
- `asio4all/__init__.py` → `__version__ = "x.y.z"`

## Troubleshooting

### Common Issues

1. **Build fails on Windows**:
   - Ensure Microsoft Visual C++ is available in GitHub Actions
   - Check that all C++ headers are included

2. **Import fails after installation**:
   - Verify all dependencies are properly declared
   - Check that compiled extensions are included in the wheel

3. **Publishing fails**:
   - Verify API tokens or trusted publishing setup
   - Check that package name is available on PyPI
   - Ensure version number hasn't been used before

### Debugging

1. **Download build artifacts**:
   - Go to Actions tab → Select workflow run
   - Download artifacts to inspect built packages

2. **Check logs**:
   - Click on failed job in Actions tab
   - Expand failed step to see detailed error messages

## Security Best Practices

1. **Use trusted publishing** instead of API tokens when possible
2. **Protect environments** with required reviewers
3. **Limit workflow permissions** to minimum required
4. **Regular security updates** for workflow dependencies

## Additional Resources

- [PyPI Publishing Guide](https://packaging.python.org/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/)
- [Trusted Publishing](https://docs.pypi.org/trusted-publishers/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
