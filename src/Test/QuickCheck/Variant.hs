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
