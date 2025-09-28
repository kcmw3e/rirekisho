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

package-name := 'resumania'

version := `cat version`

# TODO: Make note in documentation about these environment variables.
# The build/test dir variables can be set to change the build directory, and the
# PDF viewer variable to change what program is used for opening PDFs.

build-dir := env('RESUMANIA_BUILD_DIR', 'build')
package-dir := build-dir/'preview'/package-name/version
test-dir := build-dir/env('RESUMANIA_TEST_DIR', 'test')
pdf-viewer := env('PDF_VIEWER', 'okular')

data-dir := if os() == "linux" {
    env('$XDG_DATA_HOME', env('HOME')/'.local/share')
} else if os() == "macos" {
    env('HOME')/'Library'/'Application Support'
} else if os() == 'windows' {
    '%APPDATA%'
} else {
    error(
        '''
            Unsupported operating system for installation. If you just want to
            build or do something other than install, modify this file by
            changing this branch to the installation path you want.
        '''
    )
}

typst-package-dir := data-dir/'typst'/'packages'/'local'
install-dir := env('RESUMANIA_INSTALL_DIR', typst-package-dir/package-name)

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
        cp $file (string join '/' '{{package-dir}}' $upper_file)
    end

    set -e manifest
    set -a manifest 'typst.toml'
    set -a manifest 'src/'
    set -a manifest 'template/'
    set -a manifest 'changelog'

    cp -rt '{{package-dir}}' $manifest

    typst c 'template/main.typ' -                                              \
        --package-path '{{build-dir}}'                                         \
        -f png --pages 1 --ppi 250                                             \
    | oxipng -sq -o max - --out '{{package-dir}}'/'thumbnail.png'

# Build and install locally (currently Linux-only).
install: make-install-dir build
    #!/usr/bin/env fish

    cp -rt '{{install-dir}}' '{{package-dir}}'

check-package: build
    #!/usr/bin/env fish

    cd '{{package-dir}}'
    typst-package-check check

test pattern="" debug="false": make-test-dir
    #!/usr/bin/env fish

    set files (find 'test/' -type f -name '*{{pattern}}*.typ')

    for file in $files
        set output_file (
            string join '/' '{{build-dir}}' (path change-extension 'pdf' $file)
        )
        echo $file
        typst c --root . $file $output_file --input 'debug={{debug}}'
    end

test-with-debug pattern="": (test pattern "true")

clean:
    rm -r {{build-dir}}

open-tests: test
    #!/usr/bin/env fish

    set files (find '{{test-dir}}' -type f -name '*.pdf')
    '{{pdf-viewer}}' $files &>/dev/null &

[private]
make-build-dir:
    @mkdir -p '{{build-dir}}/'

[private]
make-install-dir:
    @mkdir -p '{{install-dir}}/'

[private]
make-package-dir: make-build-dir
    @mkdir -p '{{package-dir}}/'

[private]
make-test-dir: make-build-dir
    @mkdir -p '{{test-dir}}/'
