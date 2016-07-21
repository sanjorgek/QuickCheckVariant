{-# OPTIONS_GHC -fno-warn-tabs #-}
module Test.QuickCheck.Variant where
import Test.QuickCheck

class Variant a where
  valid   :: Gen a
  invalid :: Gen a

instance (Variant a) => Variant [a] where
  valid = do
    x <- valid
    xs <- valid
    (oneof . map return) [[], [x], x:xs]
  invalid = do
    x <- invalid
    xs <- invalid
    (oneof . map return) [[], [x], x:xs]

instance (Variant a) => Variant (Maybe a) where
  invalid = do
    x <- invalid
    return (Just x)
  valid = do
    x <- valid
    (oneof . map return) [Nothing, Just x]

instance (Variant a, Variant b) => Variant (Either a b) where
  invalid = do
    x <- invalid
    y <- invalid
    (oneof . map return) [Left x, Right y]
  valid = do
    x <- valid
    y <- valid
    (oneof . map return) [Left x, Right y]

instance (Variant a, Variant b) => Variant ((,) a b) where
  invalid = do
    x <- invalid
    y <- invalid
    return (x, y)
  valid = do
    x <- valid
    y <- valid
    return (x, y)

instance (Variant a, Variant b, Variant c) => Variant ((,,) a b c) where
  invalid = do
    x <- invalid
    y <- invalid
    z <- invalid
    return (x, y, z)
  valid = do
    x <- valid
    y <- valid
    z <- invalid    
    return (x, y, z)