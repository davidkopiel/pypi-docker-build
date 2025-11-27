from setuptools import setup, find_packages

setup(
    name="myproject",  # change this to your package name
    version="0.1.0",   # update as needed
    packages=find_packages(),  # auto-discover Python packages in your project
    install_requires=[
        "requests>=2.25.0"
    ],
    python_requires=">=3.7",
    author="Your Name",
    author_email="your.email@example.com",
    description="My sample project with requests dependency",
    url="https://example.com/myproject",
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
)

