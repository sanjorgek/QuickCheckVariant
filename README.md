# QuickCheckVariant

Generator of "valid" and "invalid" data in a type class

[![QuickCheckVariant](https://img.shields.io/badge/QuickCheckVariant-v1.0.1.1-blue.svg?style=plastic)](https://hackage.haskell.org/package/QuickCheckVariant)
[![pipeline status](https://gitlab.com/sanjorgek/QuickCheckVariant/badges/master/pipeline.svg)](https://gitlab.com/sanjorgek/QuickCheckVariant/commits/master)

For example, if you created

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

See [this post](https://wiki.haskell.org/QuickCheck_as_a_test_set_generator) for more details

## More badges

[![QuickCheckVariant](https://img.shields.io/badge/winter-is%20here-blue.svg)](http://sanjorgek.com/QuickCheckVariant/)

[![forthebadge](http://forthebadge.com/images/badges/uses-badges.svg)](http://sanjorgek.com/QuickCheckVariant/)

[![forthebadge](http://forthebadge.com/images/badges/check-it-out.svg)](http://sanjorgek.com/QuickCheckVariant/)

[![forthebadge](http://forthebadge.com/images/badges/compatibility-betamax.svg)](http://sanjorgek.com/QuickCheckVariant/)

[![forthebadge](http://forthebadge.com/images/badges/you-didnt-ask-for-this.svg)](http://sanjorgek.com/QuickCheckVariant/)
