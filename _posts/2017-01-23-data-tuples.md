---
title:        "Tuples"
description:  "A data instance"
image:        "http://placehold.it/400x200"
author:       "SanJorgeK"
---

Varaint 2-tuple
=============

Invalid tuple may had some valid data with invalid data or only invalid data.
Valid tuple had only valid data.

```haskell
instance (Variant a, Variant b) => Variant ((,) a b) where
  invalid = do
    x <- invalid
    y <- invalid
    z <- valid
    w <- valid
    (oneof . map return) [(x,y), (x,z), (w,y)]
  valid = do
    x <- valid
    y <- valid
    return (x, y)
```

Varaint 3-tuple
===============

Invalid 3-tuple may had some valid data with invalid data or only invalid data.
Valid 3-tuple had only valid data.

```haskell
instance (Variant a, Variant b, Variant c) => Variant ((,,) a b c) where
  invalid = do
    x <- invalid
    y <- invalid
    z <- invalid
    w <- valid
    v <- valid
    u <- valid 
    (oneof . map return) [(x,y,z), (x,y,u), (x,v,z), (w,y,z), (w,v,z), (x,v,u), (w,y,u)]
  valid = do
    x <- valid
    y <- valid
    z <- valid    
    return (x, y, z)
```
