# chez-help

A fake "online help" for Chez Scheme.

It will search symbol name in _The Scheme Programming Language (Fourth Edition)_ and _Chez Scheme Version 9 User's Guide_, if found, it will open a web page through the default web browser.

It currently only works on macOS.


## Example

```
(import (help))

(help 'syntax-case)

(help 'make-engine)
```


## Dependencies

* match https://github.com/qzivli/match
