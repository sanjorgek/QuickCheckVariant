---
title:        "Maybe"
description:  "A data instance"
image:        "http://placehold.it/400x200"
author:       "SanJorgeK"
---

Variant Maybe
=============

Only Just data can be valid, nothing always is invalid.

```haskell
instance (Variant a) => Variant (Maybe a) where
  invalid = return Nothing
  valid = do
    x <- valid
    return (Just x)
```
