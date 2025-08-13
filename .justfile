#!/usr/bin/env -S just --justfile

# Make the default recipe just list possible recipes. Taken from the
# `just` documentation:
#     https://github.com/casey/just?tab=readme-ov-file#listing-available-recipes
# 
default:
    @just --list --unsorted --justfile {{justfile()}}

alias b := build
alias i := install
alias t := test
alias td := test-with-debug
alias c := clean

package_name := 'resumania'

version := `cat version`

# TODO: Make note in documentation about these environment variables.
# The build/test dir variables can be set to change the build directory, and the
# PDF viewer variable to change what program is used for opening PDFs.

build_dir := env('RESUMANIA_BUILD_DIR', 'build')
package_dir := build_dir/'local'/package_name/version
test_dir := build_dir/env('RESUMANIA_TEST_DIR', 'test')
pdf_viewer := env('PDF_VIEWER', 'okular')

data_dir := env('$XDG_DATA_HOME', env('HOME')/'.local/share')
typst_package_dir := data_dir/'typst'/'packages'/'local'
install_dir := env('RESUMANIA_INSTALL_DIR', typst_package_dir/package_name)

build: make-package-dir
    #!/usr/bin/env fish

    # TODO: find a better way of defining the manifest

    # The readme and license files have to be capitalized to satisfy Typst's
    # package checker, so they are copied to the packaging directory under the
    # same names just with full capitalization.
    set -a manifest 'readme'
    set -a manifest 'license'

    for file in $manifest
        set upper_file (string upper $file)
        cp $file (string join '/' '{{package_dir}}' $upper_file)
    end

    set -e manifest
    set -a manifest 'typst.toml'
    set -a manifest 'src/'
    set -a manifest 'template/'
    set -a manifest 'changelog'

    cp -rt '{{package_dir}}' $manifest

    typst c 'template/main.typ' -                                              \
        --package-path '{{build_dir}}'                                         \
        -f png --pages 1 --ppi 250                                             \
    | oxipng -sq -o max - --out '{{package_dir}}'/'thumbnail.png'

# Build and install locally (currently Linux-only).
install: make-install-dir build
    #!/usr/bin/env fish

    cp -rt '{{install_dir}}' '{{package_dir}}'

check-package: build
    #!/usr/bin/env fish

    cd '{{package_dir}}'
    typst-package-check check

test pattern="" debug="false": make-test-dir
    #!/usr/bin/env fish

    set files (find 'test/' -type f -name '*{{pattern}}*.typ')

    for file in $files
        set output_file (
            string join '/' '{{build_dir}}' (path change-extension 'pdf' $file)
        )
        echo $file
        typst c --root . $file $output_file --input 'debug={{debug}}'
    end

test-with-debug pattern="": (test pattern "true")

clean:
    rm -r {{build_dir}}

open-tests:
    #!/usr/bin/env fish

    set files (find '{{test_dir}}' -type f -name '*.pdf')
    '{{pdf_viewer}}' $files &>/dev/null &

[private]
make-build-dir:
    @mkdir -p '{{build_dir}}/'

[private]
make-install-dir:
    @mkdir -p '{{install_dir}}/'

[private]
make-package-dir: make-build-dir
    @mkdir -p '{{package_dir}}/'

[private]
make-test-dir: make-build-dir
    @mkdir -p '{{test_dir}}/'
