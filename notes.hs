{-# LANGUAGE MultilineStrings #-}

import Data.List

testNote = """
---
tags:
  - book
status: reading
rating:
aliases:
  - Structure and Interpretation of Computer Programs
  - SICP
author: "[[Harold Abelson and Gerald Jay Sussman]]"
title: Structure and Interpretation of Computer Programs
started: "[[2025-12-27]]"
cover: https://drive.konger.online/book-cover/sicp.png
---

# why i read
- gotta learn the programs!
# rev
"""

testNote2 = """
# why i read
- gotta learn the programs!
# rev
"""

data Note = Note {
    filename :: String
  , title :: String
  , frontMatter :: Maybe FrontMatter
  , content :: Maybe String
} deriving (Show)

type FrontMatter = [(String, String)]

parseNote :: String -> Note
parseNote x
  | isPrefixOf "---" x = Note {
        filename="testPref.md"
      , title="test"
      , frontMatter=Nothing
      , content=Just "test" }
  | otherwise = Note {
        filename="testNoPref.md"
      , title="test"
      , frontMatter=Nothing
      , content=Just x }

front = parseNote testNote
noFront = parseNote testNote2
