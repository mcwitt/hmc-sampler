{-# LANGUAGE TemplateHaskell #-}

module Main where

import Hedgehog.Main
import Test.HMC.Integrator

main :: IO ()
main = defaultMain [Test.HMC.Integrator.tests]
