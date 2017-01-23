{-# OPTIONS_GHC -fno-warn-tabs #-}
{-|
Module      : Test.QuickCheck.Variant
Description : Varaint class
Copyright   : (c) Jorge Santiago Alvarez Cuadros, 2015
License     : GPL-3
Maintainer  : sanjorgek@ciencias.unam.mx
Stability   : experimental
Portability : portable

To get random "invalid" and "valid" data
-}
module Test.QuickCheck.Variant where
import           Test.QuickCheck

{-|
You can define

>>> instance (Varaint a) => Arbitrary a where {arbitrary = oneof [valid, invalid]}
-}
class Variant a where
  -- |Get a generator of valid random data type
  valid   :: Gen a
  -- |Get a generator of invalid random data type
  invalid :: Gen a

{-|
Variant of a list.

A valid list only had valid data.

A invalid list had only invalid data or some valid data with invalid data.
-}
instance (Variant a) => Variant [a] where
  valid = do
    x <- valid
    xs <- valid
    (oneof . map return) [[], [x], x:xs]
  invalid = do
    x <- invalid
    xs <- invalid
    y <- valid
    ys <- valid
    (oneof . map return) [[x], x:xs, x:ys, y:xs]

{-|
Variant Maybe

Only Just data can be invalid, nothing always is valid.
-}
instance (Variant a) => Variant (Maybe a) where
  invalid = return Nothing
  valid = do
    x <- valid
    return (Just x)

{-|
Varaint Either.
-}
instance (Variant a, Variant b) => Variant (Either a b) where
  invalid = do
    x <- invalid
    y <- invalid
    (oneof . map return) [Left x, Right y]
  valid = do
    x <- valid
    y <- valid
    (oneof . map return) [Left x, Right y]

{-|
Varaint tuple

Invalid tuple may had some valid data with invalid data or only invalid data.

Valid tuple had only valid data.
-}
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

{-|
Varaint 3-tuple

Invalid 3-tuple may had some valid data with invalid data or only invalid data.

Valid 3-tuple had only valid data.
-}
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

{-|
The class of things wich can be tested with invalid or valid input.
-}
class VarTesteable prop where
  -- |Property for valid input
  propertyValid::prop -> Property
  -- |Property for invalid input
  propertyInvalid::prop -> Property

{-|
Same as Testeable
-}
instance VarTesteable Bool where
  propertyValid = property
  propertyInvalid = property

{-|
Instead of variant we use valid or invalid generators
-}
instance (Arbitrary a, Variant a, Show a, Testable prop) => VarTesteable (a->prop) where
  propertyValid = forAllShrink valid shrink
  propertyInvalid = forAllShrink invalid shrink
