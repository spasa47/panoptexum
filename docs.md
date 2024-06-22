---
title: Pan\OpTeX/um
subtitle: Pandoc[^1] Writer for \\OpTeX[^2]
style: report
author: [Jan Martínek]
version: 0.1.0
toc: true
tocname: Table of contents
---


# What is Pan\OpTeX/um?

Pan\OpTeX/um is a project that implements the \OpTeX/ format into Pandoc. Many \OpTeX/ users
have expressed their desire to be able to convert documents to and from \OpTeX/ using Pandoc.
Currently only the writer is implemented, that means that you can use Pandoc to convert
documents to \OpTeX/, but not from \OpTeX/ as of yet.

## Why does it exist?

This project was created as a semestral project at FIT CTU in Prague in the academic year 2023/2024.


# User documentation

## Prerequisites

You need just one thing (or possibly two) before you should attempt to use or install this project:

- Working pandoc instalation.
    - That is easy to verify, just type:
    ```sh
    pandoc -v
    ```
    - If the above command prints anything other
    than pandoc's version, it means you do not have
    pandoc on `PATH` or installed.
- Working optex installation.
    - **Only if you want to convert the resulting files to pdf.**
    - This is also rather easy to verify:
    ```sh
    optex -v
    ```

## Installation

Pandoc has the option `--data-dir`, by default it uses `~/.local/share/pandoc/`.
Running `make install` will prepare files into the data directory. After that you
can start converting to \OpTeX/ as specified in the Usage section.

## Usage

Simply use pandoc as you normaly would, however this time specify the `-d/--defaults` option as such:

```sh
pandoc -d optex ...
```

For example, to create the `.tex` file, that is used to create the `.pdf` of this manual,
use
```sh
pandoc -d optex README.md >README.tex
```

After which you can use
```sh
optex README
```
to create `README.pdf` (you might need to run the optex command above 2-3 times, this
is due to how optex handles table of contents etc.).

### Options

Here is a list of all options that can be specified using pandoc's
metadata fields.

#### Title

`title`

#### Subtitle

`subtitle`

#### Version

`version`

#### Author

`author`

#### Style

\OpTeX/ supports three predefined styles:

1. report
2. letter
3. slides

You can specify which one you want to use, by setting the metadata field `style` to one of them.
Alternatively, you can leave the `style` field unset, in which case it will behave just like \OpTeX/ by default.

#### Table of contents

If you want to generate table of contents, please specify the metadata option `toc` as `true`.
Use `tocname` to create a name for the **Table of contents** section.

##### Examples

Telling \OpTeX/ to generate a table of contents:
```yaml
toc: true
```
or
```sh
pandoc ... -M toc=true ...
```

Setting the name of the toc section:
```yaml
toc: true # needs to be true, otherwise tocname hase no effect
tocname: Table of contents
```
or
```sh
pandoc ... -M toc=true -M tocname="Table of contents" ...
```


## Complications

According to the Pandoc documentation, the option:

```bash
-t FORMAT, -w FORMAT, --to=FORMAT, --write=FORMAT
```

can also specify:


> - the path of a custom Lua writer, see Custom readers and writers below

In the very same documentation we can also learn that, when writing a Defaults file, you can use
environment variables:

>  In fields that expect a file path (or list of file paths), the following syntax may be used to interpolate environment variables:
>```yaml
>csl:  ${HOME}/mycsldir/special.csl
>```
> \\${USERDATA} may also be used; this will always resolve to the user data directory that is current when the defaults file is parsed, regardless
> of the setting of the environment variable USERDATA.


One might suppose that when specifying the field `write`, which accepts a path to a custom Lua writer, it ought to be possible
to use environment variables and expect them to get expanded. Alas, this is not true, which means that the install script needs
to use the absolute path. This means that if the users data directory gets changed, the defaults file will **not** reflect these changes.

I am currently planning to create an issue in the Pandoc repository, because I believe that this behaviour directly contradicts
the provided documentation.

**Update:** So there is an issue [here](https://github.com/jgm/pandoc/issues/8826) that seems to talk about this problem, 
however it does not seem to have gained much traction...

# Ideas for the future

While I will probably add some of these features in the future, as this is not paid work, it will have to wait for when I have free time to do so.

## Arbitrary heading levels

Currently we support heading levels only up to 4, however many formats might have the limit much higher or have no limit at all.
Thus it would be prudent to support converting from these languages as well, maybe by creating an \OpTeX/ macro, that would take
2 arguments:

1. The content of the heading.
2. The level of the heading.

The macro could then look like so:

```tex
\def\heading #1 #2 {%
%the definition of the macro would be here
}
```
This macro would essentially do one of three things:

1. Use an existing heading level if it already exists in \OpTeX/ out of the box.
2. Use an already defined custom heading level, define by a previous occurence of this macro.
3. If none of the above are possible, define a new heading level and use it.

There might not be a need for this macro after all, as \OpTeX/ provides the macro `\secl`.

## Figure captions

Currently we are skipping any caption information. \OpTeX/ supports this
so the writer should as well.

## Columns/rows spanning multiple cells in a table

This is also currently not supported by the writer, though \OpTeX/ supports it.

## Table captions

Same as **Figure captions**

## Both bold and italic text at the same time

- **Bold**
- *Italic*
- ***Bitalic***

## Font selection

Add the possibility to select a font.

## Margins and paper size

# Technical documentation

## Writer

The writer is written in the Lua language.

```lua
Writer = pandoc.scaffolding.Writer
```


[optex-writer.lua](optex-writer.lua)

## Template

The template is written in \TeX/ using \OpTeX/ macros and special pandoc markers.

[optex-template.tex](optex-template.tex)

## Defaults file

There are now two defaults files:

- one for producing standalone versions of \OpTeX/ documents, ready for \TeX/ing,
    - it is this one: [optex-default-standalone.yaml](optex-default-standalone.yaml)
- and another one for creating non-standalone versions, suitable for beign embedded into other \OpTeX/ documents.
    - that is this one: [optex-default.yaml](optex-default.yaml)

The defaults files are written in the `yaml` format as specified by the Pandoc documentation.
For example, here is what it might look like:
```yaml
standalone: true
template: ${USERDATA}/templates/optex-template.tex
pdf-engine: lualatex
```


[^1]: A universal document converter <https://www.pandoc.org/>

[^2]: LuaTeX format with extended plainTeX macros <https://petr.olsak.net/optex/>

