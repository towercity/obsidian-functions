{-# LANGUAGE MultilineStrings #-}

import Text.ParserCombinators.Parsec
import Control.Monad (void)

testYaml = """
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
"""

testContent = """
hello there
# why i read
- gotta learn the programs!
# rev
[[2022-01-02]]

this is that ne
eof
"""

type FrontMatter = [FrontMatterEntry]
type FrontMatterEntry = (String, FrontMatterValue)
type FrontMatterValue = [String]

type NoteContent = [Section]
data Section = Section {
    title   :: Maybe String -- maybe bc of pre-heading text
  , content :: String
} deriving (Show)

-- Font Matter
----

frontMatter :: Parser FrontMatter
frontMatter = do
  string "---"
  eol
  entries <- manyTill yamlEntry (try yamlEnd)
  return entries

yamlEntry :: Parser FrontMatterEntry
yamlEntry = do
  key <- many1 (noneOf ":\n")
  char ':'
  optional (char ' ')
  values <- yamlValue
  return (key, values)

yamlValue :: Parser FrontMatterValue
yamlValue =
  try yamlValueMulti
  <|> try yamlValueWrappedSingle

yamlValueMulti = do
  eol   -- multi-entry values always start with AND are separated by eols!
  value <- many1 (string "  - " >> yamlValueSingle)
  return value

-- we use this to properly wrap our single values to keep the same type as multi
-- entry values
yamlValueWrappedSingle = do
  value <- yamlValueSingle
  return [value]

-- we ALWAYS pass in pre-filtered text here, so we can just go to end of line
yamlValueSingle = manyTill anyChar eol

yamlEnd = do
  string "---"
  optional (char '\n')

-- Note Content
----

noteContent :: Parser NoteContent
noteContent = do
  pre  <- openingText
  rest <- many section
  return (pre : rest)

openingText :: Parser Section
openingText = do
  lines' <- mdLines
  return $ Section Nothing (unlines lines')

section :: Parser Section
section = do
  title  <- h1
  lines' <- mdLines
  return $ Section (Just title) (unlines lines')

mdLines :: Parser [String]
mdLines = manyTill mdLine (void (lookAhead h1) <|> eof)

h1 :: Parser String
h1 = do
  char '#'
  notFollowedBy (char '#')
  skipMany (char ' ')
  content <- mdLine
  return content

mdLine :: Parser String
mdLine = manyTill anyChar (void eol <|> eof)

-- Other
----

-- yeah, we SHOULD do this cross platform. thus: at least a variable
eol = char '\n'

main :: IO ()
main = do
  print (parse noteContent "(unknown)" testContent)
  return ()
