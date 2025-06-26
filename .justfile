#!/usr/bin/env -S just --justfile

# Make the default recipe just list possible recipes. Taken from the
# `just` documentation:
#     https://github.com/casey/just?tab=readme-ov-file#listing-available-recipes
# 
default:
    @just --list --unsorted --justfile {{justfile()}}

alias b := build
alias t := test
alias c := clean

# TODO: Make note in documentation about these environment variables.
# The build/test dir variables can be set to change the build directory, and the
# PDF viewer variable to change what program is used for opening PDFs.

src_dir := 'src'
build_dir := env('RIREKISHO_BUILD_DIR', 'build')
test_dir := build_dir/env('RIREKISHO_TEST_DIR', 'test')
pdf_viewer := env('PDF_VIEWER', 'okular')

build: make-build-dir
    # Basically, just copy over the lib into a versioned directory

test: make-test-dir
    #!/usr/bin/env fish

    for file in test/*.typ
        set output_file (
            string join '/' '{{build_dir}}' (path change-extension 'pdf' $file)
        )
        typst c --root . $file $output_file
    end

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
make-test-dir: make-build-dir
    @mkdir -p '{{test_dir}}/'
