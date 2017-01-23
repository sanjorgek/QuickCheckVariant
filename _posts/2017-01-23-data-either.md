---
title:        "Either"
description:  "A data instance"
image:        "http://placehold.it/400x200"
author:       "SanJorgeK"
---

Varaint Either
==============

```haskell
instance (Variant a, Variant b) => Variant (Either a b) where
  invalid = do
    x <- invalid
    return (Left x)
  valid = do
    x <- valid
    return (Right x)
```
