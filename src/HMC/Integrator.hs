module HMC.Integrator where

import Linear.Vector

newtype Integrator f a = Integrator
  {runIntegrator :: a -> (f a -> f a) -> (f a, f a) -> (f a, f a)}

euler :: (Additive f, Num a) => Integrator f a
euler = Integrator $ \dt grad (q, p) ->
  (q ^+^ dt *^ p, p ^+^ dt *^ grad q)

modifiedEuler :: (Additive f, Num a) => Integrator f a
modifiedEuler = Integrator $ \dt grad (q, p) ->
  let q' = q ^+^ dt *^ p
   in (q', p ^+^ dt *^ grad q')

leapfrog :: (Additive f, Fractional a) => Integrator f a
leapfrog =
  Integrator $ \dt grad (q, p) ->
    let dt2 = dt / 2
        p1 = p ^+^ dt2 *^ grad q
        q' = q ^+^ dt *^ p1
     in (q', p1 ^+^ dt2 *^ grad q')
