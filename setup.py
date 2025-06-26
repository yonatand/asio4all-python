from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize

# Read the README file if it exists
def read_readme():
    try:
        with open("README.md", "r", encoding="utf-8") as fh:
            return fh.read()
    except FileNotFoundError:
        return "Python bindings for ASIO4ALL audio driver interface"

ext_modules = [
    Extension(
        "asio4all.asio4all",  # Module path for the extension
        sources=[
            "asio4all/asio4all.pyx",         # your Cython file
            "asio4all/lib/a4aInterface.cpp", # C++ implementation
            "asio4all/lib/CLSID.cpp",        # GUIDs
            "asio4all/lib/stdafx.cpp",       # precompiled header source
        ],
        language="c++",
        include_dirs=["asio4all/lib", "asio4all/lib/COMMON"],
        libraries=["ole32"],
        define_macros=[("WIN32_LEAN_AND_MEAN", None)],
    )
]

setup(
    name="asio4all-python",
    version="0.0.1",
    author="Yonatan Dolgopyatov",  # Replace with your name
    author_email="yonadolg@gmail.com",  # Replace with your email
    description="Python bindings for ASIO4ALL audio driver interface",
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    url="https://github.com/yonatand/asio4all-python",  # Replace with your repository URL
    packages=find_packages(),
    ext_modules=cythonize(ext_modules, compiler_directives={'language_level': 3}),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Topic :: Multimedia :: Sound/Audio",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Programming Language :: Python :: 3.13",
        "Operating System :: Microsoft :: Windows",
    ],
    python_requires=">=3.8",
    install_requires=[
        "cython>=3.0.0",
    ],
    setup_requires=[
        "cython>=3.0.0",
    ],
    keywords="asio4all audio driver windows interface",
    project_urls={
        "Bug Reports": "https://github.com/yonatand/asio4all-python/issues",
        "Source": "https://github.com/yonatand/asio4all-python",
    },
    zip_safe=False,  # Due to C extensions
    platforms=["win32", "win-amd64"],
)