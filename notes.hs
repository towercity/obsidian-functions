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

-- foldFrontMatter :: String -> FrontMatter -> FrontMatter
-- --foldFrontMatter line [] = [readFrontMatterLine line]
-- foldFrontMatter line ((key,value):xs) = [(key,value)]

readFrontMatterLine :: String -> (String, String)
readFrontMatterLine line
  -- key only line
  | ":" == value = (line, "")
  -- value only line
  | take 3 key == "  -" = ("", drop 4 key)
  -- key and value
  | not (null key) && not (null value) = (key, drop 2 value)
  -- just in case: let it be folded away
  | otherwise = ("", "")
  where (key,value) = break (== ':') line

-- buildFrontMatter :: String -> FrontMatterEntry -> FrontMatter

front = parseNoteContent testNote
noFront = parseNoteContent testNote2

deconstructFrontMatter :: String -> [String]
deconstructFrontMatter x = takeWhile (/= "---") (drop 1 (lines x))

frontMatterRead = deconstructFrontMatter testNote
-- step 1: map out the lines into key/vals
step1 = map readFrontMatterLine frontMatterRead
-- step 2: consolidate
--step2 = consolidateFrontMatter step1

consolidateFrontMatter :: FrontMatter -> [(String,String)] -> FrontMatter
consolidateFrontMatter _ [] = []
consolidateFrontMatter [] ((key,val):rest) = consolidateFrontMatter [(key,fmval)] rest
  where fmval = translateFrontMatterValue val

translateFrontMatterValue :: String -> FrontMatterValue
translateFrontMatterValue [] = Empty
translateFrontMatterValue string = Single string
-- how handle muluple?
