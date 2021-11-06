{-# LANGUAGE TemplateHaskell #-}

module Test.HMC.Integrator (tests) where

import Data.Functor.Identity
import HMC.Integrator
import Hedgehog
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range

genInitialState :: Gen (Identity Double, Identity Double)
genInitialState =
  let genCoord = Identity <$> Gen.double (Range.constantFrom 0 (-10) 10)
   in (,) <$> genCoord <*> genCoord

prop_leapfrog_symplectic :: Property
prop_leapfrog_symplectic = property $ do
  let negGrad q = - q
      totalEnergy (q, p) = p ** 2 / 2 + q ** 2 / 2
      steps = 100
      dt = 0.01
  initState <- forAll genInitialState
  let step = runIntegrator leapfrog dt negGrad
      trajectory = take steps $ iterate step initState
  assert $ all (\s -> absRelDiff (totalEnergy initState) (totalEnergy s) < 1e-2) trajectory
  where
    absRelDiff i f = abs (f - i) / i

tests :: IO Bool
tests = checkParallel $$(discover)
