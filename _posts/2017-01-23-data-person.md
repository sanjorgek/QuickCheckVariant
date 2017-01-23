---
title:        "Person"
description:  "A data instance"
image:        "http://placehold.it/400x200"
author:       "SanJorgeK"
---

Person
======

```haskell
data Person = Anonymous { getId::String } | Client { getUsername::String, getName::String, getEmail::String} deriving(Show,Eq)
```

We can provide means to generate valid and invalid data, like:

```haskell
instance Variant Person where
  valid = do
    id <- alternative
    username <- alternative
    name <- alternative
    domain <- alternative
    ext <- alternative
    (oneof . return) [Anonymous id, Client username name (username++"@"++domain++ext)]
  invalid = do
    username <- alternative
    name <- alternative
    return $ Client username name ""

```
