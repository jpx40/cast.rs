set -euxo pipefail

main() {
    cargo check --target $TARGET --no-default-features

    cargo test --target $TARGET
    cargo test --target $TARGET --release

    # not MSRV
    if [ $TRAVIS_RUST_VERSION != 1.13.0 ]; then
        cargo test --features x128 --target $TARGET
        cargo test --features x128 --target $TARGET --release
    fi
}

# fake Travis variables to be able to run this on a local machine
if [ -z ${TRAVIS_BRANCH-} ]; then
    TRAVIS_BRANCH=staging
fi

if [ -z ${TRAVIS_PULL_REQUEST-} ]; then
    TRAVIS_PULL_REQUEST=false
fi

if [ -z ${TRAVIS_RUST_VERSION-} ]; then
    case $(rustc -V) in
        *nightly*)
            TRAVIS_RUST_VERSION=nightly
            ;;
        *beta*)
            TRAVIS_RUST_VERSION=beta
            ;;
        *)
            TRAVIS_RUST_VERSION=stable
            ;;
    esac
fi

if [ -z ${TARGET-} ]; then
    TARGET=$(rustc -Vv | grep host | cut -d ' ' -f2)
fi

main
