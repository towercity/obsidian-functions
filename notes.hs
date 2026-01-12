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
foldFrontMatter line [] = [readFrontMatterLine line]
foldFrontMatter line ((a,""):xs) = [(a,"empty")]
foldFrontMatter line ((a,b):xs) = [(a,b)]

readFrontMatterLine :: String -> FrontMatterEntry
readFrontMatterLine line
  | null values = (line,"")
  | otherwise = (key, unwords values)
  where key:values = words line

-- buildFrontMatter :: String -> FrontMatterEntry -> FrontMatter

front = parseNoteContent testNote
noFront = parseNoteContent testNote2
