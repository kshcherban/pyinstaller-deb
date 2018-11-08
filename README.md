PyInstaller Debian
==================

Docker image that can build single file Python apps with
[PyInstaller](http://pyinstaller.readthedocs.io/) for Linux.

This Docker image provides a clean way to build PyInstaller apps in
an isolated environment.

Based on https://github.com/six8/pyinstaller-alpine

Usage
-----

### Building A PyInstaller Package

To build a Python package, create a Docker container with your source
mounted as a volume at `/src`:

    docker run --rm \
        -v "${PWD}:/src" \
        bamaboy/pyinstaller-deb \
        --noconfirm \
        --onefile \
        --log-level DEBUG \
        --clean \
        example.py

If a `requirements.txt` file is found in your source directory, the
requirements will automatically be installed with `pip3`.

This will output a built app to the `dist` sub-directory in your source
directory. The app can be ran on an Alpine OS:

    ./dist/dynamic

Also if you set environment variable `COMPILE_STATIC=true`, static binary
will be placed into.

    ./dist/static

For static binary creation [staticx](https://github.com/JonathonReinhart/staticx/) is used.

### Encrypting Your App

You can use PyInstaller to
[obfuscate your source with encryption](https://pythonhosted.org/PyInstaller/usage.html#encrypting-python-bytecode).
To use a specific key, pass a 16 character string with the `--key {key-string}`
parameter. A non-standard feature of this Docker image is that you can use
`--random-key` to use a random key:

    docker run --rm \
        -v "${PWD}:/src" \
        bamaboy/pyinstaller-deb \
        --onefile \
        --random-key \
        --clean \
        example.py


### Reproducible Build

If you want a [Reproducible Build](https://pythonhosted.org/PyInstaller/advanced-topics.html#creating-a-reproducible-build)
when your source has not changed, you can pass a `PYTHONHASHSEED` env var
for consistent randomization for internal data structures:

    docker run --rm \
        -v "${PWD}:/src" \
        -e PYTHONHASHSEED=42 \
        bamaboy/pyinstaller-deb \
        --onefile \
        --clean \
        example.py

    cksum dist/example | awk '{print $1}'


Building Docker Image
---------------------

If you'd like to build the Docker image yourself:

    docker build -t pyinstaller-deb .
