# Dependency

A module to create a tree structure for PS module dependencies.

At my work, we support a lot of powershell modules. We cover a braod range of systems administration tooling, and we try to keep each module focused. As a result, we can end up with quite complex dependency chains. Our build tools and execution platform need to be aware of this. Versioning can be a problem. Module import order can be a problem.

## Key goals

- Generally, use PSModuleInfo and ModuleSpecification types for parameters
- Support version specifications other than exact version pinning

## Future plans

- Enable pluggable strategies for finding dependencies (e.g. non-nuget repos, non-github source control)
