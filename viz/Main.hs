module Main where

import Diagrams.Backend.SVG.CmdLine
import Diagrams.Prelude
import HMC.Integrator

integrate :: Integrator V2 Double -> Double -> (V2 Double, V2 Double) -> [(V2 Double, V2 Double)]
integrate int dt = iterate step
  where
    grad (V2 x y) = let r3 = (x ** 2 + y ** 2) ** (3 / 2) in V2 (- x / r3) (- y / r3)
    step = runIntegrator int dt grad

draw :: Integrator V2 Double -> Double -> Int -> Diagram B
draw method dt n =
  integrate method dt (V2 1 0, V2 0 1)
    <&> P . fst
    & take n
    & fromVertices
    & strokeLine

main :: IO ()
main =
  mainWith $
    [ [ draw method dt n
        | (dt, n) <- [(0.3, 100), (0.1, 300)]
      ]
        & hsep 1
      | method <- [euler, modifiedEuler, leapfrog]
    ]
      & vsep 1
      & center
      & pad 1.1
