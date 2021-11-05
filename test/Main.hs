{-# LANGUAGE TemplateHaskell #-}

module Main where

import Hedgehog
import Hedgehog.Main
import HMC

prop_test :: Property
prop_test = property $ do
  doHMC === "HMC"

main :: IO ()
main = defaultMain [checkParallel $$(discover)]
