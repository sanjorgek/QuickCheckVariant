{-# OPTIONS_GHC -fno-warn-tabs #-}
{-# LANGUAGE TypeSynonymInstances #-}
module Main where

import           Test.Hspec
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Variant

type Natural = Integer

instance Variant Natural where
  invalid = do
    n <- arbitrary
    if n<0 then return n else return ((-1)*(n+1))
  valid = do
    n <- arbitrary
    if n>=0 then return n else return ((-1)*(n-1))

tupleProp = describe "Naturals" $ do
  describe "valid" $
    context "order" $ do
      it "0 <= n" $
        propertyValid $
          \ n -> 0 <= (n::Natural)
      it "0 <= n+m" $
        propertyValid $
          \ n m ->  0 <= (n::Natural)+(m::Natural)
      it "0 <= n*m" $
        propertyValid $
          \ n m ->  0 <= (n::Natural)*(m::Natural)
  describe "invalid" $
    context "order" $ do
      it "0 > n" $
        propertyInvalid $
          \ n -> (n::Natural) < 0
      it "0 > n+m" $
        propertyInvalid $
          \ n m ->  0 > (n::Natural)+(m::Natural)
      it "0 < n*m" $
        propertyInvalid $
          \ n m ->  0 < (n::Natural)*(m::Natural)


main::IO ()
main = hspec $
  describe "Test test" $ do
    tupleProp
