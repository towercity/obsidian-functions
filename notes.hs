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
type FrontMatterEntry = (String, FrontMatterValue)
data FrontMatterValue =
  Single String |
  Multiple [String] |
  Empty
  deriving (Show)

parseNoteContent :: String -> (Maybe FrontMatter, Maybe String)
parseNoteContent x
  | "---" `isPrefixOf` x = parseNoteContentWithFrontMatter x
  | otherwise = (Nothing, Just x)

parseNoteContentWithFrontMatter :: String -> (Maybe FrontMatter, Maybe String)
parseNoteContentWithFrontMatter x =
  (parseFrontMatter (takeWhile (/= "---") (drop 1 (lines x))), Just "yes")

parseFrontMatter :: [String] -> Maybe FrontMatter
parseFrontMatter xs =
  Just [("yes", Single "yes")]

foldFrontMatter :: String -> FrontMatter -> FrontMatter
foldFrontMatter line [] = [readFrontMatterLine line]
foldFrontMatter line ((key,Empty):xs) = [(key,Single"empty")]
  -- ABOVE: if line starts with bulletpoint (Data.Char isEmpty + dropWhile + isPrefix of to
  -- find), add to list, otherwise empty and move on (how diff empty untsted vs just not done?)
foldFrontMatter line ((key,value):xs) = [(key,value)]

readFrontMatterLine :: String -> FrontMatterEntry
readFrontMatterLine line
  | null values = (line, Empty)
  | otherwise = (key, Single (unwords values))
  where key:values = words line

-- buildFrontMatter :: String -> FrontMatterEntry -> FrontMatter

front = parseNoteContent testNote
noFront = parseNoteContent testNote2
