"""
Setup script for the databricks_etl package.
"""

from setuptools import setup, find_packages
import os
from src.databricks_etl import __version__

# Read the contents of README.md
this_directory = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(this_directory, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name="databricks_etl",
    version=__version__,
    author="Your Name",
    author_email="your.email@example.com",
    description="Databricks ETL package for data processing",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/databricks-etl",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.9",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.9",
    install_requires=[
        "pyspark>=3.3.0",
        "delta-spark>=2.2.0",
        "pandas>=1.5.0",
        "numpy>=1.23.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "pytest-cov>=4.0.0",
            "flake8>=6.0.0",
            "black>=23.0.0",
            "isort>=5.12.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "databricks-etl=databricks_etl.main:main",
        ],
    },
)