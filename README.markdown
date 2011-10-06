# YAML flattener plugin for Vim

Vim plugin to toggle a YAML file buffer from nested format

    en:
      foo:
        bar: "baare"
      baz: "baize"

to a flat format

    en.foo.bar: "baare"
    en.baz: "baize"

and back again.

This is handy with Ruby on Rails .yml translation files.
Convert them to flat format to search and edit more easily, then back to nested format for compatibility with Rails i18n and other tools.

Just open a YAML file and hit ⌘r or <leader>r. Again to go back.

Based on my [YAMLator lib](https://gist.github.com/293581).

## Caveats

Keys will be sorted on each conversion. You might consider this a feature – convert the file twice to sort it.

Any comments in the beginning of the file are kept, but inline comments are lost.


## Credits and license

By [Henrik Nyh](http://henrik.nyh.se/) under the MIT license:

>  Copyright (c) 2011 Henrik Nyh
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
