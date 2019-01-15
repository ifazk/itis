# itis
Check whether "it's" is used in a latex file. I consider "it's" to be bad form
and prefer "it is". Also often shows up as a typo, when I actually meant "its".

Flycheck configuration is as follows:

``` elisp
  (flycheck-define-checker latex-itis
    "A LaTeX syntax checker that warns about the uses of it's."
    :command ("itis" source)
    :error-patterns
    ((error line-start (file-name) ":" line ":" column ": "  (message) line-end))
    :modes latex-mode
    :error-filter
    flycheck-increment-error-columns
    :next-checkers (tex-chktex)
    )
  (add-to-list 'flycheck-checkers 'latex-itis)
```
