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

type FrontMatter = [FrontMatterEntry]
type FrontMatterEntry = (String, String)

parseNoteContent :: String -> (Maybe FrontMatter, Maybe String)
parseNoteContent x
  | "---" `isPrefixOf` x = parseNoteContentWithFrontMatter x
  | otherwise = (Nothing, Just x)

parseNoteContentWithFrontMatter :: String -> (Maybe FrontMatter, Maybe String)
parseNoteContentWithFrontMatter x =
  (parseFrontMatter (takeWhile (/= "---") (drop 1 (lines x))), Just "yes")

parseFrontMatter :: [String] -> Maybe FrontMatter
parseFrontMatter xs =
  Just [("yes", "yes")]

foldFrontMatter :: String -> FrontMatter -> FrontMatter
foldFrontMatter line [] = [(line,"")]
foldFrontMatter line ((a,""):xs) = [(a,"empty")]
foldFrontMatter line ((a,b):xs) = [(a,b)]
  -- | snd x == "" = (fst x, line):xs -- the blank second string == add string
  -- | otherwise = xs     -- otherwise, how do we account for multilines?

 -- x = current, xs = folded (i think)
-- TODO: separate function for handling all the options, to make it more readable

-- buildFrontMatter :: String -> FrontMatterEntry -> FrontMatter

front = parseNoteContent testNote
noFront = parseNoteContent testNote2
