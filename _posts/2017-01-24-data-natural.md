---
title:        "Natural"
description:  "A data instance"
image:        "http://placehold.it/400x200"
author:       "SanJorgeK"
---

Varaint Natural
===============

From Integer, I define Natural type like:

```haskell
{-# LANGUAGE TypeSynonymInstances #-}

type Natural = Integer

instance Variant Natural where
  invalid = do
    n <- arbitrary
    if n<0 then return n else return ((-1)*(n+1))
  valid = do
    n <- arbitrary
    if n>=0 then return n else return ((-1)*n)
```

Also you can generate Pairs, Odds, any computable decision function over integers.
