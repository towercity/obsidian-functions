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
  string "---"
  char '\n'
  entries <- manyTill yamlEntry (try yamlEnd)
  return entries

-- TODO: handle multiline lists
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
  char '\n'
  value <- many1 (string "  - " >> yamlValueSingle)
  --value <- yamlValueSingle
  return value

yamlValueWrappedSingle = do
	value <- yamlValueSingle
	return [value]

yamlValueSingle = do
	value <- manyTill anyChar eol
	return value

yamlEnd = do
  string "---"
  optional (char '\n')

eol = char '\n'
