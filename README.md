# docker-saltstack

Reasonable secure Saltstack image

## ci/cd

Releases are managed by [Release Please](https://github.com/googleapis/release-please).
Use Conventional Commits for changes that should create a release: `fix:` increments
patch, `feat:` increments minor, and a breaking-change footer increments major.
Merging a generated release pull request creates a `v<version>` GitHub release, which
triggers the image build and publication workflow.
