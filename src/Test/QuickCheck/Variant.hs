{-# OPTIONS_GHC -fno-warn-tabs #-}
{-|
Module      : Test.QuickCheck.Variant
Description : Variant class
Copyright   : (c) Jorge Santiago Alvarez Cuadros, 2015
License     : GPL-3
Maintainer  : sanjorgek@ciencias.unam.mx
Stability   : experimental
Portability : portable

To get random "invalid" and "valid" data
-}
module Test.QuickCheck.Variant where
import Test.QuickCheck.Arbitrary
import Test.QuickCheck.Exception
import Test.QuickCheck.Gen
import Test.QuickCheck.Property
import Test.QuickCheck.State
import Test.QuickCheck.Text

{-|
You can define

>>> instance (Variant a) => Arbitrary a where {arbitrary = oneof [valid, invalid]}
-}
class Variant a where
  -- |Get a generator of valid random data type
  valid   :: Gen a
  -- |Get a generator of invalid random data type
  invalid :: Gen a

{-|
The class of things wich can be tested with invalid or valid input.
-}
class VarTestable prop where
  -- |Property for valid input
  propertyValid::prop -> Property
  -- |Property for invalid input
  propertyInvalid::prop -> Property

{-|
Same as Testeable
-}
instance VarTestable Bool where
  propertyValid = property
  propertyInvalid = property

mapTotalResultValid :: VarTestable prop => (Result -> Result) -> prop -> Property
mapTotalResultValid f = mapRoseResultValid (fmap f)

-- f here mustn't throw an exception (rose tree invariant).
mapRoseResultValid :: VarTestable prop => (Rose Result -> Rose Result) -> prop -> Property
mapRoseResultValid f = mapPropValid (\(MkProp t) -> MkProp (f t))

mapPropValid :: VarTestable prop => (Prop -> Prop) -> prop -> Property
mapPropValid f = MkProperty . fmap f . unProperty . propertyValid

-- | Adds a callback
callbackValid :: VarTestable prop => Callback -> prop -> Property
callbackValid cb = mapTotalResultValid (\res -> res{ callbacks = cb : callbacks res })

-- | Adds the given string to the counterexample if the property fails.
counterexampleValid :: VarTestable prop => String -> prop -> Property
counterexampleValid s =
  mapTotalResult (\res -> res{ testCase = s:testCase res }) .
  callbackValid (PostFinalFailure Counterexample $ \st _res -> do
    s <- showCounterexampleValid s
    putLine (terminal st) s)

showCounterexampleValid :: String -> IO String
showCounterexampleValid s = do
  let force [] = return ()
      force (x:xs) = x `seq` force xs
  res <- tryEvaluateIO (force s)
  return $
    case res of
      Left err ->
        formatException "Exception thrown while showing test case" err
      Right () ->
        s

-- | Like 'forAll', but tries to shrink the argument for failing test cases.
forAllShrinkValid :: (Show a, VarTestable prop)
             => Gen a -> (a -> [a]) -> (a -> prop) -> Property
forAllShrinkValid gen shrinker pf =
  again $
  MkProperty $
  gen >>= \x ->
    unProperty $
    shrinking shrinker x $ \x' ->
      counterexampleValid (show x') (pf x')

mapTotalResultInvalid :: VarTestable prop => (Result -> Result) -> prop -> Property
mapTotalResultInvalid f = mapRoseResultInvalid (fmap f)

-- f here mustn't throw an exception (rose tree invariant).
mapRoseResultInvalid :: VarTestable prop => (Rose Result -> Rose Result) -> prop -> Property
mapRoseResultInvalid f = mapPropInvalid (\(MkProp t) -> MkProp (f t))

mapPropInvalid :: VarTestable prop => (Prop -> Prop) -> prop -> Property
mapPropInvalid f = MkProperty . fmap f . unProperty . propertyInvalid

-- | Adds a callback
callbackInvalid :: VarTestable prop => Callback -> prop -> Property
callbackInvalid cb = mapTotalResultInvalid (\res -> res{ callbacks = cb : callbacks res })

-- | Adds the given string to the counterexample if the property fails.
counterexampleInvalid :: VarTestable prop => String -> prop -> Property
counterexampleInvalid s =
  mapTotalResult (\res -> res{ testCase = s:testCase res }) .
  callbackInvalid (PostFinalFailure Counterexample $ \st _res -> do
    s <- showCounterexampleInvalid s
    putLine (terminal st) s)

showCounterexampleInvalid :: String -> IO String
showCounterexampleInvalid s = do
  let force [] = return ()
      force (x:xs) = x `seq` force xs
  res <- tryEvaluateIO (force s)
  return $
    case res of
      Left err ->
        formatException "Exception thrown while showing test case" err
      Right () ->
        s

-- | Like 'forAll', but tries to shrink the argument for failing test cases.
forAllShrinkInvalid :: (Show a, VarTestable prop)
             => Gen a -> (a -> [a]) -> (a -> prop) -> Property
forAllShrinkInvalid gen shrinker pf =
  again $
  MkProperty $
  gen >>= \x ->
    unProperty $
    shrinking shrinker x $ \x' ->
      counterexampleInvalid (show x') (pf x')

{-|
Instead of variant we use valid or invalid generators
-}
instance (Arbitrary a, Variant a, Show a, VarTestable prop) => VarTestable (a->prop) where
  propertyValid = forAllShrinkValid valid shrink
  propertyInvalid = forAllShrinkInvalid invalid shrink
