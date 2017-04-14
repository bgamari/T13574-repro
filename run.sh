#!/bin/bash

ghc -package ghc-paths -package ghc GhcTestcase.hs
./GhcTestcase
