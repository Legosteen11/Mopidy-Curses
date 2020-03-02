import re
from setuptools import setup, find_packages


def get_version(filename):
    content = open(filename).read()
    metadata = dict(re.findall("__([a-z]+)__ = '([^']+)'", content))
    return metadata["version"]


setup(
    name="Mopidy-Curses",
    version=get_version("mopidy_curses/__init__.py"),
    url="https://github.com/Legosteen11/Mopidy-Curses",
    license="GNU General Public License v3.0 or later",
    author="Wouter Doeland",
    author_email="wouter@wouterdoeland.nl",
    description="Curses front-end for Mopidy",
    long_description=open("README.md").read(),
    packages=find_packages(exclude=["tests", "tests.*"]),
    zip_safe=False,
    include_package_data=True,
    install_requires=[
        "setuptools",
        "Mopidy >= 3.0.1",
        "Pykka >= 2.0.2",
        "urwid >= 2.1.0",
    ],
    entry_points={"mopidy.ext": ["curses = mopidy_curses:Extension",],},
    classifiers=[
        "Environment :: No Input/Output (Daemon)",
        "Intended Audience :: End Users/Desktop",
        "License :: OSI Approved :: GNU General Public License v3.0 or later",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Topic :: Multimedia :: Sound/Audio :: Players",
    ],
)
