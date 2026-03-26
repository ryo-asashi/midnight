## Resubmission

This is a resubmission.
In this version, I have fully addressed the issues raised by Konstanze Lauseker in the previous review:

* Removed the single quotes around "Moonlight Seminar 2025" in the documentation. Single quotes are now strictly used only for software and package names.
* Resolved the "Examples for unexported functions" issue by completely removing the `mixup` function from the package, and removing the `@examples` sections from the unexported S3 methods (`fastLmMatrix.default` and `ggmid.midimp`).

## Submission Type

This is a new release of **midnight 0.2.0**.

## Test Environments

I have tested this package on:

-   windows-latest (release), via GitHub Actions
-   macOS-latest (release), via GitHub Actions
-   ubuntu-latest (devel), via GitHub Actions
-   ubuntu-latest (release), via GitHub Actions
-   ubuntu-latest (oldrel-1), via GitHub Actions

------------------------------------------------------------------------

## R CMD check results

0 errors \| 0 warnings \| 1 note

-   This is a new release.

------------------------------------------------------------------------

Thank you for your time and consideration.

Best regards,\
Ryoichi Asashiba [aut, cre]
