{-# LANGUAGE MultilineStrings #-}

import Text.ParserCombinators.Parsec

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

frontMatter = do
  string "---\n"
  entries <- manyTill yamlEntry (try yamlEnd)
  return entries

yamlEntry = do
  key <- many1 (noneOf ":\n")
  char ':'
  optional (char ' ')
  values <- yamlValue
  return (key, values)

yamlValue =
  try yamlValueMulti
  <|> try yamlValueWrappedSingle

yamlValueMulti = do
  char '\n' -- multi-entry values always start with AND are separated by \ns!
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

-- yeah, we SHOULD do this cross platform. thus: at least a variable
eol = char '\n'
