module Main where

import GHC
import GHC.Paths (libdir)
import DynFlags

import System.Environment

main :: IO ()
main = do
  args <- getArgs
  defaultErrorHandler defaultFatalMessager defaultFlushOut $
    runGhc (Just libdir) $ do
      dflags0 <- getSessionDynFlags
      let dflags1 = dflags0 {
          ghcMode   = CompManager
        , ghcLink   = LinkInMemory
        , hscTarget = HscInterpreted
        , optLevel  = 0
        , verbosity = 1
        }
      (dflags2, _, _) <- parseDynamicFlags dflags1 (map noLoc args)
      _ <- setSessionDynFlags dflags2

      target <- guessTarget "Main.hs" Nothing
      setTargets [target]

      _ <- load LoadAllTargets

      setContext [IIModule $ mkModuleName "Main"]

      return ()

